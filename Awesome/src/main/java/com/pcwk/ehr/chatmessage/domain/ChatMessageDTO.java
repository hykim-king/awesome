package com.pcwk.ehr.chatmessage.domain;

import java.util.Date;

public class ChatMessageDTO {
	
	private int chatCode; //채팅 메시지 고유 코드
	
	private int category; //카테고리 번호
	
	private String userId; //사용자Id
	
	private String nickNm;
	
	private String message; //메시지 내용
	
	private Date sendDt; // 메시지 전송 시간
	
	public ChatMessageDTO() {
		
	}

	public ChatMessageDTO(int chatCode, int category, String userId, String message, Date sendDt) {
		super();
		this.chatCode = chatCode;
		this.category = category;
		this.userId = userId;
		this.message = message;
		this.sendDt = sendDt;
	}
	
	

	public String getNickNm() {
		return nickNm;
	}

	public void setNickNm(String nickNm) {
		this.nickNm = nickNm;
	}

	public int getChatCode() {
		return chatCode;
	}

	public void setChatCode(int chatCode) {
		this.chatCode = chatCode;
	}

	public int getCategory() {
		return category;
	}

	public void setCategory(int category) {
		this.category = category;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public Date getSendDt() {
		return sendDt;
	}

	public void setSendDt(Date sendDt) {
		this.sendDt = sendDt;
	}


	@Override
	public String toString() {
		return "ChatMessageDTO [chatCode=" + chatCode + ", category=" + category + ", userId=" + userId + ", nickNm="
				+ nickNm + ", message=" + message + ", sendDt=" + sendDt + ", toString()=" + super.toString() + "]";
	}

	public void setReason(int i) {
		// TODO Auto-generated method stub
		
	}

	public void setStatus(int i) {
		// TODO Auto-generated method stub
		
	}
	
	
	
	
}
