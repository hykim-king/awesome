package com.pcwk.ehr.chatmessage.controller;

import java.security.Principal;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pcwk.ehr.chatmessage.domain.ChatMessageDTO;
import com.pcwk.ehr.chatmessage.service.ChatMessageService;

@Controller
@RequestMapping("/chat")
public class ChatMessageController {

	Logger log = LogManager.getLogger(getClass());

	@Autowired
	ChatMessageService service;

	@Autowired
	SimpMessagingTemplate messagingTemplate;


	// 최근 N개(초기 로딩)
	@ResponseBody
	@GetMapping(value = "/recent", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<ChatMessageDTO> recent(@RequestParam int category, @RequestParam(defaultValue = "30") int size) {
		return service.findRecentByCategory(category, size);
	}

	// 과거 더보기(무한 스크롤)
	@ResponseBody
	@GetMapping(value = "/before", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<ChatMessageDTO> before(@RequestParam int category, @RequestParam int chatCode,
			@RequestParam(defaultValue = "30") int size) {
		return service.findBeforeCode(category, chatCode, size);
	}

    // 실시간 수신: 클라 → 서버 (/app/send/{category})
    @MessageMapping("/send/{category}")
    public void onMessage(@DestinationVariable int category,
                          @Payload ChatMessageDTO payload,
                          Principal principal,
                          @Header("simpSessionId") String sessionId) throws Exception {
    	
        log.info("onMessage CALLED cat={} msg={}", category, payload.getMessage());      
    
        // 1) 로그인 안했어도 터지지 않도록
        String uid = (principal != null) ? principal.getName() : null;
        if(uid == null || uid.isEmpty()) {
        	
        	//비회원 보호 그냥 리턴함
        	return;
        }

        // 2) 서버에서 필수 필드 세팅
        payload.setCategory(category);
        payload.setUserId(uid);
        payload.setSendDt(new java.util.Date());

        // 3) DB 저장 (실패시 로그)
        service.doSave(payload);

        // 4) 구독자에게 브로드캐스트
        messagingTemplate.convertAndSend("/topic/chat/" + category, payload);
    }

}
