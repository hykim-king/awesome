package com.pcwk.ehr.mainpage.service;
import java.util.List;

import com.pcwk.ehr.keyword.domain.KeywordDTO;
//import com.pcwk.ehr.article.domain.ArticleDTO;

public interface MainPageService {

    /**
     * 오늘의 토픽(분야별 키워드)
     * - 기준: 오전 10시 / 오후 6시 주기(요구사항 기반)
     * - 초기엔 최신 N개 정렬로 대체 가능
     */
    List<KeywordDTO> getTodayTopics(String updatePeriod);

    /**
     * 비로그인: 조회수 TOP 3
     */
    List<Object> getHotTop3();

    /**
     * 로그인: 사용자 이력 기반 추천 TOP 3
     */
    List<Object> getRecommendTop3(String userId);

    /**
     * 날씨 요약(문구)
     * - 초기엔 더미 문자열 → 추후 기상청 API 연동
     */
    String getWeatherSummary();
}