from flask import Flask, request, jsonify
import cx_Oracle
from openai import OpenAI
import os
from dotenv import load_dotenv  # dotenv 라이브러리 임포트

# .env 파일에서 환경 변수를 로드합니다.
load_dotenv()

app = Flask(__name__)

# 환경 변수에서 DB 연결 정보를 불러옵니다.
DB_USER = os.getenv("DB_USER")
DB_PW = os.getenv("DB_PASSWORD")
DB_DSN = os.getenv("DB_DSN")

print(f"Loaded DB_USER: {os.getenv('DB_USER')}")
print(f"Loaded DB_PW: {os.getenv('DB_PASSWORD')}") # 이 값이 올바르게 출력되는지 확인
print(f"Loaded DB_DSN: {os.getenv('DB_DSN')}")

# 환경 변수에서 OpenAI API Key를 불러옵니다.
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
client = OpenAI(api_key=OPENAI_API_KEY)


def extract_keywords_with_openai(text):
    """OpenAI API를 사용하여 기사 제목에서 핵심 키워드를 추출하는 함수"""
    try:
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system",
                 "content": "주어진 기사 제목에서 핵심 키워드를 추출하는 유용한 도우미입니다. 쉼표로 구분된 키워드 목록만 응답하세요. 다른 텍스트나 설명은 포함하지 마세요."},
                {"role": "user", "content": f"이 기사 제목에서 주요 키워드 5개까지 추출하세요: '{text}'"}
            ],
            temperature=0.3,
            max_tokens=50
        )

        keyword_string = response.choices[0].message.content.strip()
        keywords = [k.strip() for k in keyword_string.split(',') if k.strip()]

        print(f"Original Title: {text}")
        print(f"Extracted Keywords: {keywords}")

        return keywords

    except Exception as e:
        print(f"OpenAI API error: {e}")
        return []


def save_keywords_to_db(user_id, keywords):
    """추출된 키워드를 Oracle DB에 저장하는 함수"""
    connection = None
    try:
        connection = cx_Oracle.connect(DB_USER, DB_PW, DB_DSN, encoding="UTF-8")
        cursor = connection.cursor()

        for keyword in keywords:
            sql_check = "SELECT COUNT FROM KEYWORD WHERE KEYWORD = :keyword AND USER_ID = :user_id"
            cursor.execute(sql_check, keyword=keyword, user_id=user_id)
            result = cursor.fetchone()

            if result and result[0] > 0:
                sql_update = "UPDATE KEYWORD SET COUNT = COUNT + 1 WHERE KEYWORD = :keyword AND USER_ID = :user_id"
                cursor.execute(sql_update, keyword=keyword, user_id=user_id)
            else:
                sql_insert = "INSERT INTO KEYWORD (USER_ID, KEYWORD, COUNT) VALUES (:user_id, :keyword, 1)"
                cursor.execute(sql_insert, user_id=user_id, keyword=keyword)

        connection.commit()
        return True

    except cx_Oracle.Error as error:
        print("DB error:", error)
        return False

    finally:
        if connection:
            connection.close()


@app.route('/process_keyword', methods=['POST'])
def process_keyword():
    try:
        data = request.get_json()
        print(f"Received JSON data: {data}")  # **추가: 받은 데이터 확인**

        article_title = data.get('article_title')
        user_id = data.get('user_id')

        if not article_title or not user_id:
            print("Error: Missing article_title or user_id")  # **추가: 누락된 데이터 확인**
            return jsonify({"error": "Missing article_title or user_id"}), 400

        keywords = extract_keywords_with_openai(article_title)

        if not keywords:
            print("Error: Keyword extraction failed.")  # **추가: 키워드 추출 실패 확인**
            return jsonify({"error": "Keyword extraction failed."}), 500

        success = save_keywords_to_db(user_id, keywords)

        if success:
            print("Successfully saved keywords to DB.")  # **추가: 성공 로그**
            return jsonify(keywords), 200
        else:
            print("Error: Failed to save keywords to DB")  # **추가: DB 저장 실패 로그**
            return jsonify({"error": "Failed to save keywords to DB"}), 500

    except Exception as e:
        print(f"Internal Server Error occurred: {e}")  # **추가: 모든 예외를 잡는 로그**
        return jsonify({"error": "Internal Server Error"}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)