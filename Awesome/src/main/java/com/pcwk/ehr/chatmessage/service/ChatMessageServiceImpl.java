package com.pcwk.ehr.chatmessage.service;

import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.pcwk.ehr.chatmessage.domain.ChatMessageDTO;
import com.pcwk.ehr.mapper.ChatMessageMapper;

public class ChatMessageServiceImpl implements ChatMessageService {

	Logger log = LogManager.getLogger(getClass());

	@Autowired
	private ChatMessageMapper mapper;

	@Override
	@Transactional
	public int sendMessage(ChatMessageDTO dto) {
		validateChatMessage(dto); // 유효성 검사
		setDefaultValues(dto); // 기본값 설정
		return mapper.doSave(dto);
	}

	// ===== 유효성 검사 =====
	private void validateChatMessage(ChatMessageDTO dto) {
		if (dto == null)
			throw new IllegalArgumentException("채팅 데이터가 없습니다.");

		if (dto.getCategory() <= 0)
			throw new IllegalArgumentException("카테고리 값이 잘못되었습니다.");

		if (!StringUtils.hasText(dto.getMessage()))
			throw new IllegalArgumentException("메시지 내용이 비어있습니다.");
	}

	// ===== 기본값 설정 =====
	private void setDefaultValues(ChatMessageDTO dto) {
		if (!StringUtils.hasText(dto.getUserId()))
			dto.setUserId("anonymous");

		// sendDt는 null이면 DB에서 SYSDATE로 자동 처리
	}

	@Override
	public ChatMessageDTO getByCode(int ChatCode) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int deleteByCode(int chatCode) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int deleteAll() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<ChatMessageDTO> findRecentByCategory(int category, int limit) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ChatMessageDTO> findBeforeCode(int category, int lastCode, int limit) {
		// TODO Auto-generated method stub
		return null;
	}

}
