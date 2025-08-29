import feedparser
import schedule
import time
import re
import cx_Oracle
from datetime import datetime
import logging
import logging.handlers

# --- 로깅 설정 ---
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
formatter = logging.Formatter(
    '%(asctime)s - %(levelname)s - [%(funcName)s:%(lineno)d] - %(message)s'
)
stream_handler = logging.StreamHandler()
stream_handler.setFormatter(formatter)
logger.addHandler(stream_handler)
file_handler = logging.FileHandler('news_scraper.log', encoding='utf-8')
file_handler.setFormatter(formatter)
logger.addHandler(file_handler)

# --- 설정 부분 ---
DB_CONFIG = {
    'user': 'awesome',
    'password': 'a4321',
    'dsn': '192.168.100.30:1522/XE'
}
TABLE_NAME = 'ARTICLE'
SEQUENCE_NAME = 'AR_SEQ'

CATEGORY_MAP = {
    '정치': 10, '경제': 20, '사회': 30, '대중문화': 30, '문화': 30,
    '문화/라이프': 30, '스포츠': 40, '연예': 50, 'IT/과학': 60,
    '과학': 60, '과학·환경': 60
}

RSS_FEEDS = [
    # (RSS 피드 목록은 이전과 동일하므로 생략)
    # 한겨례
    {'name': '한겨례', 'category': '정치', 'url': 'https://www.hani.co.kr/rss/politics/'},
    {'name': '한겨례', 'category': '경제', 'url': 'https://www.hani.co.kr/rss/economy/'},
    {'name': '한겨례', 'category': '사회', 'url': 'https://www.hani.co.kr/rss/society/'},
    {'name': '한겨례', 'category': '대중문화', 'url': 'https://www.hani.co.kr/rss/culture/'},
    {'name': '한겨례', 'category': '스포츠', 'url': 'https://www.hani.co.kr/rss/sports/'},
    {'name': '한겨례', 'category': '과학', 'url': 'https://www.hani.co.kr/rss/science/'},
    # 조선일보
    {'name': '조선일보', 'category': '정치',
     'url': 'https://www.chosun.com/arc/outboundfeeds/rss/category/politics/?outputType=xml'},
    {'name': '조선일보', 'category': '경제',
     'url': 'https://www.chosun.com/arc/outboundfeeds/rss/category/economy/?outputType=xml'},
    {'name': '조선일보', 'category': '사회',
     'url': 'https://www.chosun.com/arc/outboundfeeds/rss/category/national/?outputType=xml'},
    {'name': '조선일보', 'category': '문화/라이프',
     'url': 'https://www.chosun.com/arc/outboundfeeds/rss/category/culture-life/?outputType=xml'},
    {'name': '조선일보', 'category': '스포츠',
     'url': 'https://www.chosun.com/arc/outboundfeeds/rss/category/sports/?outputType=xml'},
    {'name': '조선일보', 'category': '연예',
     'url': 'https://www.chosun.com/arc/outboundfeeds/rss/category/entertainments/?outputType=xml'},
    # 동아일보
    {'name': '동아일보', 'category': '정치', 'url': 'https://rss.donga.com/politics.xml'},
    {'name': '동아일보', 'category': '경제', 'url': 'https://rss.donga.com/economy.xml'},
    {'name': '동아일보', 'category': '사회', 'url': 'https://rss.donga.com/national.xml'},
    {'name': '동아일보', 'category': '스포츠', 'url': 'https://rss.donga.com/sports.xml'},
    {'name': '동아일보', 'category': '연예', 'url': 'https://rss.donga.com/culture.xml'},
    # 연합뉴스
    {'name': '연합뉴스', 'category': '정치', 'url': 'https://www.yna.co.kr/rss/politics.xml'},
    {'name': '연합뉴스', 'category': '경제', 'url': 'https://www.yna.co.kr/rss/economy.xml'},
    {'name': '연합뉴스', 'category': '문화', 'url': 'https://www.yna.co.kr/rss/culture.xml'},
    {'name': '연합뉴스', 'category': '연예', 'url': 'https://www.yna.co.kr/rss/entertainment.xml'},
    {'name': '연합뉴스', 'category': '스포츠', 'url': 'https://www.yna.co.kr/rss/sports.xml'},
    # 경향신문
    {'name': '경향신문', 'category': '정치', 'url': 'https://www.khan.co.kr/rss/rssdata/politic_news.xml'},
    {'name': '경향신문', 'category': '경제', 'url': 'https://www.khan.co.kr/rss/rssdata/economy_news.xml'},
    {'name': '경향신문', 'category': '사회', 'url': 'https://www.khan.co.kr/rss/rssdata/society_news.xml'},
    {'name': '경향신문', 'category': '문화', 'url': 'https://www.khan.co.kr/rss/rssdata/culture_news.xml'},
    {'name': '경향신문', 'category': '스포츠', 'url': 'http://www.khan.co.kr/rss/rssdata/kh_sports.xml'},
    {'name': '경향신문', 'category': '과학·환경', 'url': 'https://www.khan.co.kr/rss/rssdata/science_news.xml'},
    # 세계일보
    {'name': '세계일보', 'category': '정치', 'url': 'https://www.segye.com/Articles/RSSList/segye_politic.xml'},
    {'name': '세계일보', 'category': '경제', 'url': 'https://www.segye.com/Articles/RSSList/segye_economy.xml'},
    {'name': '세계일보', 'category': '사회', 'url': 'https://www.segye.com/Articles/RSSList/segye_society.xml'},
    {'name': '세계일보', 'category': '문화', 'url': 'https://www.segye.com/Articles/RSSList/segye_culture.xml'},
    {'name': '세계일보', 'category': '연예', 'url': 'https://www.segye.com/Articles/RSSList/segye_entertainment.xml'},
    {'name': '세계일보', 'category': '스포츠', 'url': 'https://www.segye.com/Articles/RSSList/segye_sports.xml'},
]


# --- DB 및 유틸리티 함수 ---

def get_db_connection():
    # (수정 없음, 이전과 동일)
    logger.debug("DB 연결 시도 중...")
    try:
        connection = cx_Oracle.connect(user=DB_CONFIG['user'], password=DB_CONFIG['password'], dsn=DB_CONFIG['dsn'],
                                       encoding="UTF-8")
        logger.info("데이터베이스 연결 성공")
        return connection
    except cx_Oracle.Error as e:
        logger.error(f"데이터베이스 연결 실패: {e}", exc_info=True)
        return None


def load_processed_links_from_db(cursor):
    # (수정 없음, 이전과 동일)
    logger.debug("DB에서 기 처리된 URL 로드 시작...")
    try:
        cursor.execute(f"SELECT URL FROM {TABLE_NAME}")
        processed_links = {row[0] for row in cursor.fetchall()}
        logger.debug(f"총 {len(processed_links)}개의 기 처리된 URL 로드 완료")
        return processed_links
    except cx_Oracle.Error as e:
        logger.error(f"처리된 링크 로딩 중 DB 오류 발생: {e}", exc_info=True)
        return set()


def get_summary(entry, name):
    # (수정 없음, 이전과 동일)
    logger.debug(f"'{name}' 기사의 요약 정보 추출 시작")
    summary_raw = ''
    if name == '한겨례':
        summary_raw = entry.get('dc_subject')
    elif name == '조선일보':
        summary_raw = entry.get('summary')
    else:
        summary_raw = entry.get('description')
    if not summary_raw:
        summary_raw = entry.get('summary') or entry.get('description') or ''
        logger.debug("지정된 요약 필드가 없어 'summary' 또는 'description' 필드로 대체")
    summary_text = re.sub(r'<.*?>', '', summary_raw).strip()
    if not summary_text:
        logger.warning(f"요약 정보를 찾을 수 없음. 기사 제목을 요약으로 대체합니다. (URL: {entry.get('link', '')})")
        return entry.get('title', '(요약 정보 없음)').strip()
    logger.debug(f"요약 추출 완료: {summary_text[:50]}...")
    return summary_text


def insert_article(cursor, article_data):
    """파싱된 기사 데이터를 데이터베이스에 삽입합니다."""
    # [최종 수정] INSERT 구문에 REG_DT, MOD_DT 컬럼과 바인드 변수 추가
    sql = f"""
        INSERT INTO {TABLE_NAME} (
            ARTICLE_CODE, CATEGORY, PRESS, TITLE, SUMMARY, URL, 
            PUBLIC_DT, VIEWS, REG_DT, MOD_DT
        ) VALUES (
            {SEQUENCE_NAME}.NEXTVAL, :category, :press, :title, :summary, :url, 
            :public_dt, :views, :reg_dt, :mod_dt
        )
    """
    title_short = article_data['title'][:30]
    logger.debug(f"'{title_short}...' 기사 DB 저장 시도")
    try:
        cursor.execute(sql, article_data)
        logger.info(f"[DB 저장 완료] {title_short}...")
    except cx_Oracle.Error as e:
        logger.error(f"[DB 저장 실패] {title_short}... 오류: {e}", exc_info=True)


# --- RSS 파싱 및 처리 함수 ---

def fetch_and_process_feed(cursor, feed_info, processed_links_set):
    """하나의 RSS 피드를 가져와 새로운 기사를 DB에 저장하는 함수"""
    name = feed_info['name']
    category_name = feed_info['category']
    url = feed_info['url']
    category_code = CATEGORY_MAP.get(category_name, 999)  # 기본값 999 (기타)

    logger.info(f"--- [{name} - {category_name}] 피드 확인 시작 (URL: {url}) ---")
    try:
        feed = feedparser.parse(url)
        if feed.bozo:
            logger.warning(f"피드 파싱 중 문제가 발생했습니다 (bozo=1). URL: {url}, 원인: {feed.bozo_exception}")
        if not feed.entries:
            logger.warning("피드에 기사가 없습니다.")
            return

        logger.debug(f"피드에서 {len(feed.entries)}개의 기사 발견. 최신 5개 확인 시작.")
        new_articles_found = 0
        for entry in feed.entries[:30]:
            link = entry.get('link', '').strip()
            if not link or link in processed_links_set:
                continue

            new_articles_found += 1
            logger.info(f"새로운 기사 발견: {link}")

            # [수정됨] 발행 시간 처리 로직 강화
            published_dt = None
            if hasattr(entry, 'published_parsed') and entry.published_parsed:
                try:
                    published_dt = datetime.fromtimestamp(time.mktime(entry.published_parsed))
                except TypeError:
                    logger.warning(f"발행 시간의 형식이 잘못되어 현재 시간으로 대체합니다. [URL: {link}]")
                    published_dt = datetime.now()
            else:
                logger.warning(f"발행 시간을 찾을 수 없어 현재 시간으로 대체합니다. [URL: {link}]")
                published_dt = datetime.now()

            now = datetime.now()
            article_data = {
                'category': category_code,
                'press': name,
                'title': entry.get('title', '(제목 없음)'),
                'summary': get_summary(entry, name),
                'url': link,
                'public_dt': published_dt,
                'views': 0,
                'reg_dt': now,
                'mod_dt': now
            }
            logger.debug(f"DB 저장용 데이터 준비 완료: {article_data}")
            insert_article(cursor, article_data)
            processed_links_set.add(link)

        if new_articles_found == 0:
            logger.info("새로운 기사가 없습니다.")

    except Exception as e:
        logger.error(f"피드 처리 중 예측하지 못한 오류 발생: {e}", exc_info=True)


# def fetch_and_process_feed(cursor, feed_info, processed_links_set):
#     # (이전과 대부분 동일, article_data 생성 부분만 변경)
#     name = feed_info['name']
#     category_name = feed_info['category']
#     url = feed_info['url']
#     category_code = CATEGORY_MAP.get(category_name, 999)
#
#     logger.info(f"--- [{name} - {category_name}] 피드 확인 시작 (URL: {url}) ---")
#     try:
#         feed = feedparser.parse(url)
#         if feed.bozo:
#             logger.warning(f"피드 파싱 중 문제가 발생했습니다 (bozo=1). URL: {url}, 원인: {feed.bozo_exception}")
#         if not feed.entries:
#             logger.warning("피드에 기사가 없습니다.")
#             return
#
#         logger.debug(f"피드에서 {len(feed.entries)}개의 기사 발견. 최신 5개 확인 시작.")
#         new_articles_found = 0
#         for entry in feed.entries[:5]:
#             link = entry.get('link', '').strip()
#             if not link or link in processed_links_set:
#                 continue
#
#             new_articles_found += 1
#             logger.info(f"새로운 기사 발견: {link}")
#
#             try:
#                 published_dt = datetime.fromtimestamp(time.mktime(entry.published_parsed))
#             except AttributeError:
#                 logger.warning("발행 시간이 없어 현재 시간으로 대체합니다.")
#                 published_dt = datetime.now()
#
#             # [최종 수정] article_data에 reg_dt와 mod_dt 추가
#             now = datetime.now()
#             article_data = {
#                 'category': category_code,
#                 'press': name,
#                 'title': entry.get('title', '(제목 없음)'),
#                 'summary': get_summary(entry, name),
#                 'url': link,
#                 'public_dt': published_dt,
#                 'views': 0,
#                 'reg_dt': now,
#                 'mod_dt': now
#             }
#             logger.debug(f"DB 저장용 데이터 준비 완료: {article_data}")
#             insert_article(cursor, article_data)
#             processed_links_set.add(link)
#
#         if new_articles_found == 0:
#             logger.info("새로운 기사가 없습니다.")
#
#     except Exception as e:
#         logger.error(f"피드 처리 중 예측하지 못한 오류 발생: {e}", exc_info=True)


# --- 메인 실행 함수 ---

def run_scraper():
    # (수정 없음, 이전과 동일)
    current_time = time.strftime('%Y-%m-%d %H:%M:%S')
    logger.info(f"\n==================== 뉴스 수집 시작 ({current_time}) ====================")
    connection = get_db_connection()
    if not connection:
        logger.critical("DB 연결 실패. 작업을 중단합니다.")
        return
    cursor = None
    try:
        cursor = connection.cursor()
        logger.debug("DB 커서 생성 완료")
        processed_links = load_processed_links_from_db(cursor)
        for feed_info in RSS_FEEDS:
            fetch_and_process_feed(cursor, feed_info, processed_links)
            time.sleep(0.5)
        connection.commit()
        logger.info("모든 작업 완료. 데이터베이스에 변경사항을 커밋했습니다.")

    except Exception as e:
        logger.critical(f"작업 중 심각한 오류 발생: {e}", exc_info=True)
        if connection:
            try:
                connection.rollback()
                logger.warning("오류가 발생하여 데이터베이스 변경사항을 롤백했습니다.")
            except cx_Oracle.Error as rb_e:
                logger.error(f"롤백 중 오류 발생: {rb_e}", exc_info=True)
    finally:
        if cursor:
            cursor.close()
            logger.debug("DB 커서를 닫았습니다.")
        if connection:
            connection.close()
            logger.info("데이터베이스 연결을 닫았습니다.")
    logger.info(f"==================== 뉴스 수집 완료 ({current_time}) ====================\n")


if __name__ == "__main__":
    # (수정 없음, 이전과 동일)
    logger.info("스크립트를 시작합니다. 초기 수집 작업을 1회 실행합니다.")
    run_scraper()
    schedule.every(5).minutes.do(run_scraper)
    logger.info("스케줄러가 시작되었습니다. 5분마다 새로운 기사를 확인하고 DB에 저장합니다.")
    logger.info("프로그램을 종료하려면 Ctrl+C를 누르세요.")
    try:
        while True:
            schedule.run_pending()
            time.sleep(1)
    except KeyboardInterrupt:
        logger.info("사용자에 의해 프로그램이 중지되었습니다. 스케줄러를 종료합니다.")