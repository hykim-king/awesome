package com.pcwk.ehr.mapper;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.pcwk.ehr.chatmessage.domain.ChatMessageDTO;
import com.pcwk.ehr.cmn.WorkDiv;

public interface ChatMessageMapper extends WorkDiv<ChatMessageDTO> {

    int deleteAll() throws SQLException;

    // 어드민 신고페이지: 본문 숨김 처리
    int hideMessage(@Param("chatCode") int chatCode);

    // 단건 조회(키로) - 파라미터 없는 오버로드 제거!
    ChatMessageDTO doSelectOne(@Param("chatCode") int chatCode);

    // 단건 삭제(키로) - @Param 추가
    int doDelete(@Param("chatCode") int chatCode);

    // 채팅 특화 조회: 카테고리별 최신 N건
    List<ChatMessageDTO> findRecentByCategory(
        @Param("category") int category,
        @Param("limit") int limit
    );

    // 무한스크롤: 특정 코드 이전 N건
    List<ChatMessageDTO> findBeforeCode(
        @Param("category") int category,
        @Param("lastChatCode") int lastChatCode,
        @Param("limit") int limit
    );

    int doDeleteByUser(
        @Param("chatCode") int chatCode,
        @Param("userId") String userId
    );
}
