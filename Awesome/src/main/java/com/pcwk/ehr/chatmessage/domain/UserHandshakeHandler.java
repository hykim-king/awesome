package com.pcwk.ehr.chatmessage.domain;

import java.security.Principal;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.support.DefaultHandshakeHandler;

public class UserHandshakeHandler extends DefaultHandshakeHandler {
    @Override
    protected Principal determineUser(ServerHttpRequest request,
                                      WebSocketHandler wsHandler,
                                      Map<String, Object> attributes) {

        String userId = null;

        if (request instanceof ServletServerHttpRequest) {
            HttpSession session = ((ServletServerHttpRequest) request)
                    .getServletRequest().getSession(false);
            if (session != null) {
                Object v = session.getAttribute("USER_ID"); // ← 로그인 시 세션에 넣는 키와 동일해야 함!
                if (v != null) userId = String.valueOf(v);
            }
        }

        // 회원만 채팅 가능하게 하려면: userId가 없으면 null을 리턴(= 연결 거부)
        if (userId == null || userId.trim().isEmpty()) {
            return null; // -> SockJS 연결이 실패하고 onerror 콜백으로 감
        }

        return new StompPrincipal(userId);
    }
}
