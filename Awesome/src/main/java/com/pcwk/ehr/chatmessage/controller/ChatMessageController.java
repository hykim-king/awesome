package com.pcwk.ehr.chatmessage.controller;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pcwk.ehr.chatmessage.domain.ChatMessageDTO;
import com.pcwk.ehr.chatmessage.service.ChatMessageService;

@Controller
@RequestMapping("/chat")
public class ChatMessageController {

	Logger log = LogManager.getLogger(getClass());

	@Autowired
	private ChatMessageService service;

    @Autowired
    SimpMessagingTemplate messagingTemplate;
    
    
	@GetMapping("/chat.do")
	public String chatView() {
		String viewName = "chat/chat";
		log.debug("┌───────────────────────────┐");
		log.debug("│ *chatView()*              │");
		log.debug("└───────────────────────────┘");

		log.debug("viewName: {}", viewName);
		return viewName;
	}

    /**
     * WebSocket 수신 핸들러: 실시간 채팅 메시지 저장 및 전송
     * @throws Exception 
     */
    @MessageMapping("/send")
    public void doSave(ChatMessageDTO dto) throws Exception {
        log.debug("┌─────────────────────────────┐");
        log.debug("│ doSave() - WebSocket        │");
        log.debug("└─────────────────────────────┘");
        log.debug("▶ dto : {}", dto);

        service.doSave(dto);

        messagingTemplate.convertAndSend("/topic/chat." + dto.getCategory(), dto);
    }

    /**
     * 단건 조회 (관리자 페이지용)
     */
    @GetMapping("/{chatCode}")
    @ResponseBody
    public ChatMessageDTO doSelectOne(@PathVariable int chatCode) {
        log.debug("┌─────────────────────────────┐");
        log.debug("│ doSelectOne() - REST        │");
        log.debug("└─────────────────────────────┘");
        log.debug("▶ chatCode : {}", chatCode);

        return service.doSelectOne(chatCode);
    }

    /**
     * 메시지 삭제 (사용자용)
     */
    @DeleteMapping("/{chatCode}")
    @ResponseBody
    public int doDelete(@PathVariable int chatCode) {
        log.debug("┌─────────────────────────────┐");
        log.debug("│ doDelete() - REST           │");
        log.debug("└─────────────────────────────┘");
        log.debug("▶ chatCode : {}", chatCode);

        return service.doDelete(chatCode);
	}
}
