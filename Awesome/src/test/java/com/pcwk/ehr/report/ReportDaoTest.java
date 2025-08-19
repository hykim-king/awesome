package com.pcwk.ehr.report;

import static org.junit.Assert.assertNull;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

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
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })

class ReportDaoTest {
	Logger log = LogManager.getLogger(getClass());

	@Autowired
	ApplicationContext context;

	@Autowired
	ReportMapper reportmapper;

	@Autowired
	ChatMessageMapper chatMessagemapper; // ★ 실제 매퍼 주입

	// 카테고리(예: 정치=10)
	static final int POLITICS = 10;

	// 매 테스트마다 사용할 chatCode
	int chatCode;

	@BeforeEach
	void setUp() throws Exception {
		log.debug("┌─────────────────────────────────┐");
		log.debug("│ setUp()                         │");
		log.debug("└─────────────────────────────────┘");

		// 1) FK 제약 때문에 REPORT 먼저 비우고 → CHAT_MESSAGE 비우기
		reportmapper.deleteAll();

		chatMessagemapper.deleteAll();

		// 2) 실제 채팅 1건 저장 → chatCode 확보
		ChatMessageDTO cm = new ChatMessageDTO();
		cm.setCategory(POLITICS);
		cm.setUserId("user01");
		cm.setMessage("테스트 메시지");
		cm.setSendDt(new Date());
		cm.setReason(10);        // 신고 사유 → 두 자리
		cm.setStatus(1);         // 0=검토중, 1=조치완료

		int saved = chatMessagemapper.doSave(cm);
		assertEquals(1, saved, "채팅 저장 1건이어야 함");
		assertTrue(cm.getChatCode() > 0, "시퀀스로 chatCode가 채워져야 함");

		chatCode = cm.getChatCode();
	}

	private ReportDTO buildReport(String reporter, String target, int reason, int status) {
		ReportDTO dto = new ReportDTO();
		dto.setChatCode(chatCode); // ★ 실제 chatCode 사용
		dto.setUserId(reporter);
		dto.setCtId(target);
		dto.setReason(reason);
		dto.setStatus(status); // "I"(검토중) / "D"(조치완료)
		return dto;
	}

	@AfterEach
	void tearDown() throws Exception {
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

		ReportDTO outVO = buildReport("user01", "targetY", 10, 0);
		reportmapper.doSave(outVO);

		ReportDTO key = new ReportDTO();
		key.setReportCode(outVO.getReportCode());

		ReportDTO out = reportmapper.doSelectOne(key);
		assertNotNull(out);
		assertEquals(outVO.getReportCode(), out.getReportCode());
		assertEquals(chatCode, out.getChatCode());
		assertEquals("user01", out.getUserId());
		assertEquals(10, out.getReason());
		assertEquals(0, out.getStatus());

		log.debug("조회 결과: {}", out);

	}

	//@Disabled
	@Test
	void doSelectOne() throws Exception {
		log.debug("┌─────────────────────────────────┐");
		log.debug("│ doSelectOne()                   │");
		log.debug("└─────────────────────────────────┘");

		ReportDTO in = buildReport("user01", "targetY", 10, 0);
		reportmapper.doSave(in);

		ReportDTO key = new ReportDTO();
		key.setReportCode(in.getReportCode());

		ReportDTO out = reportmapper.doSelectOne(key);
		log.debug("조회된 데이터: {}", out);

		assertEquals(in.getReportCode(), out.getReportCode());
		assertEquals(chatCode, out.getChatCode());
		assertEquals("user01", out.getUserId());
		assertEquals(10, out.getReason());
		assertEquals(0, out.getStatus());
	}

	//@Disabled
	@Test
	void doRetrieve() throws SQLException {
	    log.debug("┌────────────────────────────┐");
	    log.debug("│ doRetrieve()               │");
	    log.debug("└────────────────────────────┘");

	    // 0) 초기화 (FK 무결성: REPORT → CHAT_MESSAGE)
	    reportmapper.deleteAll();
	    chatMessagemapper.deleteAll();

	    // 1) 채팅 1건 저장 → chatCode 확보
	    ChatMessageDTO cm = new ChatMessageDTO();
	    cm.setCategory(POLITICS);
	    cm.setUserId("user01");
	    cm.setMessage("테스트 메시지");
	    cm.setSendDt(new java.util.Date());
	    chatMessagemapper.doSave(cm);
	    int chatCode = cm.getChatCode();
	    log.debug("chatCode 확보: {}", chatCode);

	    // 2) 신고 23건 저장
	    for (int i = 1; i <= 23; i++) {
	        ReportDTO r = new ReportDTO();
	        r.setChatCode(chatCode);
	        r.setUserId("reporter" + i);
	        r.setCtId("target" + i);
	        r.setReason(10);  // 두 자리 코드
	        r.setStatus(1);   // 0/1
	        int saved = reportmapper.doSave(r);
	        assertEquals(1, saved);
	    }
//	    int total = reportmapper.getCount();
//	    log.debug("총 건수: {}", total);
//	    assertEquals(23, total);

	    // 3) 검색/페이징 조건 (ReportSearchDTO)
	    ReportSearchDTO cond = new ReportSearchDTO();
	    cond.setPageNo(1);
	    cond.setPageSize(10);
	    cond.recalc(); // DTO.pageNo/pageSize 기반으로 startRow/endRow 계산
	    // cond.setSearchWord("reporter");
	    // cond.setStatus(1);

	    List<ReportDTO> page1 = reportmapper.doRetrieve(cond);
	    log.debug("페이지1 size: {}", page1.size());
	    page1.forEach(v -> log.debug("  P1 -> {}", v));
	    assertEquals(10, page1.size());

	    cond.setPageNo(2);
	    cond.recalc();
	    List<ReportDTO> page2 = reportmapper.doRetrieve(cond);
	    log.debug("페이지2 size: {}", page2.size());
	    page2.forEach(v -> log.debug("  P2 -> {}", v));
	    assertEquals(10, page2.size());

	    cond.setPageNo(3);
	    cond.recalc();
	    List<ReportDTO> page3 = reportmapper.doRetrieve(cond);
	    log.debug("페이지3 size: {}", page3.size());
	    page3.forEach(v -> log.debug("  P3 -> {}", v));
	    assertEquals(3, page3.size());
	}
	
	//@Disabled
	@Test
	void doUpdate()throws SQLException {
		log.debug("┌─────────────────────────────────┐");
		log.debug("│ doUpdate()                      │");
		log.debug("└─────────────────────────────────┘");
		
		ReportDTO in = buildReport("user01", "targetZ", 30, 0);
		reportmapper.doSave(in);
        log.debug("▶ 저장된 reportCode: {}", in.getReportCode());
        
        in.setStatus(0);
        int u = reportmapper.doUpdate(in);
        log.debug("doupdate 결과:{}", u);
        
        ReportDTO key = new ReportDTO();
        key.setReportCode(in.getReportCode());
        ReportDTO outVO = reportmapper.doSelectOne(key);
        assertEquals(0, outVO.getStatus());
               
	}
	
	//@Disabled
	@Test
	void doDelete()throws SQLException {
		log.debug("┌─────────────────────────────────┐");
		log.debug("│ doDelete()                      │");
		log.debug("└─────────────────────────────────┘");
		
		ReportDTO in = buildReport("user01", "targetZ", 30, 0);
		reportmapper.doSave(in);
		
		ReportDTO key = new ReportDTO();
		key.setReportCode(in.getReportCode());
		int flag = reportmapper.doDelete(key);
		log.debug("dodelete 결과: {}", flag);

		
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
