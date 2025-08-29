package com.pcwk.ehr.admin.service;

import java.util.List;
import com.pcwk.ehr.member.domain.MemberDTO;

/**
 * 관리자 회원 관리 서비스 (목록, 등급변경, 안전삭제/강제삭제)
 */
public interface AdminMemberService {

    int count(String type, String keyword, Integer grade);

    List<MemberDTO> list(String type, String keyword, Integer grade, int page, int size);

    int updateGrade(String userId, int grade);

    /** 자식(참조) 데이터 개수 조회 - 안내 메시지용 */
    AdminMemberServiceImpl.RefCount getRefCounts(List<String> ids);

    /** 운영용 안전 삭제(참조가 남아 있으면 예외 발생 → 컨트롤러에서 안내) */
    int deleteMany(List<String> ids);

    /** 강제 삭제(자식부터 삭제 후 MEMBER 삭제) */
    int deleteManyForce(List<String> ids);
}
