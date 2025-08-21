package com.pcwk.ehr.quiz.service;

import java.util.List;

import com.pcwk.ehr.quiz.domain.QuizDTO;

public interface QuizService {


	List<QuizDTO> selectQuizList(QuizDTO dto) throws Exception;

	int getTotalQuizCount(QuizDTO dto) throws Exception;

	List<QuizDTO> selectUserRankingTop10(QuizDTO dto) throws Exception;

	QuizDTO selectQuizResult(QuizDTO dto) throws Exception;

}
