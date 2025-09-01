package com.pcwk.ehr.admin.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.pcwk.ehr.mapper.MemberMapper;
import com.pcwk.ehr.member.domain.MemberDTO;

@Service
public class AdminMemberServiceImpl implements AdminMemberService {

    @Autowired
    private MemberMapper mapper;

    @Override
    public int count(String type, String keyword, Integer grade) {
        return mapper.countMembersForAdmin(type, keyword, grade);
    }

    @Override
    public List<MemberDTO> list(String type, String keyword, Integer grade, int page, int size) {
        int p = Math.max(page, 1);
        int s = Math.max(size, 10);
        int offset = (p - 1) * s;
        return mapper.listMembersForAdmin(type, keyword, grade, offset, s);
    }

    @Override
    public int updateGrade(String userId, int grade) {
        return mapper.updateGradeByUserId(userId, grade);
    }

    @Override
    public int deleteMany(List<String> userIds) {
        if (userIds == null || userIds.isEmpty()) return 0;
        return mapper.deleteMembersByIds(userIds);
    }
}
