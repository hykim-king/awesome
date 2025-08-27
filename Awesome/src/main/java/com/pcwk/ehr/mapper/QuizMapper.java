package com.pcwk.ehr.mapper;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import com.pcwk.ehr.quiz.domain.QuizDTO;
import com.pcwk.ehr.quiz.domain.RankingDTO;


@Mapper
public interface QuizMapper {

	/**
	 * 퀴즈 목록 페이징 조회
	 */
	List<QuizDTO> selectQuizList(QuizDTO dto) throws SQLException;

	/**
	 * 전체 퀴즈 개수 조회
	 */
	int getTotalQuizCount() throws SQLException;

	/**
	 * 사용자가 제출한 퀴즈 답변 저장
	 */
	int insertQuizResult(QuizDTO dto) throws SQLException;

	/**
	 * 정답 여부에 따라 점수 업데이트
	 */
	int updateScoreIfCorrect(QuizDTO dto) throws SQLException;

	/**
	 * 사용자 랭킹 TOP 10 조회
	 */
	List<RankingDTO> selectUserRankingTop10() throws SQLException;

	/**
	 * 퀴즈 결과 단건 조회 (JUnit 테스트에서 검증용으로 사용)
	 */
	QuizDTO selectQuizResult(QuizDTO dto) throws SQLException;
	
	/**
	 * 오늘의 퀴즈 목록 조회
	 */
	List<QuizDTO> selectTodaysQuiz() throws SQLException;

	/**
	 * 사용자가 오늘 퀴즈에 참여했는지 확인
	 */
	int checkIfUserPlayedToday(String userId) throws SQLException;
	
	 /**
     * 오늘의 퀴즈 및 사용자의 답변을 함께 조회
     * @param userId
     * @return List<QuizDTO>
     */
    List<QuizDTO> selectTodaysQuizAndUserAnswers(String userId);
	
	//======================================================================
	// 테스트 지원용 메서드 (Test Support Methods)
	//======================================================================
	
	/** 테스트용: QUIZ_QUESTIONS 테이블 전체 삭제 */
	void deleteAllQuizQuestions() throws SQLException;

	/** 테스트용: QUIZ_SETS 테이블 전체 삭제 */
	void deleteAllQuizSets() throws SQLException;
	
	/** 테스트용: 특정 사용자의 모든 퀴즈 결과 삭제 */
	void deleteAllQuizResult(QuizDTO dto) throws SQLException;

	/** 테스트용: 퀴즈 질문 등록 */
	void insertQuizQuestion(QuizDTO dto) throws SQLException;
	
	/** 테스트용: 퀴즈 세트 등록 */
	void insertQuizSet(QuizDTO dto) throws SQLException;
}