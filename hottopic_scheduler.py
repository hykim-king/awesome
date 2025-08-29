# hot_topic_scheduler.py
import os
import sys
import logging
import openai
import cx_Oracle
from dotenv import load_dotenv
from collections import Counter
from apscheduler.schedulers.blocking import BlockingScheduler
from datetime import datetime


# --- 1. 환경 변수 및 로깅 설정 ---

def setup_logging():
    """DEBUG 수준의 로그를 콘솔과 파일에 모두 기록하도록 설정합니다."""
    log_file_path = os.getenv("LOG_FILE_PATH", "final_hot_topic.log")
    logger = logging.getLogger()
    if logger.hasHandlers():
        logger.handlers.clear()

    logger.setLevel(logging.DEBUG)
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')

    stream_handler = logging.StreamHandler(sys.stdout)
    stream_handler.setFormatter(formatter)
    logger.addHandler(stream_handler)

    log_dir = os.path.dirname(log_file_path)
    if log_dir and not os.path.exists(log_dir):
        os.makedirs(log_dir)
    file_handler = logging.FileHandler(log_file_path, encoding='utf-8')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)

    logging.info("로깅 설정이 완료되었습니다.")


# .env 파일 로드
load_dotenv()
setup_logging()


# --- 2. 핵심 기능 함수 ---

def check_connections():
    """스크립트 시작 전 Oracle DB 및 OpenAI API 연결을 확인합니다."""
    logging.info("=" * 20 + " 필수 연결 상태 확인 시작 " + "=" * 20)
    all_connected = True

    # OpenAI API 키 확인
    openai.api_key = os.getenv("OPENAI_API_KEY")
    if not openai.api_key:
        logging.critical("OpenAI API 키가 설정되지 않았습니다. .env 파일을 확인해주세요.")
        all_connected = False
    else:
        try:
            # 간단한 API 호출로 실제 연결 테스트
            openai.models.list()
            logging.info("OpenAI API 연결에 성공했습니다.")
        except Exception as e:
            logging.critical(f"OpenAI API에 연결할 수 없습니다: {e}", exc_info=True)
            all_connected = False

    # Oracle 데이터베이스 연결 확인
    db_user = os.getenv("DB_USER")
    db_password = os.getenv("DB_PASSWORD")
    db_dsn = os.getenv("DB_DSN")

    if not all([db_user, db_password, db_dsn]):
        logging.critical("데이터베이스 연결 정보(USER, PASSWORD, DSN)가 .env 파일에 모두 설정되지 않았습니다.")
        all_connected = False
    else:
        try:
            with cx_Oracle.connect(user=db_user, password=db_password, dsn=db_dsn) as conn:
                logging.info(f"Oracle 데이터베이스에 성공적으로 연결되었습니다. (버전: {conn.version})")
        except cx_Oracle.DatabaseError as db_err:
            logging.critical(f"Oracle 데이터베이스 연결 실패: {db_err}", exc_info=True)
            all_connected = False
        except Exception as e:
            logging.critical(f"데이터베이스 연결 중 예상치 못한 오류 발생: {e}", exc_info=True)
            all_connected = False

    logging.info("=" * 25 + " 연결 상태 확인 종료 " + "=" * 25)
    return all_connected


def find_single_hot_topic(keywords: list) -> str:
    """키워드 리스트 내에서 가장 빈도가 높은 단일 토픽을 찾습니다. (동점 시 가나다순)"""
    if not keywords:
        return "N/A"

    counts = Counter(keywords)
    logging.debug(f"내부 키워드 빈도수: {dict(counts)}")
    max_count = max(counts.values())
    candidates = sorted([key for key, value in counts.items() if value == max_count])
    return candidates[0]


def analyze_hot_topics() -> dict:
    """카테고리별로 단일 대표 핫 토픽을 분석합니다."""
    logging.info("카테고리별 대표 핫 토픽 분석을 시작합니다.")

    CATEGORIES = {
        "정치": 10, "경제": 20, "사회/문화": 30,
        "스포츠": 40, "연예": 50, "IT/과학": 60
    }
    hot_topics_by_category = {}

    db_user = os.getenv("DB_USER")
    db_password = os.getenv("DB_PASSWORD")
    db_dsn = os.getenv("DB_DSN")

    # analyze_hot_topics 내에서 DB 연결 및 예외 처리
    try:
        with cx_Oracle.connect(user=db_user, password=db_password, dsn=db_dsn) as conn:
            logging.debug("분석을 위한 데이터베이스 연결 성공.")
            for category_name, category_code in CATEGORIES.items():
                logging.info(f"--- '{category_name}({category_code})' 카테고리 처리 중 ---")

                with conn.cursor() as cursor:
                    # 최근 12시간 내 기사 50건 조회
                    query = "SELECT TITLE FROM (SELECT TITLE FROM ARTICLE WHERE CATEGORY = :cat_code AND REG_DT >= SYSDATE - 0.5 ORDER BY REG_DT DESC) WHERE ROWNUM <= 50"
                    cursor.execute(query, cat_code=category_code)
                    articles = cursor.fetchall()

                if not articles:
                    logging.warning(f"'{category_name}' 카테고리에 분석할 최신 기사가 없습니다.")
                    hot_topics_by_category[category_name] = ("분석할 기사 없음", category_code)
                    continue

                titles_text = "\n".join([row[0] for row in articles if row[0]])

                prompt = f"다음 '{category_name}' 분야 뉴스 제목들에서 가장 핵심적인 키워드를 15개 추출해줘. 쉼표로만 구분해서 응답해줘:\n{titles_text}"
                response = openai.chat.completions.create(
                    model="gpt-4o-mini",
                    messages=[{"role": "user", "content": prompt}],
                    temperature=0.3
                )
                keywords_str = response.choices[0].message.content.strip()
                category_keywords_list = [k.strip() for k in keywords_str.split(',')]
                logging.debug(f"'{category_name}' 카테고리에서 추출된 키워드 목록: {category_keywords_list}")

                single_hot_topic = find_single_hot_topic(category_keywords_list)
                hot_topics_by_category[category_name] = (single_hot_topic, category_code)

        logging.info("핫 토픽 분석이 완료되었습니다.")
        return hot_topics_by_category

    except cx_Oracle.DatabaseError as db_err:
        logging.critical(f"분석 중 데이터베이스 오류 발생: {db_err}", exc_info=True)
        return None  # 오류 발생 시 None 반환
    except openai.APIError as api_err:
        logging.critical(f"분석 중 OpenAI API 오류 발생: {api_err}", exc_info=True)
        return None
    except Exception as e:
        logging.critical(f"분석 프로세스 중 예상치 못한 오류 발생: {e}", exc_info=True)
        return None


def save_hot_topics_to_db(hot_topics: dict, update_period: str):
    """분석된 핫 토픽 결과를 DAILY_KEYWORD 테이블에 저장합니다."""
    logging.info(f"분석된 핫 토픽을 데이터베이스에 저장합니다. (업데이트 주기: {update_period})")

    db_user = os.getenv("DB_USER")
    db_password = os.getenv("DB_PASSWORD")
    db_dsn = os.getenv("DB_DSN")

    # 데이터베이스에 저장할 데이터 리스트 생성
    data_to_insert = []
    for category_name, (topic, category_code) in hot_topics.items():
        # (DK_DT, UPDATE_PERIOD, CATEGORY, KEYWORD) 순서의 튜플
        # DK_CODE는 SEQUENCE가 자동으로 채우므로 명시하지 않음
        data_to_insert.append((
            datetime.now(),
            update_period,
            category_code,
            topic
        ))
        logging.debug(f"DB 저장 준비: {category_name} - {topic}")

    if not data_to_insert:
        logging.warning("데이터베이스에 저장할 데이터가 없습니다.")
        return

    try:
        with cx_Oracle.connect(user=db_user, password=db_password, dsn=db_dsn) as conn:
            with conn.cursor() as cursor:
                # DK_SEQ 시퀀스를 사용하여 DK_CODE 자동 생성
                # 테이블 구조에 맞게 컬럼 순서 지정: DK_DT, UPDATE_PERIOD, CATEGORY, KEYWORD
                insert_query = """
                    INSERT INTO DAILY_KEYWORD (DK_CODE, DK_DT, UPDATE_PERIOD, CATEGORY, KEYWORD)
                    VALUES (DK_SEQ.NEXTVAL, :1, :2, :3, :4)
                """
                # executemany를 사용하여 여러 행을 효율적으로 삽입
                cursor.executemany(insert_query, data_to_insert, batcherrors=True)

                # 배치 오류 확인
                for error in cursor.getbatcherrors():
                    logging.error(f"행 {error.offset} 삽입 중 오류 발생: {error.message}")

                conn.commit()
                logging.info(f"{len(data_to_insert) - len(cursor.getbatcherrors())}개의 핫 토픽이 데이터베이스에 성공적으로 저장되었습니다.")

    except cx_Oracle.DatabaseError as db_err:
        logging.critical(f"데이터베이스 저장 중 오류 발생: {db_err}", exc_info=True)
    except Exception as e:
        logging.critical(f"데이터베이스 저장 중 예상치 못한 오류 발생: {e}", exc_info=True)


# --- 3. 스케줄링 및 메인 로직 ---

def main_process():
    """핫 토픽 분석 및 저장을 위한 전체 프로세스를 실행합니다."""

    current_hour = datetime.now().hour
    # 스케줄러의 시간 오차를 감안하여 넓은 범위로 체크
    if 9 <= current_hour < 12:
        update_period = "AM"
        logging.info("=" * 20 + f" 오전(AM) 핫 토픽 분석 작업 시작 (Triggered at: {datetime.now()}) " + "=" * 20)
    else:
        update_period = "PM"
        logging.info("=" * 20 + f" 오후(PM) 핫 토픽 분석 작업 시작 (Triggered at: {datetime.now()}) " + "=" * 20)

    # 1. 핫 토픽 분석
    final_results = analyze_hot_topics()

    # 2. 분석 결과 확인 및 DB 저장
    if final_results:
        logging.info("=" * 28 + " 최종 분석 결과 " + "=" * 28)
        for category, (topic, _) in final_results.items():
            logging.info(f"금일 {category}의 핫 토픽은 '{topic}' 입니다")
        logging.info("=" * 68)

        # 분석 결과를 데이터베이스에 저장
        save_hot_topics_to_db(final_results, update_period)
    else:
        logging.error("최종 핫 토픽 분석에 실패했습니다. 상세 내용은 위 로그를 확인해주세요.")

    logging.info("=" * 28 + " 작업 완료 " + "=" * 28 + "\n")


if __name__ == '__main__':
    # 스크립트 시작 시 필수 연결 요소들을 먼저 확인
    if not check_connections():
        logging.critical("필수 연결(DB 또는 API)에 실패하여 스케줄러를 시작하지 않고 프로그램을 종료합니다.")
        sys.exit(1)  # 오류 코드를 반환하며 종료

    # 스케줄러 설정
    scheduler = BlockingScheduler(timezone='Asia/Seoul')

    # 매일 오전 10시, 오후 6시에 main_process 함수 실행
    scheduler.add_job(main_process, 'cron', hour='10,18', minute='00')

    logging.info("스케줄러가 시작되었습니다. 다음 작업 시간까지 대기합니다...")
    logging.info("오전 10시와 오후 6시에 작업이 실행될 예정입니다.")
    logging.info("Ctrl+C를 눌러 스케줄러를 종료할 수 있습니다.")

    try:
        scheduler.start()
    except (KeyboardInterrupt, SystemExit):
        logging.info("스케줄러가 종료되었습니다.")