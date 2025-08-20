package com.pcwk.ehr.chatmessage.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
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

	@Autowired(required = true)
	SimpMessagingTemplate messagingTemplate;

	// GET /ehr/chat/chat.do?category=10 이런 식으로 진입
	@GetMapping("/chat.do")
	public String chatView(@RequestParam(name = "category", required = false, defaultValue = "10") int category,
			@RequestParam(name = "guest", required = false, defaultValue = "0") int guest, HttpSession session,
			Model model) {
		log.debug("┌───────────────────────────┐");
		log.debug("│ *chatView()*              │");
		log.debug("└───────────────────────────┘");

		// 로그인 세션에서 userId 꺼내기 (프로젝트에 맞게 키 이름만 맞추기)
		String loginUserId = (String) session.getAttribute("loginUserId");

		// 테스트 아이디
		if (guest == 1 && (loginUserId == null || loginUserId.isEmpty())) {
			loginUserId = "guest-" + System.currentTimeMillis();
		}

		model.addAttribute("category", category);
		model.addAttribute("loginUserId", loginUserId);
		return "chat/chat";
	}

	@PostMapping(value = "/save", consumes = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public int doSave(@RequestBody ChatMessageDTO dto) throws Exception {
		return service.doSave(dto);
	}

	/**
	 * (WebSocket) 메시지 저장 + 브로드캐스트
	 * 
	 * @throws Exception
	 */
	@MessageMapping("/chat")
	public void doSaveWs(ChatMessageDTO dto) throws Exception {
		log.debug("┌─────────────────────────────┐");
		log.debug("│ doSaveWs()                  │");
		log.debug("└─────────────────────────────┘");
	    log.debug("doSaveWs recv: {}", dto);   // ★ 이 로그가 찍혀야 클라 SEND가 서버에 도달한 것
	    int r =  service.doSave(dto);
	    messagingTemplate.convertAndSend(
	    		"/topic/chat." + dto.getCategory(), dto);
	}


	/** (REST) 단건 조회 : doSelectOne */
	@GetMapping("/{chatCode}")
	@ResponseBody
	public ChatMessageDTO doSelectOne(@PathVariable int chatCode) {
		log.debug("┌─────────────────────────────┐");
		log.debug("│ doSelectOne() - REST        │");
		log.debug("└─────────────────────────────┘");
		log.debug("▶ chatCode : {}", chatCode);
		return service.doSelectOne(chatCode);
	}

	/** (REST) 메시지 삭제 : doDelete */
	@DeleteMapping("/{chatCode}")
	@ResponseBody
	public int doDelete(@PathVariable int chatCode) {
		log.debug("┌─────────────────────────────┐");
		log.debug("│ doDelete() - REST           │");
		log.debug("└─────────────────────────────┘");
		log.debug("▶ chatCode : {}", chatCode);
		return service.doDelete(chatCode);
	}

	/** (REST) 카테고리 최근 N건 : findRecentByCategory */
	@GetMapping("/recent")
	@ResponseBody
	public List<ChatMessageDTO> findRecentByCategory(@RequestParam(defaultValue = "10") int category,
			@RequestParam(defaultValue = "30") int limit) {
		log.debug("┌─────────────────────────────┐");
		log.debug("│ findRecentByCategory()      │");
		log.debug("└─────────────────────────────┘");
		log.debug("▶ category={}, limit={}", category, limit);
		return service.findRecentByCategory(category, limit);
	}

	/** (REST) 특정 코드 이전 N건 : findBeforeCode */
	@GetMapping("/before")
	@ResponseBody
	public List<ChatMessageDTO> findBeforeCode(@RequestParam int category, @RequestParam int lastChatCode,
			@RequestParam(defaultValue = "10") int limit) {
		log.debug("┌─────────────────────────────┐");
		log.debug("│ findBeforeCode()            │");
		log.debug("└─────────────────────────────┘");
		log.debug("▶ category={}, lastChatCode={}, limit={}", category, lastChatCode, limit);
		return service.findBeforeCode(category, lastChatCode, limit);
	}

}
