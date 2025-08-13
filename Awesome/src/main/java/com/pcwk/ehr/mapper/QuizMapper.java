package com.pcwk.ehr.mapper;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import com.pcwk.ehr.quiz.domain.QuizDTO;

/**
 * 퀴즈 관련 MyBatis Mapper 인터페이스
 * * 이 인터페이스의 메서드를 호출하면
 * quizMapper.xml에 정의된 해당 id의 SQL 쿼리가 실행됩니다.
 */
@Mapper // Spring이 이 인터페이스를 MyBatis Mapper로 인식하고 스캔할 수 있도록 합니다.
public interface QuizMapper {

	/**
	 * 퀴즈 목록 페이징 조회
	 * @param dto (페이징 정보: pageStart, pageEnd)
	 * @return 퀴즈 목록
	 * @throws SQLException
	 */
	List<QuizDTO> selectQuizList(QuizDTO dto) throws SQLException;

	/**
	 * 전체 퀴즈 개수 조회
	 * @return 전체 퀴즈 수
	 * @throws SQLException
	 */
	int getTotalQuizCount() throws SQLException;

	/**
	 * 사용자가 제출한 퀴즈 답변 저장
	 * @param dto (저장할 정보: userId, qqCode, userAnswer)
	 * @return 성공: 1, 실패: 0
	 * @throws SQLException
	 */
	int insertQuizResult(QuizDTO dto) throws SQLException;

	/**
	 * 정답 여부에 따라 점수 업데이트
	 * @param dto (채점할 대상: userId, qqCode, userAnswer)
	 * @return 성공: 1, 실패: 0
	 * @throws SQLException
	 */
	int updateScoreIfCorrect(QuizDTO dto) throws SQLException;

	/**
	 * 사용자 랭킹 TOP 10 조회
	 * @return 랭킹 목록
	 * @throws SQLException
	 */
	List<QuizDTO> selectUserRankingTop10() throws SQLException;

	/**
	 * 퀴즈 결과 단건 조회 (JUnit 테스트에서 검증용으로 사용)
	 * @param dto (조회할 대상: userId, qqCode)
	 * @return 조회된 퀴즈 결과
	 * @throws SQLException
	 */
	QuizDTO selectQuizResult(QuizDTO dto) throws SQLException;
	
	// 아래 3개의 메서드를 QuizMapper 인터페이스에 추가합니다.
	void deleteQuizQuestion(QuizDTO dto) throws SQLException;
	void deleteAllQuizResult(QuizDTO dto) throws SQLException;
	void insertQuizQuestion(QuizDTO dto) throws SQLException;
	
	// 아래 2개의 메서드를 QuizMapper 인터페이스에 추가합니다.
	void deleteQuizSet(QuizDTO dto) throws SQLException;
	void insertQuizSet(QuizDTO dto) throws SQLException;

}