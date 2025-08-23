package com.pcwk.ehr.userLog;

import static org.junit.jupiter.api.Assertions.*;

import java.util.Date;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import com.pcwk.ehr.userLog.domain.UserLogDTO;
import com.pcwk.ehr.userLog.service.UserLogService;
import com.pcwk.ehr.article.domain.ArticleDTO;
import com.pcwk.ehr.mapper.UserLogMapper; // 초기화(deleteAll)용

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {
    "file:src/main/webapp/WEB-INF/spring/root-context.xml",
    "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
public class UserLogServiceTest {

    Logger log = LogManager.getLogger(getClass());

    @Autowired
    UserLogService service;

    // 초기화/검증 편의용(서비스엔 deleteAll이 없으므로)
    @Autowired
    UserLogMapper mapper;

    // 추후 실제 존재하는 코드
    Long articleCode = 7384L;

    @BeforeEach
    void setUp() {
        mapper.deleteAll();
        log.debug("user_click_log 전체삭제");
    }

    @AfterEach
    void tearDown() {
        log.debug("--------- @AfterEach ---------");
    }
    @Disabled
    @Test
    @DisplayName("logArticleClick: 정상 저장 후 getLogsByUser로 확인")
    void logArticleClick_success() {
        // given
        String userId = "user01";

        // when
        service.logArticleClick(userId, articleCode);

        // then
        List<UserLogDTO> list = service.getLogsByUser(userId);
        assertEquals(1, list.size(), "user01 로그 1건이어야 함");
        UserLogDTO out = list.get(0);
        assertEquals(userId, out.getUserId());
        assertEquals(articleCode, out.getArticleCode());
        assertNotNull(out.getLogCode(), "selectKey로 logCode 생성되어야 함");
        assertNotNull(out.getClickedAt(), "clickedAt은 SYSDATE로 저장되어야 함");
    }
    @Disabled
    @Test
    @DisplayName("logArticleClick: 비로그인(null) 또는 잘못된 파라미터는 저장하지 않음")
    void logArticleClick_invalidParams() {
        // when
        service.logArticleClick(null, articleCode);      // userId null
        service.logArticleClick("user01", null);         // articleCode null

        // then
        List<UserLogDTO> list = service.getAllLogs();
        assertEquals(0, list.size(), "잘못된 파라미터는 저장되면 안 됨");
    }
    @Disabled
    @Test
    @DisplayName("getAllLogs: 다건 저장 후 전체 조회")
    void getAllLogs_multiple() {
        // given
        service.logArticleClick("user01", articleCode);
        service.logArticleClick("user02", articleCode);
        service.logArticleClick("user03", articleCode);

        // when
        List<UserLogDTO> list = service.getAllLogs();

        // then
        assertEquals(3, list.size(), "전체 로그 3건이어야 함");
        list.forEach(log::debug);
    }

	@Disabled
    @Test
    @DisplayName("deleteLog: 단건 삭제")
    void deleteLog_success() {
        // given
        String userId = "user01";
        service.logArticleClick(userId, articleCode);
        List<UserLogDTO> before = service.getLogsByUser(userId);
        assertEquals(1, before.size(), "사전 저장 확인");
        long logCode = before.get(0).getLogCode();

        // when
        int flag = service.deleteLog(logCode);

        // then
        assertEquals(1, flag, "deleteLog 성공 여부 확인");
        List<UserLogDTO> after = service.getLogsByUser(userId);
        assertEquals(0, after.size(), "삭제 후 해당 사용자 로그는 0건이어야 함");
    }
	
	@Test
	@DisplayName("getRecommendedArticlesByUser: 유저 기반 추천 기사 3건 확인")
	void getRecommendedArticlesByUser_success() {
	    // given
	    String userId = "user01";

	    // 사전 로그 저장 (같은 카테고리 기사들을 여러 번 클릭한 시뮬레이션)
	    for (int i = 0; i < 5; i++) {
	        service.logArticleClick(userId, articleCode); // 이 articleCode의 category가 추천 대상이 됨
	    }

	    // when
	    List<ArticleDTO> recommendedList = service.getRecommendedArticlesByUser(userId);

	    // then
	    assertNotNull(recommendedList, "추천 결과는 null이면 안 됨");
	    assertTrue(recommendedList.size() <= 3, "추천 기사 개수는 최대 3개");

	    for (ArticleDTO article : recommendedList) {
	        log.debug("추천 기사 ▶ {}", article.getTitle());
	        assertNotNull(article.getArticleCode());
	        assertNotNull(article.getTitle());
	        assertTrue(article.getViews() >= 0);
	    }
	}
	
	
	
}