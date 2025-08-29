package com.pcwk.ehr.mapper;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.pcwk.ehr.cmn.WorkDiv;
import com.pcwk.ehr.member.domain.MemberDTO;

@Mapper
public interface MemberMapper extends WorkDiv<MemberDTO> {

    // ===== 참조 카운트 =====
    int countQuizByIds(@Param("ids") List<String> ids);
    int countReportByUserIds(@Param("ids") List<String> ids);
    int countReportByTargetIds(@Param("ids") List<String> ids);
    int countChatByUserIds(@Param("ids") List<String> ids);

    // ===== 자식 삭제 =====
    int deleteQuizByUserIds(@Param("ids") List<String> ids);
    int deleteReportByUserIds(@Param("ids") List<String> ids);
    int deleteReportByTargetIds(@Param("ids") List<String> ids);
    int deleteChatByUserIds(@Param("ids") List<String> ids);

    // ===== MEMBER 다건 삭제 =====
    int deleteMembersByIds(@Param("ids") List<String> ids);

    // ===== 관리자 목록/검색/등급 =====
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


    
}
