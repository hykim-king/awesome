package com.pcwk.ehr.mainpage;
import static org.junit.jupiter.api.Assertions.*;

import java.util.Calendar;
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

import com.pcwk.ehr.keyword.domain.KeywordDTO;
import com.pcwk.ehr.mainpage.service.MainPageService;
import com.pcwk.ehr.mapper.KeywordMapper;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {
    "file:src/main/webapp/WEB-INF/spring/root-context.xml",
  //  "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
class MainPageServiceTest {

    Logger log = LogManager.getLogger(getClass());

    @Autowired
    MainPageService mainPageService;

    @Autowired
    KeywordMapper keywordMapper; // 초기화 및 더미 데이터 삽입용

    @BeforeEach
    void setUp() {
        keywordMapper.deleteAll();
        log.debug("daily_keyword 전체삭제");
    }

    @AfterEach
    void tearDown() {
        log.debug("--------- @AfterEach ---------");
    }

   // @Disabled
    @Test
    @DisplayName("getTodayTopics: updatePeriod=AM10 필터링 및 최신순 정렬")
    void getTodayTopics_filterAndSort() {
        // 날짜 객체 생성
        Calendar cal = Calendar.getInstance();

        cal.set(2025, Calendar.AUGUST, 9);
        Date date1 = cal.getTime();

        cal.set(2025, Calendar.AUGUST, 10);
        Date date2 = cal.getTime();

        // given
        KeywordDTO k1 = new KeywordDTO(null, date1, "AM10", 1, "총선");
        KeywordDTO k2 = new KeywordDTO(null, date2, "AM10", 2, "환율");
        KeywordDTO k3 = new KeywordDTO(null, date2, "PM06", 3, "AI");

        keywordMapper.doSave(k1);
        keywordMapper.doSave(k2);
        keywordMapper.doSave(k3);

        // when
        List<KeywordDTO> out = mainPageService.getTodayTopics("AM10");

        // then
        assertEquals(2, out.size(), "AM10만 남아야 함");
        assertEquals("환율", out.get(0).getKeyword(), "최신 날짜가 먼저");
        assertEquals("총선", out.get(1).getKeyword());
    }

  //  @Disabled
    @Test
    @DisplayName("getTodayTopics: 데이터 없으면 빈 리스트")
    void getTodayTopics_empty() {
        List<KeywordDTO> out = mainPageService.getTodayTopics("AM10");
        assertTrue(out.isEmpty());
    }

  //  @Disabled
    @Test
    @DisplayName("getHotTop3: 더미 3건 반환")
    void getHotTop3_returns3() {
        List<Object> out = mainPageService.getHotTop3();
        assertEquals(3, out.size());
        assertTrue(out.get(0).toString().contains("인기"));
    }

  //  @Disabled
    @Test
    @DisplayName("getRecommendTop3: userId 없으면 빈 리스트")
    void getRecommendTop3_nullUser() {
        List<Object> out = mainPageService.getRecommendTop3(null);
        assertTrue(out.isEmpty());
    }

 //   @Disabled
    @Test
    @DisplayName("getRecommendTop3: userId 있으면 더미 3건")
    void getRecommendTop3_hasUser() {
        List<Object> out = mainPageService.getRecommendTop3("user01");
        assertEquals(3, out.size());
        assertTrue(out.get(0).toString().contains("추천"));
    }

 //   @Disabled
    @Test
    @DisplayName("getWeatherSummary: 더미 문자열 반환")
    void getWeatherSummary_dummy() {
        String s = mainPageService.getWeatherSummary();
        assertNotNull(s);
        assertFalse(s.isEmpty());
    }
}