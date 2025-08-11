package com.pcwk.ehr.report.domain;

import java.util.Date;

public class ReportDTO {
	private int reportCode; //신고 코드
	
	private int chatCode; //채팅 메시지 고유 코드
	
	private String userId; //신고자Id
	
	private String ctId; //신고 대상Id
	
	private int reason; //신고 사유
	
	private int status; //상태값(검토중/조치완료)
	
	private Date regDt; //신고일

	public ReportDTO() {}
	
	

	public ReportDTO(int reportCode, int chatCode, String userId, String ctId, int reason, int status, Date regDt) {
		super();
		this.reportCode = reportCode;
		this.chatCode = chatCode;
		this.userId = userId;
		this.ctId = ctId;
		this.reason = reason;
		this.status = status;
		this.regDt = regDt;
	}



	public int getReportCode() {
		return reportCode;
	}

	public void setReportCode(int reportCode) {
		this.reportCode = reportCode;
	}

	public int getChatCode() {
		return chatCode;
	}

	public void setChatCode(int chatCode) {
		this.chatCode = chatCode;
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

	public int getReason() {
		return reason;
	}

	public void setReason(int reason) {
		this.reason = reason;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public Date getRegDt() {
		return regDt;
	}

	public void setRegDt(Date regDt) {
		this.regDt = regDt;
	}

	@Override
	public String toString() {
		return "ReportDTO [reportCode=" + reportCode + ", chatCode=" + chatCode + ", userId=" + userId + ", ctId="
				+ ctId + ", reason=" + reason + ", status=" + status + ", regDt=" + regDt + ", toString()="
				+ super.toString() + "]";
	}
	
	
}
