package com.pcwk.ehr.mapper;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.pcwk.ehr.cmn.WorkDiv;
import com.pcwk.ehr.member.domain.MemberDTO;

@Mapper
public interface MemberMapper extends WorkDiv<MemberDTO> {
	
	int doDelete(String userId);

    int deleteAll() throws SQLException;

    int getCount();

    int idCheck(String userId);
    
    int existsById(@Param("userId") String userId);
    
    int existsByEmail(@org.apache.ibatis.annotations.Param("mailAddr") String mailAddr);

    MemberDTO findByUserId(@Param("userId") String userId);
    
    int markEmailVerifiedByToken(@Param("token") String token);

    //닉네임 중복
    int existsByNick(@Param("nickNm") String nickNm);

    String findUserId(@Param("userNm") String userNm,
            @Param("mailAddr") String mailAddr);
    
    /** 메일주소 기준으로 인증토큰만 갱신 */
    int updateEmailAuthTokenByEmail(@Param("email") String email,
                                    @Param("token") String token) throws SQLException;

    /** (선택) userId 기준 버전 */
    int updateEmailAuthTokenByUserId(@Param("userId") String userId,
                                     @Param("token") String token) throws SQLException;

    /** 토큰으로 회원 1건 조회 */
    MemberDTO findByEmailAuthToken(@Param("token") String token) throws SQLException;
    
    int updateResetToken(@Param("userId") String userId,
            @Param("mailAddr") String mailAddr,
            @Param("token") String token);

    int updatePasswordByToken(@Param("token") String token,
                 				@Param("pwd") String pwd);

    
    
 
    int countMembersForAdmin(@Param("type") String type,
                             @Param("keyword") String keyword,
                             @Param("grade") Integer grade);

    List<MemberDTO> listMembersForAdmin(@Param("type") String type,
                                        @Param("keyword") String keyword,
                                        @Param("grade") Integer grade,
                                        @Param("offset") int offset,
                                        @Param("limit") int limit);

    int updateGradeByUserId(@Param("userId") String userId,
                            @Param("grade") int grade);

    int deleteMembersByIds(@Param("list") List<String> ids);

    
}
