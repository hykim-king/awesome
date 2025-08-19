package com.pcwk.ehr.quiz;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.pcwk.ehr.quiz.controller.QuizController;
import com.pcwk.ehr.quiz.domain.QuizDTO;
import com.pcwk.ehr.quiz.service.QuizService;

@WebAppConfiguration
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {
    "file:src/main/webapp/WEB-INF/spring/root-context.xml",
    "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
class QuizControllerTest {
	
	final Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	WebApplicationContext context;
	
	MockMvc mvc;
	
	// Spring 컨텍스트에 의해 생성되고 주입된 실제 Controller 객체
	@Autowired
	QuizController quizController;

	// @MockBean 대신 Mockito의 @Mock을 사용하여 Mock Service 객체 생성
	@Mock
	QuizService mockQuizService;
	
	// 테스트용 Mock 데이터
	List<QuizDTO> mockQuizList;

	@BeforeEach
	void setUp() throws Exception {
		// @Mock으로 선언된 필드를 초기화
		MockitoAnnotations.initMocks(this);
		
		// ReflectionTestUtils를 사용하여 실제 quizController의 quizService 필드를
		// 위에서 생성한 가짜 mockQuizService로 교체
		ReflectionTestUtils.setField(quizController, "quizService", mockQuizService);
		
		mvc = MockMvcBuilders.webAppContextSetup(context).build();
		
		// 테스트용 퀴즈 목록 데이터 생성
		mockQuizList = new ArrayList<>();
		QuizDTO q1 = new QuizDTO();
		q1.setQqCode(101L);
		q1.setQuestion("대한민국의 수도는 서울이다.");
		q1.setAnswer("O");
		q1.setExplanation("대한민국의 수도는 서울입니다.");
		mockQuizList.add(q1);
		
		QuizDTO q2 = new QuizDTO();
		q2.setQqCode(102L);
		q2.setQuestion("지구는 태양계의 네 번째 행성이다.");
		q2.setAnswer("X");
		q2.setExplanation("지구는 세 번째 행성입니다.");
		mockQuizList.add(q2);
	}

	@Test
	void testQuizPagingView() throws Exception {
		log.debug("│ testQuizPagingView() │");
		// mockQuizService의 동작을 정의
		when(mockQuizService.selectQuizList(any(QuizDTO.class))).thenReturn(mockQuizList);
		
		mvc.perform(get("/quiz/quizPaging.do"))
		   .andExpect(status().isOk())
		   .andExpect(model().attributeExists("quizList"))
		   .andExpect(view().name("quiz/quizPaging"))
		   .andDo(print());
	}
	
	@Test
	void testQuizExplainView() throws Exception {
		log.debug("│ testQuizExplainView() │");
		// mockQuizService의 동작을 정의
		when(mockQuizService.selectQuizList(any(QuizDTO.class))).thenReturn(mockQuizList);
		
		mvc.perform(post("/quiz/quizExplain.do")
		           .param("answer_101", "O") // 정답
		           .param("answer_102", "O")) // 오답
		   .andExpect(status().isOk())
		   .andExpect(model().attributeExists("quizResultList"))
		   .andExpect(model().attribute("correctCount", 1L))
		   .andExpect(model().attribute("totalCount", 2))
		   .andExpect(view().name("quiz/quizExplain"))
		   .andDo(print());
	}
	
	@Test
	void testQuizResultView() throws Exception {
		log.debug("│ testQuizResultView() │");
		QuizDTO mockFinalResult = new QuizDTO();
		mockFinalResult.setUserId("testUser");
		mockFinalResult.setScore(87.5);
		mockFinalResult.setUserRank(5);
		
		// mockQuizService의 동작을 정의
		when(mockQuizService.selectQuizResult(any(QuizDTO.class))).thenReturn(mockFinalResult);
		
		mvc.perform(get("/quiz/quizResult.do")
		           .param("correct", "7")
		           .param("total", "8"))
		   .andExpect(status().isOk())
		   .andExpect(model().attribute("correctCount", 7))
		   .andExpect(model().attribute("totalCount", 8))
		   .andExpect(model().attributeExists("finalResult"))
		   .andExpect(view().name("quiz/quizResult"))
		   .andDo(print());
	}
}