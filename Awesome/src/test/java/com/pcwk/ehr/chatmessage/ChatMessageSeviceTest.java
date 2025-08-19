package com.pcwk.ehr.chatmessage;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

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
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import com.pcwk.ehr.chatmessage.domain.ChatMessageDTO;
import com.pcwk.ehr.chatmessage.service.ChatMessageService;
import com.pcwk.ehr.mapper.ChatMessageMapper;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })

class ChatMessageSeviceTest {
	Logger log = LogManager.getLogger(getClass());

	@Autowired
	ChatMessageMapper mapper;

	@Autowired
	ApplicationContext context;

	@Autowired
	ChatMessageService service;

	ChatMessageDTO dto;

	@BeforeEach
	void setUp() throws Exception {
		log.debug("┌───────────────────────────────┐");
		log.debug("│ setUp()                       │");
		log.debug("└───────────────────────────────┘");

		dto = new ChatMessageDTO(0, 10, "user01", "어쩌구 저쩌구", null);
        service.deleteAll();
	}

	@AfterEach
	void tearDown() throws Exception {
		log.debug("┌───────────────────────────────┐");
		log.debug("│ tearDown()                    │");
		log.debug("└───────────────────────────────┘");
	}

	//@Disabled
	@Test
	void doSave() throws Exception {
		log.debug("┌───────────────────────────────┐");
		log.debug("│ doSave()                      │");
		log.debug("└───────────────────────────────┘");

		log.debug("doSave()");
		int result = service.doSave(dto);

		log.debug("저장 결과 : {}", result);
		assertEquals(1, result);
	}
	@Disabled
	@Test
	void doSelectOne() throws Exception {
		log.debug("┌───────────────────────────────┐");
		log.debug("│ doSelectOne()                 │");
		log.debug("└───────────────────────────────┘");
		
		service.doSave(dto);
		List<ChatMessageDTO> list = service.findRecentByCategory(10, 1);
		ChatMessageDTO saved = list.get(0);

		ChatMessageDTO result = service.doSelectOne(saved.getChatCode());
		log.debug("조회 결과 : {}", result);
		assertNotNull(result);
		assertEquals(saved.getChatCode(), result.getChatCode());
	}
	@Disabled
    @Test
    void doDelete() throws Exception {
		log.debug("┌───────────────────────────────┐");
		log.debug("│ doDelete()                    │");
		log.debug("└───────────────────────────────┘");
		
        service.doSave(dto);
        List<ChatMessageDTO> list = service.findRecentByCategory(10, 1);
        int code = list.get(0).getChatCode();

        int result = service.doDelete(code);
        assertEquals(1, result);
    }
	@Disabled
	@Test
	@Rollback(false) // 테스트 종료 후 rollback 방지 → 실제 DB 확인용
	void doDeleteByUserTest() throws Exception {
	    log.debug("┌───────────────────────────────────────────┐");
	    log.debug("│ doDeleteByUserTest()                      │");
	    log.debug("└───────────────────────────────────────────┘");

	    // 1. 저장
	    int saved = service.doSave(dto); // userId: user01
	    log.debug("1. 저장된 행 수 : {}", saved);

	    // 2. 최근 chatCode 가져오기
	    List<ChatMessageDTO> recent = service.findRecentByCategory(dto.getCategory(), 1);
	    ChatMessageDTO lastMsg = recent.get(0);
	    log.debug("2. 삭제할 메시지: {}", lastMsg);

	    // 3. 삭제 요청
	    int deleted = mapper.doDeleteByUser(lastMsg.getChatCode(), "user01");
	    log.debug("3. 삭제된 행 수 : {}", deleted);

	    assertEquals(1, deleted); // 삭제 성공 확인
	}
	@Disabled
    @Test
    void findRecentByCategory() throws Exception {
		log.debug("┌───────────────────────────────┐");
		log.debug("│ findRecentByCategory()        │");
		log.debug("└───────────────────────────────┘");
		
        service.doSave(dto);
        List<ChatMessageDTO> list = service.findRecentByCategory(10, 5);
        assertTrue(list.size() > 0);
        log.debug("최근 메시지 : {}", list);
    }
    @Disabled
    @Test
    void findBeforeCode() throws Exception {
		log.debug("┌───────────────────────────────┐");
		log.debug("│ findBeforeCode()              │");
		log.debug("└───────────────────────────────┘");
    	
        service.doSave(dto);
        List<ChatMessageDTO> list = service.findRecentByCategory(10, 1);
        int last = list.get(0).getChatCode();

        List<ChatMessageDTO> older = service.findBeforeCode(10, last, 2);
        assertTrue(older.isEmpty());
    }
    
    

	//@Disabled
	@Test
	void beans() {
		log.debug("┌───────────────────────────────┐");
		log.debug("│ beans()                       │");
		log.debug("└───────────────────────────────┘");

		assertNotNull(context);
		assertNotNull(service);

		log.debug("context: {}", context);
		log.debug("service: {}", service);
	}

}
