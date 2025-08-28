package com.pcwk.ehr.admin.service;

import java.util.List;
import com.pcwk.ehr.member.domain.MemberDTO;

public interface AdminMemberService {
    int count(String type, String keyword, Integer grade);
    
    List<MemberDTO> list(String type, String keyword, Integer grade, int page, int size);
    
    int updateGrade(String userId, int grade);
    
    int deleteMany(List<String> userIds);
}
