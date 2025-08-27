package com.pcwk.ehr.mainpage.controller;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.pcwk.ehr.article.domain.ArticleDTO;
import com.pcwk.ehr.article.service.ArticleService;
import com.pcwk.ehr.keyword.domain.KeywordLink;
import com.pcwk.ehr.keyword.service.KeywordService;
import com.pcwk.ehr.mainpage.service.MainPageService;
import com.pcwk.ehr.member.domain.MemberDTO;
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
    MainPageService mainPageService; 
    
    @Autowired
    KeywordService keywordService;
    
    @Autowired
    WeatherService weatherService;
    
    @Autowired
    ArticleService articleService;
    
    
    @GetMapping("/main.do")
    public String main(Model model, HttpSession session) {
        // 로그인 여부 확인
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
            if (loginUser != null) {
                userId = String.valueOf(loginUser.getUserId());
            }
        }
        log.debug("main.do() userId={}", userId);

        // 키워드
        List<KeywordLink> keywords = keywordService.getTodayKeywords();
        model.addAttribute("keywords", keywords);

        // 인기 기사(top3)
        List<ArticleDTO> popularArticles = articleService.getPopularTop1PerCategory();
        model.addAttribute("popularArticles", popularArticles);

        // 유저로그 기반 추천
        List<ArticleDTO> personalRecs = Collections.emptyList();
        String recommendMessage = null;

        if (userId != null) { // 로그인 O
            personalRecs = mainPageService.getRecommendedArticlesByUser(userId);
            if (personalRecs == null || personalRecs.isEmpty()) {
                recommendMessage = "관심있는 기사들을 읽어보세요. 회원님의 맞춤 기사가 추천됩니다🙂";
            }
        } else { // 로그인 X
            recommendMessage = "로그인 하시면 회원님의 맞춤기사가 추천됩니다🙂";
        }

        model.addAttribute("personalRecs", personalRecs);
        model.addAttribute("recommendMessage", recommendMessage);

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