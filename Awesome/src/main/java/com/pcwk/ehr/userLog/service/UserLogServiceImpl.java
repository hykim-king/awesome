package com.pcwk.ehr.userLog.service;

import java.util.List;

import com.pcwk.ehr.userLog.domain.UserLogDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pcwk.ehr.mapper.UserLogMapper;

/**
 * UserLogService 구현체
 * - 사용자 클릭 로그 저장, 조회, 삭제 기능을 처리
 * - DB 연동은 UserLogMapper를 통해 수행
 */
@Service
public class UserLogServiceImpl implements UserLogService {

    private final UserLogMapper userLogMapper;

    /**
     * 생성자 주입
     * @param userLogMapper UserLogMapper 인터페이스
     */
    @Autowired
    public UserLogServiceImpl(UserLogMapper userLogMapper) {
        this.userLogMapper = userLogMapper;
    }

    /**
     * 사용자 클릭 로그 저장
     * @param userId 클릭한 사용자 ID
     * @param articleCode 클릭한 기사 코드
     */
    @Override
    public void logArticleClick(String userId, Long articleCode) {
        if (userId == null || articleCode == null) return; // 필수값 체크
        UserLogDTO dto = new UserLogDTO();
        dto.setUserId(userId);
        dto.setArticleCode(articleCode);
        userLogMapper.doSave(dto); // INSERT 실행
    }

    /**
     * 특정 사용자의 로그 목록 조회
     * @param userId 조회 대상 사용자 ID
     * @return 해당 사용자의 로그 목록
     */
    @Override
    public List<UserLogDTO> getLogsByUser(String userId) {
        UserLogDTO dto = new UserLogDTO();
        dto.setUserId(userId);
        return userLogMapper.doRetrieveByUser(dto);
    }

    /**
     * 전체 사용자 로그 목록 조회
     * @return 모든 로그 목록
     */
    @Override
    public List<UserLogDTO> getAllLogs() {
        return userLogMapper.doRetrieve();
    }

    /**
     * 로그 단건 삭제
     * @param logCode 삭제할 로그 코드(PK)
     * @return 삭제된 행 수 (1: 성공, 0: 실패)
     */
    @Override
    public int deleteLog(long logCode) {
        UserLogDTO dto = new UserLogDTO();
        dto.setLogCode(logCode);
        return userLogMapper.doDelete(dto);
    }
}