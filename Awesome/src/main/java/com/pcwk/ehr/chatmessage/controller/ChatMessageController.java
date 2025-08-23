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
						  @Header("simpSessionId") String sessionId,
	                      @Header("simpSessionAttributes") Map<String, Object> sessAttrs)throws Exception {

		  // 1) 로그인 사용자 식별
		  String uid = (principal != null && principal.getName() != null)
		      ? principal.getName()
		      : (sessAttrs != null ? (String) sessAttrs.get("USER_ID") : null);

		  if (uid == null || uid.trim().isEmpty()) {
		    // 2) 비회원이면 자기 세션으로만 에러 알림 보내고 종료
		    Map<String,Object> err = new HashMap<>();
		    err.put("code", "NEED_LOGIN");
		    err.put("message", "로그인이 필요한 기능입니다. 먼저 로그인해 주세요.");
		    // Security가 없으니 sessionId 기반 user로 전송
		    SimpMessageHeaderAccessor h = SimpMessageHeaderAccessor.create(SimpMessageType.MESSAGE);
		    h.setSessionId(sessionId);
		    h.setLeaveMutable(true);
		    messagingTemplate.convertAndSendToUser(sessionId, "/queue/errors", err, h.getMessageHeaders());
		    return;
		  }

		  // 3) 정상 처리
		  payload.setCategory(category);
		  payload.setUserId(uid);
		  payload.setSendDt(new java.util.Date());

		  service.doSave(payload); // DB 저장
		  messagingTemplate.convertAndSend("/topic/chat/" + category, payload); // 브로드캐스트
		}

}
