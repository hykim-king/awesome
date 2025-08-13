package com.pcwk.ehr.chatmessage;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import com.google.gson.Gson;
import com.pcwk.ehr.chatmessage.domain.ChatMessageDTO;
import com.pcwk.ehr.chatmessage.service.ChatMessageService;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.MediaType;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

public class ChatMessageControllerTest {

    final Logger log = LogManager.getLogger(getClass());

    private MockMvc mockMvc;

    @Mock
    private ChatMessageService service;

    @Mock
    private SimpMessagingTemplate messagingTemplate;

    @InjectMocks
    private com.pcwk.ehr.chatmessage.controller.ChatMessageController controller;

    private Gson gson;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.initMocks(this);
        mockMvc = MockMvcBuilders.standaloneSetup(controller).build();
        gson = new Gson();
        log.debug("┌───────────────────────────────┐");
        log.debug("│ ChatMessageControllerTest setUp() │");
        log.debug("└───────────────────────────────┘");
    }

    @Test
    void doSelectOne() throws Exception {
        int chatCode = 267;

        mockMvc.perform(get("/chat/" + chatCode))
               .andExpect(status().isOk());

        log.debug("✅ doSelectOne() 테스트 완료");
    }

    @Test
    void doDelete() throws Exception {
        int chatCode = 267;

        mockMvc.perform(delete("/chat/" + chatCode))
               .andExpect(status().isOk());

        log.debug("✅ doDelete() 테스트 완료");
    }

	/*
	 * @Test void doSave() throws Exception { ChatMessageDTO dto = new
	 * ChatMessageDTO(); dto.setCategory(10); dto.setUserId("user01");
	 * dto.setMessage("단위 테스트 메시지");
	 * 
	 * String json = gson.toJson(dto);
	 * 
	 * mockMvc.perform(post("/chat/send") .contentType(MediaType.APPLICATION_JSON)
	 * .content(json)) .andExpect(status().isOk());
	 * 
	 * log.debug("✅ doSave() 테스트 완료");
	 * 
	 * }
	 */
}