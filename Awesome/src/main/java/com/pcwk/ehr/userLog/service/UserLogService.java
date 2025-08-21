package com.pcwk.ehr.userLog.service;

import java.util.List;

import com.pcwk.ehr.userLog.domain.UserChartDTO;
import com.pcwk.ehr.userLog.domain.UserLogDTO;

public interface UserLogService {

    /**
     * 사용자 클릭 로그 저장
     */
    void logArticleClick(String userId, Long articleCode);

    /**
     * 특정 사용자 로그 목록 조회
     */
    List<UserLogDTO> getLogsByUser(String userId);

    /**
     * 전체 로그 조회
     */
    List<UserLogDTO> getAllLogs();

    /**
     * 로그 단건 삭제
     */
    int deleteLog(long logCode);
    
    /**
     * 유저별  클릭한 카테고리 조회
     */
    List<UserChartDTO> doRetrieveById(UserLogDTO log);
}