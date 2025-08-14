package com.pcwk.ehr.mapper;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.pcwk.ehr.chatmessage.domain.ChatMessageDTO;
import com.pcwk.ehr.cmn.WorkDiv;

public interface ChatMessageMapper extends WorkDiv<ChatMessageDTO> {
	
	int deleteAll() throws SQLException;


    // 채팅 특화 조회: 카테고리별 최신 N건
    List<ChatMessageDTO> findRecentByCategory(
    		@Param("category") int category,
            @Param("limit") int limit);

    // 무한스크롤: 특정 코드 이전 N건
    List<ChatMessageDTO> findBeforeCode(
    	    @Param("category") int category,
    	    @Param("lastChatCode") int lastChatCode,
    	    @Param("limit") int limit
    	);


	ChatMessageDTO doSelectOne();


	int doDelete(int chatCode);


	ChatMessageDTO doSelectOne(int chatCode);
	
	int doDeleteByUser(@Param("chatCode") int chatCode, @Param("userId") String userId);

}
