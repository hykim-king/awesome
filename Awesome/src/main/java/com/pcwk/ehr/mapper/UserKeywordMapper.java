package com.pcwk.ehr.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.pcwk.ehr.userKeyword.domain.UserKeywordDTO;

@Mapper
public interface UserKeywordMapper {

	List<UserKeywordDTO> selectKeyword(String userId);
	
}
