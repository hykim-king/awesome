package com.pcwk.ehr.admin.service;

import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.pcwk.ehr.mapper.MemberMapper;
import com.pcwk.ehr.member.domain.MemberDTO;

/**
 * 롬복 없이 생성자 주입(@Autowired) 사용
 */
@Service
public class AdminMemberServiceImpl implements AdminMemberService {

    private static final Logger log = LogManager.getLogger(AdminMemberServiceImpl.class);
    private final MemberMapper mapper;

    @Autowired
    public AdminMemberServiceImpl(MemberMapper mapper) {
        this.mapper = mapper;
    }

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

    /** 참조 카운트 DTO (안내 메시지용) */
    public static class RefCount {
        public int quiz;          // QUIZ_RESULT.USER_ID
        public int reportUser;    // REPORT.USER_ID(신고자)
        public int reportTarget;  // REPORT.CT_ID(피신고자)
        public int chat;          // CHAT_MESSAGE.USER_ID

        public boolean hasAny() {
            return (quiz > 0) || (reportUser > 0) || (reportTarget > 0) || (chat > 0);
        }

        public String toHuman() {
            StringBuilder sb = new StringBuilder("연결된 데이터가 있어 삭제할 수 없습니다. ");
            if (quiz > 0)         sb.append("[퀴즈결과 ").append(quiz).append("건] ");
            if (reportUser > 0)   sb.append("[신고(신고자) ").append(reportUser).append("건] ");
            if (reportTarget > 0) sb.append("[신고(피신고자) ").append(reportTarget).append("건] ");
            if (chat > 0)         sb.append("[채팅 ").append(chat).append("건] ");
            return sb.toString().trim();
        }
    }

    /** 참조 카운트 조회 */
    @Override
    public RefCount getRefCounts(List<String> ids) {
        RefCount rc = new RefCount();
        if (ids == null || ids.isEmpty()) return rc;
        rc.quiz         = mapper.countQuizByIds(ids);
        rc.reportUser   = mapper.countReportByUserIds(ids);
        rc.reportTarget = mapper.countReportByTargetIds(ids);
        rc.chat         = mapper.countChatByUserIds(ids);
        return rc;
    }

    /** 운영용 안전삭제: 참조가 남아 있으면 예외 발생 → 컨트롤러에서 사용자에게 친절히 안내 */
    @Override
    @Transactional
    public int deleteMany(List<String> ids) {
        if (ids == null || ids.isEmpty()) return 0;

        RefCount rc = getRefCounts(ids);
        if (rc.hasAny()) {
            log.warn("[ADMIN] deleteMany blocked. {}", rc.toHuman());
            throw new DataIntegrityViolationException(rc.toHuman());
        }

        int n = mapper.deleteMembersByIds(ids);
        log.info("[ADMIN] deleteMembersByIds success, count={}", n);
        return n;
    }

    /** 강제삭제: 자식 먼저 삭제 후 MEMBER 삭제 */
    @Override
    @Transactional
    public int deleteManyForce(List<String> ids) {
        if (ids == null || ids.isEmpty()) return 0;

        // 1) 자식 선삭제
        mapper.deleteQuizByUserIds(ids);
        mapper.deleteReportByTargetIds(ids);
        mapper.deleteReportByUserIds(ids);
        mapper.deleteChatByUserIds(ids);

        // 2) 부모 삭제
        int n = mapper.deleteMembersByIds(ids);
        log.info("[ADMIN] deleteManyForce success, count={}", n);
        return n;
    }
}
