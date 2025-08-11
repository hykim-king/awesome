package com.pcwk.ehr.report;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.awt.RenderingHints.Key;
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

import com.pcwk.ehr.article.domain.ArticleSearchDTO;
import com.pcwk.ehr.chatmessage.domain.ChatMessageDTO;
import com.pcwk.ehr.mapper.ChatMessageMapper;
import com.pcwk.ehr.mapper.ReportMapper;
import com.pcwk.ehr.report.domain.ReportDTO;

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

        int saved = chatMessagemapper.doSave(cm);
        assertEquals(1, saved, "채팅 저장 1건이어야 함");
        assertTrue(cm.getChatCode() > 0, "시퀀스로 chatCode가 채워져야 함");

        chatCode = cm.getChatCode();
        }
	
    private ReportDTO buildReport(String reporter, String target, int reason, int status) {
        ReportDTO dto = new ReportDTO();
        dto.setChatCode(chatCode);   // ★ 실제 chatCode 사용
        dto.setUserId(reporter);
        dto.setCtId(target);
        dto.setReason(reason);
        dto.setStatus(status);       // "I"(검토중) / "D"(조치완료)
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
	void doSave() throws Exception{
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
        assertEquals(0 , out.getStatus());
        
		log.debug("조회 결과: {}", out);

	}
	//@Disabled
	@Test
	void doSelectOne() throws Exception{
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
	/*
	 * @Test void doRetrieve() { log.debug("┌─────────────────────────────────┐");
	 * log.debug("│ doRetrieve()                    │");
	 * log.debug("└─────────────────────────────────┘");
	 * 
	 * for(int i = 0; i <15; i++) { reportmapper.doSave(buildReport("user01",
	 * "targetY", 10, 0)); } log.debug("총 저장 건수",reportmapper.getCountByFilter(new
	 * ArticleSearchDTO()));
	 * 
	 * ArticleSearchDTO search = new ArticleSearchDTO(); search.setStartRow(1);
	 * search.setEndRow(10);
	 * 
	 * List<ReportDTO> page1 = reportmapper.doRetrieve(search); page1.forEach(vo ->
	 * log.debug(" {}", vo));
	 * 
	 * search.setStartRow(11); search.setEndRow(20); List<ReportDTO> page2 =
	 * reportmapper.doRetrieve(search); page2.forEach(vo -> log.debug(" {}", vo));
	 * 
	 * assertEquals(10, page1.size()); assertEquals(5, page2.size());
	 * 
	 * }
	 */
	
	
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
