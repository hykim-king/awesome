package com.pcwk.ehr.mainpage.controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.pcwk.ehr.keyword.domain.KeywordLink;
import com.pcwk.ehr.keyword.service.KeywordService;
import com.pcwk.ehr.weather.domain.WeatherDTO;
import com.pcwk.ehr.weather.service.WeatherService;

@Controller
@RequestMapping("/mainPage")
public class MainPageController {

    Logger log = LogManager.getLogger(getClass());

    /**
     * 메인 페이지
     * - 아직 DB 연동 전: 더미 데이터로 화면 먼저 구성
     * - 추후 로그인 여부에 따라 추천/인기 구역 분기
     *   (로그인: 추천 Top3 / 비로그인: 조회수 Top3)
     * - View: /WEB-INF/views/mainPage/MainPage.jsp
     */

    @Autowired
    KeywordService keywordService;
    
    @Autowired
    WeatherService weatherService;
    
    
    @GetMapping("/main.do")
    public String main(Model model, HttpSession session) {
        String userId = (String) session.getAttribute("userId");
        log.debug("main.do() userId={}", userId);


        List<KeywordLink> keywords = keywordService.getTodayKeywords();
        model.addAttribute("keywords", keywords);

        // ── 인기/추천 더미 데이터 (JSP 변수명에 맞춤) ────────────────
        List<String> popularArticles = Arrays.asList(
            "인기) 정치: 국회 본회의 쟁점 정리",
            "인기) 스포츠: 주말 경기 하이라이트",
            "인기) IT: 보안 업데이트 권고",
            "인기) IT: 보안 업데이트 권고",
            "인기) IT: 보안 업데이트 권고",
            "인기4) IT: 보안 업데이트 권고보안 업데이트 권고보안 업데이트 권고"
        );
        model.addAttribute("popularArticles", popularArticles);

        List<String> recommended = Arrays.asList(
            "추천) 경제: 환율 급등 관련 해설",
            "추천) IT: 생성형 AI 도입 사례",
            "추천) 사회: 여름철 전력수급 이슈"
        );
        model.addAttribute("recommended", recommended);

  
        // 페이지 메타
        model.addAttribute("pageTitle", "Hot Issue - 메인");

        return "mainPage/MainPage";
    }
    
    @GetMapping("/article/list.do")
    public String keywordList(String keyword, int category, Model model) {
        log.debug(">> keywordList(): keyword={}, category={}", keyword, category);

        // 아직 기사 데이터베이스 연동 안됐다고 가정하고,
        // 일단 keyword와 category만 jsp로 넘김
        model.addAttribute("keyword", keyword);
        model.addAttribute("category", category);

        // → /WEB-INF/views/topic/list.jsp 로 포워딩
        return "article/list";
    }
    
}