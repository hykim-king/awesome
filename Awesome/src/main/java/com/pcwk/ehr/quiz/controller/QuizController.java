package com.pcwk.ehr.quiz.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pcwk.ehr.member.domain.MemberDTO;
import com.pcwk.ehr.quiz.domain.QuizDTO;
import com.pcwk.ehr.quiz.domain.RankingDTO;
import com.pcwk.ehr.quiz.service.QuizService;

@Controller
@RequestMapping("/quiz")
public class QuizController {

    final Logger log = LogManager.getLogger(getClass());

    @Autowired
    QuizService quizService;

    public QuizController() {}
    
    /**
     * 퀴즈 메인 페이지로 이동
     */
    @GetMapping("/main.do")
    public String quizMain() {
        log.debug("┌──────────────────────────┐");
        log.debug("│ quizMain()               │");
        log.debug("└──────────────────────────┘");
        return "quiz/quizMain";
    }

    /**
     * 퀴즈 풀이 페이지로 이동 (quizPaging.jsp)
     */
    @GetMapping("/quizPaging.do")
    public String showQuizPaging(HttpSession session, Model model, RedirectAttributes redirectAttributes) throws SQLException {
        log.debug("┌──────────────────────────┐");
        log.debug("│ showQuizPaging()         │");
        log.debug("└──────────────────────────┘");

        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            redirectAttributes.addFlashAttribute("message", "로그인이 필요한 서비스입니다.");
            return "redirect:/member/login.do";
        }
        
        if (quizService.hasUserPlayedToday(loginUser.getUserId())) {
            redirectAttributes.addFlashAttribute("message", "오늘의 퀴즈에 이미 참여하셨습니다. 내일 다시 도전해주세요!");
            return "redirect:/mainPage/main.do";
        }
        
        List<QuizDTO> quizList = quizService.getTodaysQuiz();
        model.addAttribute("quizList", quizList);
        
        return "quiz/quizPaging";
    }

    /**
     * 퀴즈 답변 제출 및 해설 페이지로 이동 (quizExplain.jsp)
     */
    @PostMapping("/submit.do")
    public String submitQuiz(@RequestParam Map<String, String> userAnswers,
                             HttpSession session, Model model) throws SQLException {

        log.debug("┌──────────────────────────┐");
        log.debug("│ submitQuiz()             │");
        log.debug("└──────────────────────────┘");
        
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/member/login.do"; 
        }

        // 1. 제출된 답변을 QuizDTO 리스트로 변환 및 DB에 저장
        List<QuizDTO> submittedAnswers = userAnswers.entrySet().stream()
                .filter(entry -> entry.getKey().startsWith("answer_"))
                .map(entry -> {
                    String quizNoStr = entry.getKey().replace("answer_", "");
                    long quizNo = Long.parseLong(quizNoStr);
                    String userAnswer = entry.getValue();

                    QuizDTO dto = new QuizDTO();
                    dto.setUserId(loginUser.getUserId());
                    dto.setQqCode(quizNo);
                    dto.setUserAnswer(userAnswer);
                    return dto;
                }).collect(Collectors.toList());
        
        quizService.submitQuizAnswers(submittedAnswers);

        // 2. 채점 결과를 보여주기 위해 오늘의 퀴즈 및 사용자 답변을 조회
        List<QuizDTO> quizResultList = quizService.getTodaysQuizAndUserAnswers(loginUser.getUserId());
        
        // 3. 정답 개수 계산
        int correctCount = (int) quizResultList.stream()
                .filter(quiz -> quiz.getAnswer() != null && quiz.getAnswer().equals(quiz.getUserAnswer()))
                .count();
        
        model.addAttribute("quizResultList", quizResultList);
        model.addAttribute("correctCount", correctCount);
        model.addAttribute("totalCount", quizResultList.size());
        
        // 4. quizExplain.jsp로 포워딩
        return "quiz/quizExplain";
    }
    
    /**
     * 최종 점수 결과 페이지로 이동
     */
    @GetMapping("/result.do")
    public String showResult(@RequestParam("correctCount") int correctCount,
                             @RequestParam("totalCount") int totalCount,
                             Model model) {
        
        log.debug("┌──────────────────────────┐");
        log.debug("│ showResult()             │");
        log.debug("└──────────────────────────┘");
        
        model.addAttribute("correctCount", correctCount);
        model.addAttribute("totalCount", totalCount);
        
        return "quiz/quizResult";
    }

    /**
     * 랭킹 목록을 JSON으로 반환하는 API
     * @throws Exception 
     */
    @GetMapping(value = "/ranking.do", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public List<RankingDTO> getRanking() throws Exception {
        log.debug("┌──────────────────────────┐");
        log.debug("│ getRanking() - 랭킹 조회 API 호출 │");
        log.debug("└──────────────────────────┘");
        return quizService.selectUserRankingTop10();
    }
}