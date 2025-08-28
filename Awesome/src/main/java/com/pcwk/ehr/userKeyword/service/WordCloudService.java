package com.pcwk.ehr.userKeyword.service;

import java.util.List;

import com.pcwk.ehr.userKeyword.domain.UserKeywordDTO;

public interface WordCloudService {
	
	List<UserKeywordDTO> selectKeyword(String param);

}
