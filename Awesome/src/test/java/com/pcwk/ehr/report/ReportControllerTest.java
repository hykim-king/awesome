package com.pcwk.ehr.report;

import static org.hamcrest.CoreMatchers.containsString;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.Date;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assertions;
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

@WebAppConfiguration
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })
class ReportControllerTest {

	Logger log = LogManager.getLogger(getClass());

	@Autowired
	WebApplicationContext wac;

	@Autowired
	ReportMapper reportmapper;

	@Autowired
	ChatMessageMapper chatMessagemapper;

	private MockMvc mockMvc;
	private MockHttpSession session;

	// 테스트용 채팅 메시지 chatcode에 저장
	private int chatCode;

	@BeforeEach
	void setUp() throws Exception {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ setUp()                               │");
		log.debug("└───────────────────────────────────────┘");

		this.mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();

		// 세선에 로그인 사용자ID 주입
		session = new MockHttpSession();
		session.setAttribute("USER_ID", "user01");
		log.debug("세션에 UESR_ID = user01 주입");

		
		reportmapper.deleteAll(); chatMessagemapper.deleteAll();
		log.debug("기존 데이터 초기화 : REPORT, CHAT_MESSAGE 비움");
		

		// 채팅 1건 저장(신고대상)
		ChatMessageDTO cm = new ChatMessageDTO();
		cm.setCategory(10);
		cm.setUserId("targetUser");
		cm.setMessage("어쩌구 저쩌구");
		cm.setSendDt(new Date());
		int saved = chatMessagemapper.doSave(cm);
        Assertions.assertEquals(1, saved, "채팅 저장 결과");
		chatCode = cm.getChatCode();
        log.debug("테스트용 chatCode={}", chatCode);

	}

	@AfterEach
	void tearDown() throws Exception {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ tearDown()                            │");
		log.debug("└───────────────────────────────────────┘");
	}
	
	//@Disabled
	@Test
	void Create_report()throws Exception {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ Create_report()                       │");
		log.debug("└───────────────────────────────────────┘");
		
        String body = "{ \"chatCode\": "+chatCode+", \"reason\": \"SPAM\" }";
        
        mockMvc.perform(post("/report")
                .contentType(MediaType.APPLICATION_JSON)
                .content(body)
                .session(session)) // 컨트롤러가 HttpSession에서 USER_ID 읽게 함
            .andDo(print()) // 응답 본문 확인
            .andExpect(status().isOk())
            .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
            .andExpect(jsonPath("$.ok").value(true))
            .andExpect(jsonPath("$.reportCode").exists())
            .andExpect(jsonPath("$.message", containsString("접수")));

        log.debug("◀신고생성 OK_세션기반 종료");

	}
	//@Disabled
	@Test
	void doRetrieve_report()throws Exception {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ doRetrieve_report()                   │");
		log.debug("└───────────────────────────────────────┘");
		
		//한 건 신고 생성
		String body = "{ \"chatCode\": "+chatCode+", \"reason\": \"SPAM\" }";
        mockMvc.perform(post("/report")
                .contentType(MediaType.APPLICATION_JSON)
                .content(body)
                .session(session))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.ok").value(true));
        
        // 내 신고 목록 조회
        mockMvc.perform(get("/my/report/list")
                .param("pageNo", "1")
                .param("pageSize", "10")
                .session(session))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.rows").isArray())
            .andExpect(jsonPath("$.rows.length()", greaterThanOrEqualTo(1)))
            .andExpect(jsonPath("$.pageNo").value(1))
            .andExpect(jsonPath("$.pageSize").value(10));

        log.debug("마이페이지_내_신고목록_OK 종료");
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
