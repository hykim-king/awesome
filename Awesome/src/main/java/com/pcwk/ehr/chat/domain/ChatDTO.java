package com.pcwk.ehr.chat.domain;

import java.time.LocalDateTime;

public class ChatDTO {

	private String roomId;
	private String sender;
	private String message;
	private LocalDateTime timestamp;

	/**
	 * 
	 */
	public ChatDTO() {
		this.timestamp = LocalDateTime.now();
	}

	/**
	 * @return the roomId
	 */
	public String getRoomId() {
		return roomId;
	}

	/**
	 * @param roomId the roomId to set
	 */
	public void setRoomId(String roomId) {
		this.roomId = roomId;
	}

	/**
	 * @return the sender
	 */
	public String getSender() {
		return sender;
	}

	/**
	 * @param sender the sender to set
	 */
	public void setSender(String sender) {
		this.sender = sender;
	}

	/**
	 * @return the message
	 */
	public String getMessage() {
		return message;
	}

	/**
	 * @param message the message to set
	 */
	public void setMessage(String message) {
		this.message = message;
	}

	/**
	 * @return the timestamp
	 */
	public LocalDateTime getTimestamp() {
		return timestamp;
	}

	/**
	 * @param timestamp the timestamp to set
	 */
	public void setTimestamp(LocalDateTime timestamp) {
		this.timestamp = timestamp;
	}

	@Override
	public String toString() {
		return "ChatDTO [roomId=" + roomId + ", sender=" + sender + ", message=" + message + ", timestamp=" + timestamp
				+ "]";
	}

}
