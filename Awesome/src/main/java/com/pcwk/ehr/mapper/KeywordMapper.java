package com.pcwk.ehr.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.pcwk.ehr.keyword.domain.KeywordDTO;

@Mapper
public interface KeywordMapper {

    // 1건 저장
    int doSave(KeywordDTO keyword);

    // 전체 조회
    List<KeywordDTO> doRetrieve();

    // 삭제
    int doDelete(KeywordDTO keyword);
    
    int deleteAll();

    // 단건 조회
    KeywordDTO doSelectOne(KeywordDTO keyword);

    // 수정
    int doUpdate(KeywordDTO keyword);

    // 전체 건수 조회
    int getTotalCount();
}