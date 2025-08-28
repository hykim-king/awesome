package com.pcwk.ehr.chatbot.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pcwk.ehr.chatbot.service.OpenAiService;

@Controller
public class ChatbotController {

    @Autowired
    private OpenAiService openAiService;

    @RequestMapping(value = "/chatBot", method = RequestMethod.GET)
    public String mainPage() {
        return "chatBot/chatBot"; // chatBot.jsp를 반환
    }

    @RequestMapping(value = "/chatbot/ask", method = RequestMethod.POST)
    @ResponseBody
    public String askChatbot(@RequestParam("message") String message) {
        String response = openAiService.getChatResponse(message);
        return response;
    }
}
