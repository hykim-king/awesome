package com.pcwk.ehr.quiz;

import static org.junit.jupiter.api.Assertions.*;

import java.sql.SQLException;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import com.pcwk.ehr.quiz.domain.QuizDTO;
import com.pcwk.ehr.mapper.QuizMapper;

@TestMethodOrder(MethodOrderer.MethodName.class)
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/spring/root-context.xml"})
@Transactional 
public class QuizDaoTest {

	final Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	ApplicationContext context;
	
	@Autowired
	QuizMapper quizMapper;
	
	QuizDTO user1, user2;
	QuizDTO question1, question2;
	QuizDTO set1, set2;
	QuizDTO quizResultForUser1;

	@BeforeEach
	void setUp() throws Exception {
		log.debug("--- setUp() ---");
		
		// 1. 테스트용 객체 초기화
	    user1 = new QuizDTO();
	    user1.setUserId("test");

	    user2 = new QuizDTO();
	    user2.setUserId("test1234");
	    
	    set1 = new QuizDTO();
	    set1.setQsCode(9999L);
	    
	    set2 = new QuizDTO();
	    set2.setQsCode(9998L);

	    question1 = new QuizDTO(0, 0, set1.getQsCode(), 9999L, 0, 1, "질문 1", "O", "해설 1", null, 0, null, null, 0, null, 0, 0);
	    question2 = new QuizDTO(0, 0, set2.getQsCode(), 9998L, 0, 2, "질문 2", "X", "해설 2", null, 0, null, null, 0, null, 0, 0);

	    // 2. 데이터베이스 정리 (테이블 전체 비우기)
	    quizMapper.deleteAllQuizResult(user1);
	    quizMapper.deleteAllQuizResult(user2);
	    quizMapper.deleteAllQuizQuestions();
	    quizMapper.deleteAllQuizSets();
	    
	    // 3. 데이터베이스 생성
	    quizMapper.insertQuizSet(set1);
	    quizMapper.insertQuizSet(set2);
	    quizMapper.insertQuizQuestion(question1);
	    quizMapper.insertQuizQuestion(question2);
		
	    quizResultForUser1 = new QuizDTO();
	    quizResultForUser1.setUserId(user1.getUserId());
	    quizResultForUser1.setQqCode(question1.getQqCode());
	    quizResultForUser1.setUserAnswer(question1.getAnswer());
	}
	
	/**
	 * 답변 제출 및 채점을 한번에 처리하는 헬퍼 메서드
	 */
	private void submitAndScore(String userId, QuizDTO question, String answer) throws SQLException {
		QuizDTO result = new QuizDTO();
		result.setUserId(userId);
		result.setQqCode(question.getQqCode());
		result.setUserAnswer(answer);
		
		quizMapper.insertQuizResult(result);
		quizMapper.updateScoreIfCorrect(result);
	}

	@Test
	public void insertAndSelect() throws SQLException {
		log.debug("--- insertAndSelect() ---");
		
		int insertFlag = quizMapper.insertQuizResult(quizResultForUser1);
		assertEquals(1, insertFlag);
		
		QuizDTO result = quizMapper.selectQuizResult(quizResultForUser1);
		assertNotNull(result);
		assertEquals(quizResultForUser1.getUserId(), result.getUserId());
	}

	@Test
	public void updateScore() throws SQLException {
		log.debug("--- updateScore() ---");

		quizMapper.insertQuizResult(quizResultForUser1);
		int correctUpdateFlag = quizMapper.updateScoreIfCorrect(quizResultForUser1);
		assertEquals(1, correctUpdateFlag);
		QuizDTO correctResult = quizMapper.selectQuizResult(quizResultForUser1);
		assertEquals(12.5, correctResult.getScore());
	}
	
	@Test
	public void getTotalQuizCount() throws SQLException {
		log.debug("--- getTotalQuizCount() ---");
		int totalCount = quizMapper.getTotalQuizCount();
		assertEquals(2, totalCount);
	}

	@Test
	public void selectQuizList() throws SQLException {
		log.debug("--- selectQuizList() ---");
		
		QuizDTO searchDTO = new QuizDTO();
		searchDTO.setPageStart(1);
		searchDTO.setPageEnd(10);
		
		List<QuizDTO> list = quizMapper.selectQuizList(searchDTO);
		assertNotNull(list);
		assertEquals(2, list.size());
	}
	
	@Test
	public void selectUserRankingTop10() throws SQLException {
		log.debug("--- selectUserRankingTop10() ---");
		
		// 헬퍼 메서드를 사용하여 시나리오를 간결하게 표현
		// User1('test'): 2문제 모두 정답
		submitAndScore(user1.getUserId(), question1, "O"); // 정답
		submitAndScore(user1.getUserId(), question2, "X"); // 정답
		
		// User2('test1234'): 1문제만 정답
		submitAndScore(user2.getUserId(), question1, "O"); // 정답
		submitAndScore(user2.getUserId(), question2, "O"); // 오답
		
		// 최종 검증
		List<QuizDTO> rankingList = quizMapper.selectUserRankingTop10();
		
		assertNotNull(rankingList);
		assertEquals(2, rankingList.size());
		
		assertEquals("test", rankingList.get(0).getUserId());
		assertEquals(25.0, rankingList.get(0).getTotalScore());
		
		assertEquals("test1234", rankingList.get(1).getUserId());
		assertEquals(12.5, rankingList.get(1).getTotalScore());
		
		log.debug("= Ranking Result =");
		rankingList.forEach(rank -> log.debug(rank.toString()));
	}
	
	@Test
	@Disabled
	void beans() {
		log.debug("=context=" + context);
		log.debug("=quizMapper=" + quizMapper);
	}
}