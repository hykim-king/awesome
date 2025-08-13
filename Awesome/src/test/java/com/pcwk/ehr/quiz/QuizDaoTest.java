package com.pcwk.ehr.quiz;

// JUnit 5 Assertion으로 변경 (static import)
import static org.junit.jupiter.api.Assertions.*;

import java.sql.SQLException;
import java.util.List;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.junit.jupiter.api.extension.ExtendWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension; // JUnit 5용 확장
import org.springframework.transaction.annotation.Transactional;

import com.pcwk.ehr.quiz.domain.QuizDTO;
import com.pcwk.ehr.mapper.QuizMapper;

// 테스트 메서드 실행 순서 지정 (메서드 이름 오름차순)
@TestMethodOrder(MethodOrderer.MethodName.class)
// Spring의 테스트 기능을 JUnit 5와 통합
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/spring/root-context.xml"})
@Transactional 
public class QuizDaoTest {

	final Logger LOG = LoggerFactory.getLogger(getClass());
	
	@Autowired
	ApplicationContext context;
	
	@Autowired
	QuizMapper quizMapper;
	
	QuizDTO quizDTO;
	QuizDTO questionDTO; // 테스트용 질문 DTO

	@BeforeEach
	void setUp() throws Exception {
		LOG.debug("====================");
		LOG.debug("=@BeforeEach= setUp()");
		LOG.debug("====================");
		
		// 1. 테스트용 질문 데이터 설정
		questionDTO = new QuizDTO();
		questionDTO.setQsCode(9999L);
		questionDTO.setQqCode(9999L); // 다른 데이터와 겹치지 않는 유니크한 값
		questionDTO.setArticleCode(9999L);
		questionDTO.setQuestionNo(1);
		questionDTO.setQuestion("테스트용 질문입니다.");
		questionDTO.setAnswer("O"); // 정답은 'O'
		questionDTO.setExplanation("테스트용 해설입니다.");
		
		// 2. 테스트용 답변 데이터 설정
		quizDTO = new QuizDTO();
		quizDTO.setUserId("test");
		quizDTO.setQqCode(questionDTO.getQqCode()); // 위에서 만든 질문의 qqCode 사용
		quizDTO.setUserAnswer("O"); // 정답과 동일하게 답변
		
		// --- 데이터 정리 및 생성 (순서가 매우 중요!) ---

	    // 1. 데이터 삭제 (자식 테이블부터)
	    quizMapper.deleteAllQuizResult(quizDTO);      // QUIZ_RESULT (손자)
	    quizMapper.deleteQuizQuestion(questionDTO);  // QUIZ_QUESTIONS (자식)
	    quizMapper.deleteQuizSet(questionDTO);       // QUIZ_SETS (부모)

	    // 2. 데이터 생성 (부모 테이블부터)
	    quizMapper.insertQuizSet(questionDTO);       // 부모 데이터 생성
	    quizMapper.insertQuizQuestion(questionDTO);  // 자식 데이터 생성
	}
	
	@AfterEach
	void tearDown() throws Exception {
	}
	
	@Test
	public void test01_InsertAndSelect() throws SQLException {
		LOG.debug("====================");
		LOG.debug("=@Test= test01_InsertAndSelect()");
		LOG.debug("====================");
		
		// 1. 등록(INSERT) 기능 테스트
		int insertFlag = quizMapper.insertQuizResult(quizDTO);
		assertEquals(1, insertFlag);
		
		// 2. 단건 조회로 등록된 데이터 검증
		QuizDTO result = quizMapper.selectQuizResult(quizDTO);
		assertNotNull(result);
		
		// 입력한 값과 조회된 값이 일치하는지 확인
		assertEquals(quizDTO.getUserId(), result.getUserId());
		assertEquals(quizDTO.getQqCode(), result.getQqCode());
		assertEquals(quizDTO.getUserAnswer(), result.getUserAnswer());
		assertEquals(0, result.getScore()); // 최초 점수는 0점
	}

	@Test
	public void test02_SelectQuizList() throws SQLException {
		LOG.debug("====================");
		LOG.debug("=@Test= test02_SelectQuizList()");
		LOG.debug("====================");
		
		quizDTO.setPageStart(1);
		quizDTO.setPageEnd(8);
		
		List<QuizDTO> list = quizMapper.selectQuizList(quizDTO);
		assertNotNull(list);
		
		LOG.debug("=Quiz List Size=" + list.size());
	}
	
	@Test
	public void test03_GetTotalQuizCount() throws SQLException {
		LOG.debug("====================");
		LOG.debug("=@Test= test03_GetTotalQuizCount()");
		LOG.debug("====================");
		
		int totalCount = quizMapper.getTotalQuizCount();
		LOG.debug("=Total Quiz Count=" + totalCount);
		assertTrue(totalCount >= 0);
	}
	
	@Test
	public void test04_SelectUserRankingTop10() throws SQLException {
		LOG.debug("====================");
		LOG.debug("=@Test= test04_SelectUserRankingTop10()");
		LOG.debug("====================");
		
		List<QuizDTO> list = quizMapper.selectUserRankingTop10();
		assertNotNull(list);
		assertTrue(list.size() <= 10);
		
		LOG.debug("=Ranking List Size=" + list.size());
	}
	
	@Test
	@Disabled // @Ignore -> @Disabled
	void beans() {
		LOG.debug("=context=" + context);
		LOG.debug("=quizMapper=" + quizMapper);
	}
}