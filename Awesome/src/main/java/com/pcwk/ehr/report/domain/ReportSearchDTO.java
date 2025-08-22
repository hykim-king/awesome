package com.pcwk.ehr.report.domain;

public class ReportSearchDTO {
    // 페이징
    private int pageNo;     // 요청 페이지 번호
    private int pageSize;   // 페이지당 건수
    private int startRow;   // 조회 시작 행
    private int endRow;     // 조회 끝 행

    // 검색 조건
    private String searchWord;  // 검색어
    
    private String status;     // 신고 상태 (VARCHAR2 이므로 String이 맞음)
    private Integer chatCode;  // 채팅 코드 (검색 조건일 경우 null 허용 → Integer)
    private String reason;     // 사유 (VARCHAR2라서 String)
    private String userId;     // 사용자 ID
    private String ctId;       // 대상 ID

    // 생성자
    public ReportSearchDTO() {
        this.pageNo = 1;
        this.pageSize = 10;
        recalc();
    }

    // startRow / endRow 계산
    public void recalc() {
        if (pageNo < 1) pageNo = 1;
        if (pageSize < 1) pageSize = 10;

        this.startRow = (pageNo - 1) * pageSize + 1;
        this.endRow = pageNo * pageSize;
    }

	public int getPageNo() {
		return pageNo;
	}

	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getStartRow() {
		return startRow;
	}

	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}

	public int getEndRow() {
		return endRow;
	}

	public void setEndRow(int endRow) {
		this.endRow = endRow;
	}

	public String getSearchWord() {
		return searchWord;
	}

	public void setSearchWord(String searchWord) {
		this.searchWord = searchWord;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Integer getChatCode() {
		return chatCode;
	}

	public void setChatCode(Integer chatCode) {
		this.chatCode = chatCode;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
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

	@Override
	public String toString() {
		return "ReportSearchDTO [pageNo=" + pageNo + ", pageSize=" + pageSize + ", startRow=" + startRow + ", endRow="
				+ endRow + ", searchWord=" + searchWord + ", status=" + status + ", chatCode=" + chatCode + ", reason="
				+ reason + ", userId=" + userId + ", ctId=" + ctId + ", toString()=" + super.toString() + "]";
	}


    
}
