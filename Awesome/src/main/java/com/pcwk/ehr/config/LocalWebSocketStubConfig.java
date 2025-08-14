package com.pcwk.ehr.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.support.ExecutorSubscribableChannel;

@Configuration
@Profile("local") // 로컬에서만 활성화
public class LocalWebSocketStubConfig {

    @Bean
    public MessageChannel stubBrokerChannel() {
        return new ExecutorSubscribableChannel(); // 더미 채널
    }

    @Bean
    public SimpMessagingTemplate simpMessagingTemplate(MessageChannel stubBrokerChannel) {
        return new SimpMessagingTemplate(stubBrokerChannel); // 더미 템플릿
    }
}
