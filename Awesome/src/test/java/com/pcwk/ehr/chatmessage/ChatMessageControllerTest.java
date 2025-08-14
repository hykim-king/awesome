package com.pcwk.ehr.chatmessage;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.http.MediaType;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.pcwk.ehr.chatmessage.domain.ChatMessageDTO;
import com.pcwk.ehr.chatmessage.service.ChatMessageService;

@WebAppConfiguration
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })
public class ChatMessageControllerTest {

    private final Logger log = LogManager.getLogger(getClass());

    @Configuration
    static class TestConfig {
        /** WebSocket 브로커를 실제로 띄우지 않기 위해 테스트용 SimpMessagingTemplate 등록 */
        @Bean
        public SimpMessagingTemplate messagingTemplate() {
            return Mockito.mock(SimpMessagingTemplate.class);
        }
    }

    @Autowired
    private WebApplicationContext wac;

    @Autowired
    private ChatMessageService service; // 실제 서비스/DAO/DB 사용

    private MockMvc mockMvc;
    private ObjectMapper om;

    private ChatMessageDTO seed;    // 사전 저장 데이터
    private int savedCode;          // 사전 저장된 chatCode

    private static final MediaType JSON_UTF8 =
        new MediaType(MediaType.APPLICATION_JSON.getType(),
                      MediaType.APPLICATION_JSON.getSubtype(),
                      StandardCharsets.UTF_8);

    @BeforeEach
    void setUp() throws Exception {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();
        om = new ObjectMapper();

        log.debug("┌──────────────────────────────────────┐");
        log.debug("│ ChatMessageControllerWebIT setUp()   │");
        log.debug("└──────────────────────────────────────┘");

        // 테스트 데이터 초기화
        service.deleteAll();
        seed = new ChatMessageDTO(0, 10, "user01", "hello from IT", null);
        Assertions.assertEquals(1, service.doSave(seed));

        // 최근 1건의 코드 확보
        List<ChatMessageDTO> recent = service.findRecentByCategory(10, 1);
        Assertions.assertFalse(recent.isEmpty());
        savedCode = recent.get(0).getChatCode();
        log.debug("◎ 사전 저장 chatCode = {}", savedCode);
    }

    @AfterEach
    void tearDown() {
        log.debug("┌──────────────────────────────────────┐");
        log.debug("│ ChatMessageControllerWebIT tearDown()│");
        log.debug("└──────────────────────────────────────┘");
    }

    @Test
    void GET_doSelectOne() throws Exception {
        log.debug("▶ GET /chat/{}", savedCode);

        mockMvc.perform(get("/chat/{chatCode}", savedCode))
               .andExpect(status().isOk())
               .andExpect(jsonPath("$.chatCode").value(savedCode))
               .andExpect(jsonPath("$.category").value(10))
               .andExpect(jsonPath("$.userId").value("user01"));
    }

    @Test
    void POST_doSave_rest() throws Exception {
        ChatMessageDTO body = new ChatMessageDTO(0, 10, "user02", "second!", null);

        mockMvc.perform(post("/chat/save")
                .contentType(JSON_UTF8)
                .content(om.writeValueAsString(body)))
               .andExpect(status().isOk())
               .andExpect(content().string("1")); // 저장 성공 카운트
    }

    @Test
    void GET_findRecentByCategory() throws Exception {
        mockMvc.perform(get("/chat/recent")
                .param("category", "10")
                .param("limit", "3"))
               .andExpect(status().isOk())
               .andExpect(jsonPath("$[0].category").value(10));
    }

    @Test
    void GET_findBeforeCode() throws Exception {
        // savedCode 이전 레코드 요청 (없어도 OK)
        mockMvc.perform(get("/chat/before")
                .param("category", "10")
                .param("lastChatCode", String.valueOf(savedCode))
                .param("limit", "2"))
               .andExpect(status().isOk());
    }

    @Test
    void DELETE_doDelete() throws Exception {
        mockMvc.perform(delete("/chat/{chatCode}", savedCode))
               .andExpect(status().isOk())
               .andExpect(content().string("1")); // 1건 삭제
    }

    @Test
    void GET_chatView_jsp() throws Exception {
        mockMvc.perform(get("/chat/chat.do"))
               .andExpect(status().isOk()); // ViewResolver가 있으면 200
    }
}