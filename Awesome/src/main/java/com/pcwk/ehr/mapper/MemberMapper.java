package com.pcwk.ehr.mapper;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.pcwk.ehr.cmn.WorkDiv;
import com.pcwk.ehr.member.domain.MemberDTO;

@Mapper
public interface MemberMapper extends WorkDiv<MemberDTO> {

    
    
    int deleteAll() throws SQLException;


    int getCount();


    int idCheck(String userId);

    void updateEmailAuthToken(String email, String token);
}
