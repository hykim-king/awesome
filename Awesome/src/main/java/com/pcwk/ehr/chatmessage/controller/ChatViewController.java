package com.pcwk.ehr.chatmessage.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/chat")
public class ChatViewController {

    // JSP: /WEB-INF/views/chat/chat.jsp 로 연결
    @GetMapping("/room")
    public String room() {
        return "chat/chat"; // tiles 안 쓰면 ViewResolver가 /WEB-INF/views/chat/chat.jsp 로 찾음
    }
}
