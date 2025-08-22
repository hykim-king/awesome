package com.pcwk.ehr.report;

import static org.junit.jupiter.api.Assertions.*;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import com.pcwk.ehr.chatmessage.domain.ChatMessageDTO;
import com.pcwk.ehr.mapper.ChatMessageMapper;
import com.pcwk.ehr.mapper.ReportMapper;
import com.pcwk.ehr.report.domain.ReportDTO;
import com.pcwk.ehr.report.domain.ReportSearchDTO;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {
    "file:src/main/webapp/WEB-INF/spring/root-context.xml",
    "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
class ReportDaoTest {

    Logger log = LogManager.getLogger(getClass());

    @Autowired ApplicationContext context;
    @Autowired ReportMapper reportmapper;
    @Autowired ChatMessageMapper chatMessagemapper;

    // 카테고리(예: 정치=10)
    static final int POLITICS = 10;

    // 상태/사유 상수(Mapper.xml: VARCHAR2 기준)
    static final String ST_RECEIVED  = "RECEIVED";
    static final String ST_REVIEWING = "REVIEWING";
    static final String ST_RESOLVED  = "RESOLVED";

    static final String RS_SPAM  = "SPAM";
    static final String RS_OTHER = "OTHER";

    int chatCode; // 매 테스트에서 쓰일 채팅 PK

    @BeforeEach
    void setUp() throws Exception {
        log.debug("┌─────────────────────────────────┐");
        log.debug("│ setUp()                         │");
        log.debug("└─────────────────────────────────┘");

        // FK 무결성: REPORT -> CHAT_MESSAGE
        reportmapper.deleteAll();
        chatMessagemapper.deleteAll();

        // 채팅 1건 저장 → chatCode 확보
        ChatMessageDTO cm = new ChatMessageDTO();
        cm.setCategory(POLITICS);
        cm.setUserId("user01");
        cm.setMessage("테스트 메시지");
        cm.setSendDt(new Date());

        int saved = chatMessagemapper.doSave(cm);
        assertEquals(1, saved, "채팅 저장 1건이어야 함");
        assertTrue(cm.getChatCode() > 0, "시퀀스로 chatCode가 채워져야 함");
        chatCode = cm.getChatCode();
    }

    private ReportDTO buildReport(String reporter, String targetUserId,
                                  String reasonCode, String status) {
        ReportDTO dto = new ReportDTO();
        dto.setChatCode(chatCode);     // FK
        dto.setUserId(reporter);
        dto.setCtId(targetUserId);     // 신고대상 ID(필요 시)
        dto.setReason(reasonCode);     // ex) "SPAM", "OTHER"
        dto.setStatus(status);         // ex) "RECEIVED"
        return dto;
    }

    @AfterEach
    void tearDown() {
        log.debug("┌─────────────────────────────────┐");
        log.debug("│ tearDown()                      │");
        log.debug("└─────────────────────────────────┘");
    }

    //@Disabled
    @Test
    void doSave() throws Exception {
        log.debug("┌─────────────────────────────────┐");
        log.debug("│ doSave()                        │");
        log.debug("└─────────────────────────────────┘");

        ReportDTO in = buildReport("user01", "targetY", RS_SPAM, ST_RECEIVED);
        int flag = reportmapper.doSave(in);
        assertEquals(1, flag);

        ReportDTO key = new ReportDTO();
        key.setReportCode(in.getReportCode());

        ReportDTO out = reportmapper.doSelectOne(key);
        assertNotNull(out);
        assertEquals(in.getReportCode(), out.getReportCode());
        assertEquals(chatCode, out.getChatCode());
        assertEquals("user01", out.getUserId());
        assertEquals(RS_SPAM, out.getReason());
        assertEquals(ST_RECEIVED, out.getStatus());

        log.debug("조회 결과: {}", out);
    }

    //@Disabled
    @Test
    void doSelectOne() throws Exception {
        log.debug("┌─────────────────────────────────┐");
        log.debug("│ doSelectOne()                   │");
        log.debug("└─────────────────────────────────┘");

        ReportDTO in = buildReport("user01", "targetY", RS_SPAM, ST_RECEIVED);
        reportmapper.doSave(in);

        ReportDTO key = new ReportDTO();
        key.setReportCode(in.getReportCode());

        ReportDTO out = reportmapper.doSelectOne(key);
        log.debug("조회된 데이터: {}", out);

        assertEquals(in.getReportCode(), out.getReportCode());
        assertEquals(chatCode, out.getChatCode());
        assertEquals("user01", out.getUserId());
        assertEquals(RS_SPAM, out.getReason());
        assertEquals(ST_RECEIVED, out.getStatus());
    }

    //@Disabled
    @Test
    void doRetrieve() throws SQLException {
        log.debug("┌────────────────────────────┐");
        log.debug("│ doRetrieve()               │");
        log.debug("└────────────────────────────┘");

        // 초기화
        reportmapper.deleteAll();
        chatMessagemapper.deleteAll();

        // 채팅 1건 저장
        ChatMessageDTO cm = new ChatMessageDTO();
        cm.setCategory(POLITICS);
        cm.setUserId("user01");
        cm.setMessage("테스트 메시지");
        cm.setSendDt(new java.util.Date());
        chatMessagemapper.doSave(cm);
        int chatCode = cm.getChatCode();
        log.debug("chatCode 확보: {}", chatCode);

        // 신고 23건 저장
        for (int i = 1; i <= 23; i++) {
            ReportDTO r = new ReportDTO();
            r.setChatCode(chatCode);
            r.setUserId("reporter" + i);
            r.setCtId("target" + i);
            r.setReason(RS_SPAM);
            r.setStatus(ST_RECEIVED);
            int saved = reportmapper.doSave(r);
            assertEquals(1, saved);
        }

        // 검색/페이징 조건
        ReportSearchDTO cond = new ReportSearchDTO();
        cond.setPageNo(1);
        cond.setPageSize(10);
        cond.recalc(); // (ROWNUM StopKey 사용 시 start/end 계산에 쓰일 수 있음)
        // cond.setSearchWord("reporter");
        // cond.setStatus(ST_RECEIVED);

        List<ReportDTO> page1 = reportmapper.doRetrieve(cond);
        log.debug("페이지1 size: {}", page1.size());
        page1.forEach(v -> log.debug("  P1 -> {}", v));
        assertEquals(10, page1.size());

        cond.setPageNo(2); cond.recalc();
        List<ReportDTO> page2 = reportmapper.doRetrieve(cond);
        log.debug("페이지2 size: {}", page2.size());
        page2.forEach(v -> log.debug("  P2 -> {}", v));
        assertEquals(10, page2.size());

        cond.setPageNo(3); cond.recalc();
        List<ReportDTO> page3 = reportmapper.doRetrieve(cond);
        log.debug("페이지3 size: {}", page3.size());
        page3.forEach(v -> log.debug("  P3 -> {}", v));
        assertEquals(3, page3.size());
    }

    //@Disabled
    @Test
    void doUpdate() throws SQLException {
        log.debug("┌─────────────────────────────────┐");
        log.debug("│ doUpdate()                      │");
        log.debug("└─────────────────────────────────┘");

        ReportDTO in = buildReport("user01", "targetZ", RS_OTHER, ST_RECEIVED);
        reportmapper.doSave(in);
        log.debug("▶ 저장된 reportCode: {}", in.getReportCode());

        // 상태 변경(동적 update)
        in.setStatus(ST_REVIEWING);
        int u = reportmapper.doUpdate(in);
        log.debug("doUpdate 결과: {}", u);
        assertEquals(1, u);

        ReportDTO key = new ReportDTO();
        key.setReportCode(in.getReportCode());
        ReportDTO outVO = reportmapper.doSelectOne(key);
        assertEquals(ST_REVIEWING, outVO.getStatus());
        // MOD_DT는 Mapper에서 SYSDATE로 갱신(널 아님을 보려면 필요 시 assertNotNull(outVO.getModDt()))
    }

    //@Disabled
    @Test
    void doDelete() throws SQLException {
        log.debug("┌─────────────────────────────────┐");
        log.debug("│ doDelete()                      │");
        log.debug("└─────────────────────────────────┘");

        ReportDTO in = buildReport("user01", "targetZ", RS_SPAM, ST_RECEIVED);
        reportmapper.doSave(in);

        ReportDTO key = new ReportDTO();
        key.setReportCode(in.getReportCode());
        int flag = reportmapper.doDelete(key);
        log.debug("doDelete 결과: {}", flag);
        assertEquals(1, flag);

        ReportDTO outVO = reportmapper.doSelectOne(key);
        log.debug("삭제 후 조회 결과: {}", outVO);
        assertNull(outVO);
    }

    @Disabled
    @Test
    void beans() {
        log.debug("┌─────────────────────────────────┐");
        log.debug("│ beans()                         │");
        log.debug("└─────────────────────────────────┘");
        assertNotNull(context);
        log.debug("context: {}", context);
    }
}
