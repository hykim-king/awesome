package com.pcwk.ehr.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.pcwk.ehr.userLog.domain.UserChartDTO;
import com.pcwk.ehr.userLog.domain.UserLogDTO;

@Mapper
public interface UserLogMapper {

    // 1건 저장
    int doSave(UserLogDTO log);

    // 전체 조회
    List<UserLogDTO> doRetrieve();

    // 삭제
    int doDelete(UserLogDTO log);
    
    //전체삭제
    int deleteAll();

    // 단건 조회
    UserLogDTO doSelectOne(UserLogDTO log);

    // 특정 사용자 로그 조회
    List<UserLogDTO> doRetrieveByUser(UserLogDTO log);

    // 페이징 조회 (공용 DTO 사용 시 시그니처 유지)
    List<UserLogDTO> doRetrievePaging(com.pcwk.ehr.cmn.DTO dto);

    // 전체 건수
    int getTotalCount();
    
    //마이페이지 구글 차트 용 
    //유저별  클릭한 카테고리 조회
    List<UserChartDTO> doRetrieveById(UserLogDTO log);
}