package com.pcwk.ehr.quiz.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.pcwk.ehr.mapper.QuizMapper;
import com.pcwk.ehr.quiz.domain.QuizDTO;
import com.pcwk.ehr.quiz.domain.RankingDTO;

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
    public List<RankingDTO> selectUserRankingTop10() throws Exception {
        return mapper.selectUserRankingTop10();
    }
	
	@Override
	public QuizDTO selectQuizResult(QuizDTO dto) throws Exception{
		
		return mapper.selectQuizResult(dto);
		
	}
	
	@Override
    public List<QuizDTO> getTodaysQuiz() throws SQLException {
        return mapper.selectTodaysQuiz();
    }

    @Override
    @Transactional
    public void submitQuizAnswers(List<QuizDTO> results) throws SQLException {
        // 모든 답변을 순회하며 DB에 저장
        for (QuizDTO result : results) {
            mapper.insertQuizResult(result);   // 먼저 답변을 저장하고
            mapper.updateScoreIfCorrect(result); // 정답이면 점수를 업데이트
        }
    }
    
    @Override
    public boolean hasUserPlayedToday(String userId) throws SQLException {
        return mapper.checkIfUserPlayedToday(userId) > 0;
    }
	
	
    @Override
    public List<QuizDTO> getTodaysQuizAndUserAnswers(String userId) throws SQLException {
        return mapper.selectTodaysQuizAndUserAnswers(userId);
    }
	

}
