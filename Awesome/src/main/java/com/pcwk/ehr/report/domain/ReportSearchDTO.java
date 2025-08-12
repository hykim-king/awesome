package com.pcwk.ehr.report.domain;

import com.pcwk.ehr.cmn.DTO;

public class ReportSearchDTO extends DTO {

	// 페이징 계산 필드
	private Integer startRow;
	private Integer endRow;

	// 검색 조건
	private String searchWord;
	private Integer status; // 신고 상태(검토중/조치완료)
	private Integer chatCode; // 채팅 메시지 코드
	private Integer reason; // 신고 사유
	private String userId; // 신고자 ID
	private String ctId; // 신고 대상 ID

	public ReportSearchDTO() {
		recalc();
	}

	// startRow / endRow 계산
	public void recalc() {
		if (getPageNo() < 1)
			setPageNo(1);
		if (getPageSize() < 1)
			setPageSize(10);

		this.startRow = (getPageNo() - 1) * getPageSize() + 1;
		this.endRow = getPageNo() * getPageSize();
	}

	// getter / setter
	public Integer getStartRow() {
		return startRow;
	}

	public void setStartRow(Integer startRow) {
		this.startRow = startRow;
	}

	public Integer getEndRow() {
		return endRow;
	}

	public void setEndRow(Integer endRow) {
		this.endRow = endRow;
	}

	public String getSearchWord() {
		return searchWord;
	}

	public void setSearchWord(String searchWord) {
		this.searchWord = searchWord;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Integer getChatCode() {
		return chatCode;
	}

	public void setChatCode(Integer chatCode) {
		this.chatCode = chatCode;
	}

	public Integer getReason() {
		return reason;
	}

	public void setReason(Integer reason) {
		this.reason = reason;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getCtId() {
		return ctId;
	}

	public void setCtId(String ctId) {
		this.ctId = ctId;
	}
}