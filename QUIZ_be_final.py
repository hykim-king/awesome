import os
import schedule
import time
import cx_Oracle
from openai import OpenAI
from datetime import datetime
import logging
from dotenv import load_dotenv

load_dotenv()

# --- 1. 로깅 설정 ---
# 로그 포맷 지정: [시간] - [로그 수준] - [메시지]
log_formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)  # 로그 수준을 DEBUG로 설정

# 콘솔 출력용 핸들러
stream_handler = logging.StreamHandler()
stream_handler.setFormatter(log_formatter)
logger.addHandler(stream_handler)

# 파일 저장용 핸들러 (UTF-8 인코딩)
file_handler = logging.FileHandler('quiz_generator.log', encoding='utf-8')
file_handler.setFormatter(log_formatter)
logger.addHandler(file_handler)

# --- 2. 환경 설정 (정보를 코드에 직접 작성하는 방식) ---
DB_USER = os.getenv("DB_USER")
DB_PW = os.getenv("DB_PASSWORD")
DB_DSN = os.getenv("DB_DSN")

# --- 설정 값으로 OpenAI 클라이언트 초기화 ---
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
client = OpenAI(api_key=OPENAI_API_KEY)


def generate_and_save_quizzes():
    logger.info("퀴즈 생성 작업을 시작합니다...")
    conn = None  # conn 변수를 try 블록 외부에서 초기화
    try:
        # --- 3. 데이터베이스 연결 및 커서 확인 ---
        logger.debug("데이터베이스 연결 시도...")
        conn = cx_Oracle.connect(user=DB_USER, password=DB_PW, dsn=DB_DSN, encoding="UTF-8")

        # conn 객체가 성공적으로 생성되었는지 확인
        if conn:
            logger.info("데이터베이스에 성공적으로 연결되었습니다.")
            cursor = conn.cursor()

            # cursor 객체가 성공적으로 생성되었는지 확인
            if cursor:
                logger.info("데이터베이스 커서를 성공적으로 열었습니다.")

                # --- 이하 로직은 cursor가 유효할 때만 실행 ---
                query_insert_set = """
                    INSERT INTO QUIZ_SETS (QS_CODE, REG_DT)
                    VALUES (QS_SEQ.NEXTVAL, SYSDATE)
                    RETURNING QS_CODE INTO :new_qs_code
                """
                new_qs_code_var = cursor.var(int)
                cursor.execute(query_insert_set, new_qs_code=new_qs_code_var)
                new_qs_code = new_qs_code_var.getvalue()[0]
                logger.info(f"새로운 퀴즈 세트가 생성되었습니다 (QS_CODE: {new_qs_code}).")

                query_select_articles = """
                    SELECT ARTICLE_CODE, TITLE, SUMMARY
                    FROM (SELECT ARTICLE_CODE, TITLE, SUMMARY FROM ARTICLE ORDER BY VIEWS DESC)
                    WHERE ROWNUM <= 10
                """
                cursor.execute(query_select_articles)
                articles = cursor.fetchall()

                if len(articles) < 8:
                    logger.warning(f"퀴즈를 생성하기에 기사 수가 부족합니다 (현재 {len(articles)}개, 최소 8개 필요).")
                    conn.rollback()
                    return

                logger.info(f"퀴즈 생성을 위해 조회수 상위 {len(articles)}개 기사를 준비했습니다.")

                success_count = 0
                article_index = 0
                while success_count < 8:
                    if article_index >= len(articles):
                        logger.warning(f"준비된 기사를 모두 사용했지만 {success_count}개의 퀴즈만 생성했습니다. 루프를 종료합니다.")
                        break

                    article = articles[article_index]
                    article_code, title, summary = article
                    article_index += 1
                    question_no = success_count + 1

                    logger.info(f"({question_no}/8) '{title[:30]}...' 기사(Article_code: {article_code})로 퀴즈 생성 시도...")

                    prompt_text = f"""
                    아래는 뉴스 기사의 제목과 요약 내용입니다. 이 내용을 바탕으로 O/X 퀴즈 한 문제를 만들어 주세요.
                    문제는 반드시 주어진 내용만으로 참(O) 또는 거짓(X)을 판단할 수 있어야 합니다.
                    결과는 아래 형식을 정확히 따라서, 다른 설명 없이 내용만 한국어로 제공해주세요.
                    [기사 제목]: {title}
                    [기사 요약]: {summary}
                    --- 출력 형식 ---
                    문제: [여기에 퀴즈 문제 작성]
                    정답: [O 또는 X 중 하나만 작성]
                    해설: [여기에 정답에 대한 간단한 해설 작성]
                    """
                    try:
                        response = client.chat.completions.create(model="gpt-4", messages=[
                            {"role": "system", "content": "당신은 주어진 기사 제목과 기사 내용을 토대로 O/X 퀴즈를 만드는 유용한 AI입니다."},
                            {"role": "user", "content": prompt_text}], temperature=0.4)
                        quiz_content = response.choices[0].message.content.strip()
                        lines = quiz_content.split('\n')

                        if len(lines) < 3:
                            logger.warning(f"API 응답 형식이 올바르지 않습니다. 다음 기사로 넘어갑니다. (응답: {quiz_content})")
                            continue

                        question = lines[0].replace('문제:', '').strip()
                        answer = lines[1].replace('정답:', '').strip().upper()
                        explanation = lines[2].replace('해설:', '').strip()

                        if answer not in ['O', 'X']:
                            logger.warning(f"정답이 'O' 또는 'X'가 아닙니다. 다음 기사로 넘어갑니다. (정답: '{answer}')")
                            continue

                        logger.debug(f"Q{question_no}: 문제:{question}, 정답:{answer}, 해설:{explanation}")

                        query_insert_quiz = "INSERT INTO QUIZ_QUESTIONS (QS_CODE, QQ_CODE, ARTICLE_CODE, QUESTION_NO, QUESTION, ANSWER, EXPLANATION, REG_DT) VALUES (:qs_code, QQC_SEQ.NEXTVAL, :article_code, :question_no, :question, :answer, :explanation, SYSDATE)"
                        cursor.execute(query_insert_quiz, qs_code=new_qs_code, article_code=article_code,
                                       question_no=question_no, question=question, answer=answer,
                                       explanation=explanation)

                        success_count += 1
                        logger.info(f"Q{question_no} 생성 및 저장 성공.")

                    except Exception:
                        logger.exception(f"내부 루프 오류: 기사(코드: {article_code}) 처리 중 문제가 발생하여 건너뜁니다.")
                        continue

                conn.commit()
                logger.info(f"총 {success_count}개의 퀴즈를 성공적으로 생성하고 데이터베이스에 커밋했습니다. (퀴즈 세트 코드: {new_qs_code})")

    except cx_Oracle.Error as error:
        logger.exception("데이터베이스 오류가 발생했습니다.")
        if conn:
            conn.rollback()
            logger.info("데이터베이스 변경사항을 롤백했습니다.")
    except Exception:
        logger.exception("알 수 없는 오류가 발생했습니다.")
        if conn:
            conn.rollback()
            logger.info("데이터베이스 변경사항을 롤백했습니다.")
    finally:
        if conn:
            cursor.close()
            conn.close()
            logger.info("데이터베이스 연결 및 커서를 모두 닫았습니다.")


# --- 스케줄러 설정 ---
schedule.every().day.at("12:00").do(generate_and_save_quizzes)

logger.info("퀴즈 생성 프로그램이 시작되었습니다. 매일 오전 12시에 자동으로 실행됩니다.")
logger.info("지금 즉시 테스트 실행을 원하시면 아래 주석을 해제하세요.")
#generate_and_save_quizzes()  # 즉시 실행 테스트용

while True:
    schedule.run_pending()
    time.sleep(1)