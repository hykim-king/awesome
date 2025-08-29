package com.pcwk.ehr.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

@EnableWebSocketMessageBroker
@Configuration
public class StompConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // 클라이언트가 "구독"할 주소 prefix (서버 → 클라)
        registry.enableSimpleBroker("/topic"); // 예: /topic/chat/정치
        // 클라이언트가 "보낼" 주소 prefix (클라 → 서버 @MessageMapping)
        registry.setApplicationDestinationPrefixes("/app"); // 예: /app/send/정치
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // SockJS 핸드셰이크 엔드포인트 (브라우저가 최초 연결하는 곳)
        registry.addEndpoint("/ws-chat")
        .setAllowedOriginPatterns("*")
        .withSockJS()
        .setInterceptors(new HttpSessionHandshakeInterceptor());
        // 프론트/백 분리 시 CORS 필요하면 아래 사용
        // registry.addEndpoint("/ws-chat").setAllowedOriginsPattern("*").withSockJS();
    }
}
