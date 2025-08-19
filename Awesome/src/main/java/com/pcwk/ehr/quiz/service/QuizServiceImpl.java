package com.pcwk.ehr.quiz.service;

import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pcwk.ehr.mapper.QuizMapper;
import com.pcwk.ehr.quiz.domain.QuizDTO;

@Service
public class QuizServiceImpl implements QuizService{
	
	Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	QuizMapper mapper;
	
	public QuizServiceImpl() {}
	
	@Override
	public List<QuizDTO> selectQuizList(QuizDTO dto) throws Exception {
		
		return mapper.selectQuizList(dto);
		
	}
	
	@Override
	public int getTotalQuizCount(QuizDTO param) throws Exception{
		
		return mapper.getTotalQuizCount();
	}
	
	@Override
	public List<QuizDTO> selectUserRankingTop10(QuizDTO dto) throws Exception{
		
		return mapper.selectUserRankingTop10();
		
	}
	
	@Override
	public QuizDTO selectQuizResult(QuizDTO dto) throws Exception{
		
		return mapper.selectQuizResult(dto);
		
	}
	
	
	
	

}
