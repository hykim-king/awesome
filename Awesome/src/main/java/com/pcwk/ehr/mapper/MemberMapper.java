package com.pcwk.ehr.mapper;

import java.sql.SQLException;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.pcwk.ehr.cmn.WorkDiv;
import com.pcwk.ehr.member.domain.MemberDTO;

@Mapper
public interface MemberMapper extends WorkDiv<MemberDTO> {

    int deleteAll() throws SQLException;

    int getCount();

    int idCheck(String userId);
    
    int existsById(@Param("userId") String userId);

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
}
