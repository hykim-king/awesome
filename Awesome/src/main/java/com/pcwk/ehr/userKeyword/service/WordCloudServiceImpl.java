package com.pcwk.ehr.userKeyword.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pcwk.ehr.mapper.UserKeywordMapper;
import com.pcwk.ehr.userKeyword.domain.UserKeywordDTO;

@Service
public class WordCloudServiceImpl implements WordCloudService{
	
	@Autowired
	UserKeywordMapper mapper;

	@Override
	public List<UserKeywordDTO> selectKeyword(String param) {
		return mapper.selectKeyword(param);
	}

}
