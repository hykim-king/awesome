package com.pcwk.ehr.quiz.controller;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

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
	 * 퀴즈 시작 메인 페이지
	 */
	@RequestMapping(value = "/quizMain.do", method = RequestMethod.GET)
	public String quizMain() {
		log.debug("┌──────────────────────────┐");
		log.debug("│ quizMain()               │");
		log.debug("└──────────────────────────┘");
		return "quiz/quizMain";
	}
	
	
	/**
	 * 퀴즈 문제 풀이 페이지
	 */
	@RequestMapping(value = "/quizPaging.do", method = RequestMethod.GET)
	public String quizPaging(Model model) throws Exception {
		log.debug("┌──────────────────────────┐");
		log.debug("│ quizPaging()             │");
		log.debug("└──────────────────────────┘");
		
		// 오늘의 퀴즈 목록 조회 (Service는 내부적으로 오늘 날짜로 필터링)
		List<QuizDTO> quizList = quizService.selectQuizList(new QuizDTO());
		model.addAttribute("quizList", quizList);
		
		return "quiz/quizPaging";
	}
	
	
	/**
	 * 퀴즈 답안 제출 및 문제 해설 페이지
	 */
	@RequestMapping(value = "/quizExplain.do", method = RequestMethod.POST)
	public String quizExplain(HttpServletRequest request, HttpSession session, Model model) throws Exception {
		log.debug("┌──────────────────────────┐");
		log.debug("│ quizExplain()            │");
		log.debug("└──────────────────────────┘");
		
		// 1. request에서 사용자 답안 추출 (파라미터 key: "answer_qqCode")
		Map<Long, String> userAnswers = new HashMap<>();
		Enumeration<String> params = request.getParameterNames();
		while(params.hasMoreElements()) {
			String paramName = params.nextElement();
			if(paramName.startsWith("answer_")) {
				long qqCode = Long.parseLong(paramName.substring("answer_".length()));
				userAnswers.put(qqCode, request.getParameter(paramName));
			}
		}
		log.debug("│ userAnswers: {}", userAnswers);

		// 2. DB에서 정답을 포함한 퀴즈 정보 다시 조회
		List<QuizDTO> correctQuizList = quizService.selectQuizList(new QuizDTO());
		
		// 3. 답안 비교 및 결과 리스트 생성
		List<QuizDTO> quizResultList = new ArrayList<>();
		for(QuizDTO quiz : correctQuizList) {
			QuizDTO result = new QuizDTO();
			result.setQuestion(quiz.getQuestion());
			result.setAnswer(quiz.getAnswer()); // 정답
			result.setExplanation(quiz.getExplanation()); // 해설
			result.setUserAnswer(userAnswers.getOrDefault(quiz.getQqCode(), "미제출")); // 사용자 제출 답안
			quizResultList.add(result);
		}
		
		// 4. 맞힌 개수와 총 개수 계산
		long correctCount = quizResultList.stream()
		                                  .filter(r -> r.getUserAnswer().equals(r.getAnswer()))
		                                  .count();
		int totalCount = quizResultList.size();
		
		// 5. 점수 계산 (문제당 12.5점이라고 가정, 8문제 기준)
		double scorePerQuestion = (totalCount > 0) ? (100.0 / totalCount) : 0;
		double totalScore = correctCount * scorePerQuestion;
		
		
		// =================================================================================
		// (중요) 실제 애플리케이션에서는 이 부분에서 채점 결과를 DB에 저장하는 서비스 호출이 필요합니다.
		// UserVO loginUser = (UserVO) session.getAttribute("loginUser");
		// quizService.saveQuizResults(loginUser.getUserId(), quizResultList, totalScore);
		log.debug("│ 채점 완료: {}/{} | 점수: {}", correctCount, totalCount, totalScore);
		// =================================================================================

		model.addAttribute("quizResultList", quizResultList);
		model.addAttribute("correctCount", correctCount);
		model.addAttribute("totalCount", totalCount);
		
		return "quiz/quizExplain";
	}
	
	
	/**
	 * 퀴즈 최종 결과 요약 페이지
	 */
	@RequestMapping(value = "/quizResult.do", method = RequestMethod.GET)
	public String quizResult(@RequestParam("correct") int correctCount, 
							 @RequestParam("total") int totalCount, 
							 HttpSession session, Model model) throws Exception {
		log.debug("┌──────────────────────────┐");
		log.debug("│ quizResult()             │");
		log.debug("└──────────────────────────┘");
		
		// UserVO loginUser = (UserVO) session.getAttribute("loginUser");
		// if (loginUser == null) { /* 로그인 안된 경우 예외처리 */ }
		
		// DB에서 오늘의 최종 결과(점수, 랭킹 등)를 조회하기 위한 DTO 준비
		QuizDTO param = new QuizDTO();
		// param.setUserId(loginUser.getUserId());
		
		// 서비스 호출하여 최종 결과 조회
		QuizDTO finalResult = quizService.selectQuizResult(param);
		
		// JSP에서 사용할 수 있도록 모델에 데이터 추가
		model.addAttribute("correctCount", correctCount);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("finalResult", finalResult); // DB에서 조회한 점수, 랭킹 정보
		
		return "quiz/quizResult";
	}
}