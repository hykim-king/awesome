package com.pcwk.ehr.chatmessage.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessageType;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pcwk.ehr.chatmessage.domain.ChatMessageDTO;
import com.pcwk.ehr.chatmessage.service.ChatMessageService;
import com.pcwk.ehr.member.domain.MemberDTO;

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
	                      SimpMessageHeaderAccessor accessor) throws Exception {

	    String uid = null;
	    
	    Map<String,Object> attrs = accessor.getSessionAttributes();
	    if (attrs != null) {
	        Object lu = attrs.get("loginUser");
	        if (lu instanceof MemberDTO) {
	            uid = ((MemberDTO) lu).getUserId();
	        } else if (attrs.get("USER_ID") != null) {
	            uid = String.valueOf(attrs.get("USER_ID"));
	        }
	    }
	    if (uid == null || uid.trim().isEmpty()) {
	        log.warn("비로그인 채팅 차단");
	        return;
	    }

	    payload.setCategory(category);
	    payload.setUserId(uid);
	    payload.setSendDt(new java.util.Date());
	    service.doSave(payload);
	    messagingTemplate.convertAndSend("/topic/chat/" + category, payload);
	    log.info("채팅 수신: category={}, userId={}, message={}", category, uid, payload.getMessage());

	}


}
