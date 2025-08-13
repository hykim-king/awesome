package com.pcwk.ehr.chatmessage;

import static org.junit.Assert.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

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

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })
class ChatMessageDaoTest {
	Logger log = LogManager.getLogger(getClass());

	@Autowired
	ApplicationContext context;

	@Autowired
	ChatMessageMapper mapper;

	// 카테고리 코드(정치(10), 경제(20), 사회/문화(30), 스포츠(40), 연예(50), it/과학(60)
	static final int politics = 10;

	ChatMessageDTO m1, m2, m3;

	@BeforeEach
	void setUp() throws Exception {
		log.debug("┌─────────────────────────────────┐");
		log.debug("│ setUp()                         │");
		log.debug("└─────────────────────────────────┘");

		// 테스트용 메시지
		m1 = new ChatMessageDTO();
		m1.setCategory(politics);
		m1.setUserId("user01");
		m1.setMessage("메시지01");
		m1.setSendDt(new Date());

		m2 = new ChatMessageDTO();
		m2.setCategory(politics);
		m2.setUserId("user02");
		m2.setMessage("메시지02");
		m2.setSendDt(new Date());

		m3 = new ChatMessageDTO();
		m3.setCategory(politics);
		m3.setUserId("user03");
		m3.setMessage("메시지03");
		m3.setSendDt(new Date());
	}

	@AfterEach
	void tearDown() throws Exception {
		log.debug("┌─────────────────────────────────┐");
		log.debug("│ tearDown()                      │");
		log.debug("└─────────────────────────────────┘");
	}

	@Disabled
	@Test
	void find_recent_by_category() {
		log.debug("┌─────────────────────────────────┐");
		log.debug("│ find_recent_by_category()       │");
		log.debug("└─────────────────────────────────┘");

	    m1.setCategory(politics);
	    m2.setCategory(politics);
	    m3.setCategory(politics);
		
		mapper.doSave(m1);
		mapper.doSave(m2);
		mapper.doSave(m3);

		List<ChatMessageDTO> list = mapper.findRecentByCategory(politics, 2);
		
		assertEquals(2, list.size());
		assertTrue(list.get(0).getChatCode() > list.get(1).getChatCode());//최신순

	}

	@Disabled
	@Test
	void find_before_code() throws Exception {
		log.debug("┌─────────────────────────────────┐");
		log.debug("│ find_before_code()              │");
		log.debug("└─────────────────────────────────┘");

        ChatMessageDTO m1 = new ChatMessageDTO(0, politics, "u1", "msg1", null);
        ChatMessageDTO m2 = new ChatMessageDTO(0, politics, "u2", "msg2", null);
        ChatMessageDTO m3 = new ChatMessageDTO(0, politics, "u3", "msg3", null);
		
		mapper.doSave(m1);
        mapper.doSave(m2);
        mapper.doSave(m3);

		int last = m3.getChatCode(); // 가장 최근 m3 이전 2건들 요청
		List<ChatMessageDTO> older = mapper.findBeforeCode(politics, last, 2);
		
        assertNotNull(older);
		assertEquals(2, older.size());
		assertTrue(older.get(0).getChatCode() < last);
		assertTrue(older.get(1).getChatCode() < last);
		assertTrue(older.get(0).getChatCode()>older.get(1).getChatCode());

	}

	@Disabled
	@Test
	void doDelete() throws Exception {
		log.debug("┌─────────────────────────────────┐");
		log.debug("│ doDelete()                      │");
		log.debug("└─────────────────────────────────┘");

		mapper.deleteAll();

		mapper.doSave(m1);
		int deleted = mapper.doDelete(m1);
		assertEquals(1, deleted);

		ChatMessageDTO outVO = mapper.doSelectOne(m1);
		assertNull(outVO, "삭제 후에는 조회가 null이어야 함");

	}

	@Disabled
	@Test
	void doSave() throws Exception {
		log.debug("┌─────────────────────────────────┐");
		log.debug("│ doSave()                        │");
		log.debug("└─────────────────────────────────┘");

		mapper.deleteAll();

		int flag = mapper.doSave(m1);
		assertEquals(1, flag);

		ChatMessageDTO outVO = mapper.doSelectOne(m1);
		assertNotNull(outVO);
		assertEquals(m1.getChatCode(), outVO.getChatCode());
		assertEquals("메시지01", outVO.getMessage());
		assertEquals(politics, outVO.getCategory());
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
