package com.pcwk.ehr.member.service;

import java.sql.SQLException;

import com.pcwk.ehr.member.domain.MemberDTO;


	

public interface MemberService {
	
	String findUserId(String userNm, String mailAddr) throws SQLException;

	boolean sendResetMail(String userId, String mailAddr);
	
	boolean existsById(String userId) throws SQLException;
    /**
     * 회원 가입
     * @param dto
     * @return 1(성공)/0(실패)
     * @throws SQLException
     */
    int register(MemberDTO dto) throws SQLException;

    /**
     * 단건 조회 (ID)
     * @param dto
     * @return MemberDTO
     * @throws SQLException
     */
    MemberDTO findById(MemberDTO dto) throws SQLException;

    /**
     * 회원정보 수정
     * @param dto
     * @return 1(성공)/0(실패)
     * @throws SQLException
     */
    int update(MemberDTO dto) throws SQLException;

    /**
     * 회원 삭제
     * @param dto
     * @return 1(성공)/0(실패)
     * @throws SQLException
     */
    int delete(MemberDTO dto) throws SQLException;

    /**
     * 이메일 인증 메일 전송
     * @param dto
     * @return true(성공)/false(실패)
     * @throws Exception
     */
    String sendEmailAuth(MemberDTO dto) throws Exception;

    /**
     * 이메일 인증 토큰 검증
     * @param token
     * @return true(성공)/false(실패)
     * @throws SQLException
     */
    boolean verifyEmailToken(String token) throws SQLException;

    /**
     * 로그인 시 비밀번호 일치 여부 확인
     * @param inputPwd
     * @param hashedPwd
     * @return true/false
     */
    boolean checkPassword(String inputPwd, String hashedPwd);

    /**
     * 로그인 처리
     * @param dto (userId, pwd)
     * @return 로그인한 사용자 정보 (비밀번호 제외)
     * @throws SQLException
     */
    MemberDTO login(MemberDTO dto) throws SQLException;
    
    
    boolean existsByNick(String nickNm) throws Exception;
    
    /**
     * 닉네임중복
     * @param 
     * @return 
     * @throws SQLException
     */
    
    int resetPassword(String token, String newPwd) throws SQLException;

   
    
    
}
