package com.pcwk.ehr.chatmessage.service;

import java.sql.SQLException;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.pcwk.ehr.chatmessage.domain.ChatMessageDTO;
import com.pcwk.ehr.mapper.ChatMessageMapper;

@Service
public class ChatMessageServiceImpl implements ChatMessageService {

	Logger log = LogManager.getLogger(getClass());

	@Autowired
	private ChatMessageMapper mapper;

	public ChatMessageServiceImpl(ChatMessageMapper mapper) {
		this.mapper = mapper;
	}

    @Transactional
    @Override
    public int doSave(ChatMessageDTO dto) {
        return mapper.doSave(dto);
    }

    @Override
    public ChatMessageDTO doSelectOne(int chatCode) {
        return mapper.doSelectOne(chatCode);
    }

    @Override
    public int doDelete(int chatCode) {
        return mapper.doDelete(chatCode);
    }

    @Override
    public int deleteAll() throws SQLException {
        return mapper.deleteAll();
    }

    @Override
    public List<ChatMessageDTO> findBeforeCode(int category, int lastChatCode, int limit) {
        return mapper.findBeforeCode(category, lastChatCode, limit);
    }

    @Override
    public List<ChatMessageDTO> findRecentByCategory(int category, int limit) {
        return mapper.findRecentByCategory(category, limit);
    }

}
