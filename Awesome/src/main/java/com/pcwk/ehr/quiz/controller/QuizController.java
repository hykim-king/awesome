package com.pcwk.ehr.quiz.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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

// --- 변경된 import ---
import com.pcwk.ehr.member.domain.MemberDTO; // UserVO 대신 실제 MemberDTO를 import
import com.pcwk.ehr.quiz.domain.QuizDTO;
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
     * 오늘의 퀴즈 문제 폼 페이지로 이동
     */
    @GetMapping("/quizForm.do")
    public String showQuizForm(HttpSession session, Model model, RedirectAttributes redirectAttributes) throws SQLException {
        log.debug("┌──────────────────────────┐");
        log.debug("│ showQuizForm()           │");
        log.debug("└──────────────────────────┘");

        // 1. 로그인 여부 확인 (세션에서 MemberDTO 객체를 가져오도록 변경)
        // --- 변경된 부분 ---
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            redirectAttributes.addFlashAttribute("message", "로그인이 필요한 서비스입니다.");
            return "redirect:/member/login.do"; // 로그인 페이지 경로 확인 필요
        }
        
        // 2. 오늘 이미 퀴즈를 풀었는지 확인
        if (quizService.hasUserPlayedToday(loginUser.getUserId())) {
            redirectAttributes.addFlashAttribute("message", "오늘의 퀴즈에 이미 참여하셨습니다. 내일 다시 도전해주세요!");
            return "redirect:/quiz/main.do";
        }

        // 3. 오늘의 퀴즈 문제 조회 및 모델에 추가
        List<QuizDTO> quizList = quizService.getTodaysQuiz();
        model.addAttribute("quizList", quizList);

        return "quiz/quizForm";
    }

    /**
     * 퀴즈 답변 제출 및 결과 확인
     */
    @PostMapping("/submit.do")
    public String submitQuiz(@RequestParam("questionNos") long[] questionNos,
                             @RequestParam("userAnswers") String[] userAnswers,
                             HttpSession session, Model model) throws SQLException {
        
        log.debug("┌──────────────────────────┐");
        log.debug("│ submitQuiz()             │");
        log.debug("└──────────────────────────┘");

        // --- 변경된 부분 ---
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        String userId = loginUser.getUserId();

        // 1. 제출된 답변을 List<QuizDTO> 형태로 변환
        List<QuizDTO> submittedAnswers = new ArrayList<>();
        for (int i = 0; i < questionNos.length; i++) {
            QuizDTO dto = new QuizDTO();
            dto.setUserId(userId);
            dto.setQqCode(questionNos[i]); // 문제 고유 코드
            dto.setUserAnswer(userAnswers[i]);
            submittedAnswers.add(dto);
        }

        // 2. 서비스 레이어에 답변 일괄 제출 요청 (트랜잭션 처리)
        quizService.submitQuizAnswers(submittedAnswers);

        // 3. 채점 결과를 보여주기 위해 오늘의 퀴즈(정답 포함)를 다시 조회
        List<QuizDTO> resultList = quizService.getTodaysQuiz();
        int correctCount = 0;
        
        // 4. 조회된 퀴즈 목록에 사용자의 답변을 매핑하고, 정답 수 계산
        for (int i = 0; i < resultList.size(); i++) {
            QuizDTO quiz = resultList.get(i);
            quiz.setUserAnswer(userAnswers[i]); // 사용자 답변 설정
            if (quiz.getAnswer().equals(userAnswers[i])) {
                correctCount++;
            }
        }
        
        // 5. 모델에 결과 데이터 추가
        model.addAttribute("resultList", resultList);
        model.addAttribute("correctCount", correctCount);
        model.addAttribute("totalCount", resultList.size());

        // 6. 결과 확인 모드로 quizForm.jsp를 다시 렌더링
        return "quiz/quizForm";
    }
    
    /**
     * 최종 점수 결과 페이지로 이동
     */
    @PostMapping("/result.do")
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
    
 // --- 랭킹 조회용 API 추가 ---
    /**
     * 랭킹 목록을 JSON으로 반환하는 API
     * @throws Exception 
     */
    @GetMapping(value = "/ranking.do", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public List<QuizDTO> getRanking() throws Exception {
        log.debug("┌──────────────────────────┐");
        log.debug("│ getRanking() - 랭킹 조회 API 호출 │");
        log.debug("└──────────────────────────┘");
        return quizService.selectUserRankingTop10();
    }
}