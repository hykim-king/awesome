package com.pcwk.ehr.chatmessage.service;

import java.util.List;

import com.pcwk.ehr.chatmessage.domain.ChatMessageDTO;

public interface ChatMessageService {
	
    /**
     * 채팅 메시지 전송 (DB에 저장)
     * @param dto 전송할 채팅 메시지 정보
     * @return 저장된 행 수(성공: 1, 실패: 0)
     */
	int sendMessage(ChatMessageDTO dto);
	
    /**
     * 채팅 코드(chatCode)로 단일 메시지 조회
     * 특정 메시지를 불러옴
     * @return 해당 코드의 채팅 메시지 DTO (없으면 null)
     */
	ChatMessageDTO getByCode(int ChatCode);
	
    /**
     * 관리자나 삭제 기능에서 사용
     */
	int deleteByCode(int chatCode);
	
    /**
     * 모든 채팅 메시지 삭제
     * 테스트 초기화나 운영할때 데이터 전체 삭제용
     */
	int deleteAll();
	
    /**
     * 카테고리별 최신 채팅 목록 불러오기(혹시 몰라서 추가)
     */
	List<ChatMessageDTO> findRecentByCategory(int category, int limit);
	
    /**
     * 무한 스크롤/더보기에서 이전 채팅 불러오기
     */
    List<ChatMessageDTO> findBeforeCode(int category, int lastCode, int limit);

	
}
