package com.pcwk.ehr.report;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
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

	MockMvc mockMvc;

	@Autowired
	WebApplicationContext wac;

	@Autowired
	ReportMapper reportmapper;

	@Autowired
	ChatMessageMapper chatMessageMapper;

	private int chatCode;

	@BeforeEach
	void setUp() throws Exception {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ setUp()                               │");
		log.debug("└───────────────────────────────────────┘");
		this.mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();

		// 채팅 1건 저장(신고대상)
		ChatMessageDTO cm = new ChatMessageDTO();
		cm.setCategory(10);
		cm.setUserId("user01");
		cm.setMessage("어쩌구 저쩌구");
		cm.setSendDt(new java.util.Date());
		chatMessageMapper.doSave(cm);
		chatCode = cm.getChatCode();
		assertTrue(chatCode > 0);

	}

	@AfterEach
	void tearDown() throws Exception {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ tearDown()                            │");
		log.debug("└───────────────────────────────────────┘");
	}
	

	@Disabled
	@Test
	void beans() {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ beans()                               │");
		log.debug("└───────────────────────────────────────┘");

		assertNotNull(wac);
		assertNotNull(reportmapper);
		assertNotNull(chatMessageMapper);

		log.debug("webApplicationContext:{}", wac);
		log.debug("mapper:{}", reportmapper);
		log.debug("mapper:{}", chatMessageMapper);

	}

}
