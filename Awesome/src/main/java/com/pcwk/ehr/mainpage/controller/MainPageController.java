package com.pcwk.ehr.mainpage.controller;

import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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
 
    @GetMapping("/main.do")
    public String main(Model model, HttpSession session) {
        String userId = (String) session.getAttribute("userId");
        log.debug("main.do() userId={}", userId);

        // 오늘의 토픽(키워드) - 탭/그리드로 노출
        List<String> topics = Arrays.asList("정치", "경제", "사회", "문화", "연예", "스포츠", "IT/과학");
        model.addAttribute("topics", topics);

        // 추천/인기 기사 Top3 (더미)
        // TODO: 로그인 시 userId 기반 추천으로 교체 -> mainService.getRecommendTop3(userId)
        // TODO: 비로그인 시 조회수 TOP3로 교체 -> mainService.getHotTop3()
        List<String> recommended = Arrays.asList(
            "추천) 경제: 환율 급등 관련 해설",
            "추천) IT: 생성형 AI 도입 사례",
            "추천) 사회: 여름철 전력수급 이슈"
        );
        List<String> hotTop3 = Arrays.asList(
            "인기) 정치: 국회 본회의 쟁점 정리",
            "인기) 스포츠: 주말 경기 하이라이트",
            "인기) IT: 보안 업데이트 권고"
        );

        if (userId != null) {
            model.addAttribute("sectionTitle", "추천 기사 Top 3");
            model.addAttribute("articlesTop3", recommended);
        } else {
            model.addAttribute("sectionTitle", "조회수 Top 3");
            model.addAttribute("articlesTop3", hotTop3);
        }

        // 날씨 영역 자리(기상청 API 연동 전)
        // TODO: weatherService.getTodaySummary() 로 교체
        model.addAttribute("weatherSummary", "서울 28℃, 구름 조금"); // 더미 텍스트

        // 퀴즈 티저 배너(12시 오픈)
        model.addAttribute("quizTeaser", "오늘의 뉴스 퀴즈 · 12:00 오픈!");

        // 페이지 메타(타이틀 등)
        model.addAttribute("pageTitle", "Hot Issue - 메인");

        return "mainPage/MainPage"; // /WEB-INF/views/~~ 위치. 파일명
    }

    
    
    /**
     * (선택) 메인 리프레시용 라이트 엔드포인트
     * - 추후 setInterval/AJAX로 특정 섹션만 갱신하고 싶을 때 사용
     * - 지금은 뷰 먼저이므로 주석으로 남겨둠
     */
    // @GetMapping("/section/recommend.do")
    // @ResponseBody
    // public List<String> refreshRecommend(HttpSession session) {
    //     String userId = (String) session.getAttribute("userId");
    //     return mainService.getRecommendTop3(userId);
    // }
}