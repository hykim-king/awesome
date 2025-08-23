package com.pcwk.ehr.report;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;

import java.util.Date;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.pcwk.ehr.chatmessage.domain.ChatMessageDTO;
import com.pcwk.ehr.mapper.ChatMessageMapper;
import com.pcwk.ehr.mapper.ReportMapper;
import com.pcwk.ehr.report.controller.ReportAdminController;
import com.pcwk.ehr.report.domain.ReportDTO;

@WebAppConfiguration
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })
class ReportAdminControllerTest {

	Logger log = LogManager.getLogger(getClass());

	@Autowired
	WebApplicationContext wac;

	@Autowired
	ReportMapper reportmapper;

	@Autowired
	ChatMessageMapper chatMessagemapper;
	
	private MockMvc mockMvc;
	private MockHttpSession session;
	
    private int reportCode; // 테스트용 생성된 신고 코드

	
	@BeforeEach
	void setUp() throws Exception {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ setUp()                               │");
		log.debug("└───────────────────────────────────────┘");
		
		ReportAdminController controller = wac.getBean(ReportAdminController.class);
		
	    this.mockMvc = MockMvcBuilders
	            .standaloneSetup(controller)
	            .alwaysDo(print())
	            .build();
	    
	    // 세션 준비 (필요시)
	    session = new MockHttpSession();
	    session.setAttribute("USER_ID", "admin01");
	    
	    // 초기화 및 테스트 데이터 준비
	    reportmapper.deleteAll();
	    chatMessagemapper.deleteAll();

        // 1) 채팅 1건 저장 (신고 대상이 될 글)
        ChatMessageDTO cm = new ChatMessageDTO();
        cm.setCategory(10);
        cm.setUserId("targetUser");              
        cm.setMessage("관리자 테스트용 메시지");
        cm.setSendDt(new Date());
        chatMessagemapper.doSave(cm);

        // 2) 신고 1건 저장 (관리자 API가 조작할 대상)
        ReportDTO r = new ReportDTO();
        r.setChatCode(cm.getChatCode());
        r.setUserId("홍길동맨");
        r.setCtId(cm.getUserId());     
        r.setReason("스팸홍보/도배글입니다.");
        r.setStatus("RECEIVED");
        assertEquals(1, reportmapper.doSave(r));

        this.reportCode = r.getReportCode();
    }
	

	@AfterEach
	void tearDown() throws Exception {
	}

	@Disabled
	@Test
	void Admin_doRetrieve_report() throws Exception {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ Admin_doRetrieve_report()             │");
		log.debug("└───────────────────────────────────────┘");
		
        mockMvc.perform(get("/admin/report/list")
                .param("pageNo", "1") 
                .param("pageSize", "20")
                .param("status", "RECEIVED")
                // .param("searchType", "ID")
                // .param("searchWord", "reporter01")
                .session(session))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.rows").isArray())
            .andExpect(jsonPath("$.total", greaterThanOrEqualTo(1)))
            .andExpect(jsonPath("$.pageNo").value(1));

        log.debug(" 관리자 신고목록 종료");
	}
	@Disabled
	@Test
	void Admin_status_update_report()throws Exception {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ Admin_status_update_report()          │");
		log.debug("└───────────────────────────────────────┘");
		
        mockMvc.perform(patch("/admin/report/{reportCode}/status", reportCode)
                .param("status", "REVIEWING")
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .session(session))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.ok").value(true));

        log.debug("◀관리자 상태변경 종료");
	}
	@Disabled
	@Test
	void Admin_report_Delete()throws Exception {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ Admin_status_update_report()          │");
		log.debug("└───────────────────────────────────────┘");
		
        mockMvc.perform(delete("/admin/report/{reportCode}", reportCode)
                .session(session))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.ok").value(true));

        log.debug("관리자신고삭제 종료");
	}
	
	
	
	//@Disabled
	@Test
	void beans() {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ beans()                               │");
		log.debug("└───────────────────────────────────────┘");

		assertNotNull(wac);
		assertNotNull(reportmapper);
		assertNotNull(chatMessagemapper);

		log.debug("webApplicationContext:{}", wac);
		log.debug("mapper:{}", reportmapper);
		log.debug("mapper:{}", chatMessagemapper);
	}

}
