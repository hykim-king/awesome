package com.pcwk.ehr.quiz.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.pcwk.ehr.quiz.domain.QuizDTO;
import com.pcwk.ehr.quiz.domain.RankingDTO;

public interface QuizService {


	List<QuizDTO> selectQuizList(QuizDTO dto) throws Exception;

	int getTotalQuizCount(QuizDTO dto) throws Exception;

	List<RankingDTO> selectUserRankingTop10() throws Exception;

	QuizDTO selectQuizResult(QuizDTO dto) throws Exception;
	/**
	 * 오늘의 퀴즈 목록 조회
	 */
	List<QuizDTO> getTodaysQuiz() throws SQLException;

	/**
	 * 사용자의 퀴즈 답변 일괄 제출
	 */
	void submitQuizAnswers(List<QuizDTO> results) throws SQLException;

	/**
	 * 사용자가 오늘 퀴즈에 참여했는지 확인
	 */
	boolean hasUserPlayedToday(String userId) throws SQLException;
	
	public List<QuizDTO> getTodaysQuizAndUserAnswers(String userId) throws SQLException;
	
	boolean isQuizCompletedToday(String userId);

}
