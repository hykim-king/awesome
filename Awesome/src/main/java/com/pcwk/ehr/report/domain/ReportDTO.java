package com.pcwk.ehr.report.domain;

import java.util.Date;

public class ReportDTO {
	private int reportCode; //신고 코드	
	private int chatCode; //채팅 메시지 고유 코드	
	private String userId; //신고자Id	
	private String ctId; //신고 대상Id
	private String reason; //신고 사유	
	private String status; //상태값(검토중/조치완료)	
	private Date regDt; //신고일
	private Date modDt; //신고 수정일

	public ReportDTO() {}

	
	
	public ReportDTO(int reportCode, int chatCode, String userId, String ctId, String reason, String status, Date regDt,
			Date modDt) {
		super();
		this.reportCode = reportCode;
		this.chatCode = chatCode;
		this.userId = userId;
		this.ctId = ctId;
		this.reason = reason;
		this.status = status;
		this.regDt = regDt;
		this.modDt = modDt;
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

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getRegDt() {
		return regDt;
	}

	public void setRegDt(Date regDt) {
		this.regDt = regDt;
	}

	public Date getModDt() {
		return modDt;
	}

	public void setModDt(Date modDt) {
		this.modDt = modDt;
	}

	@Override
	public String toString() {
		return "ReportDTO [reportCode=" + reportCode + ", chatCode=" + chatCode + ", userId=" + userId + ", ctId="
				+ ctId + ", reason=" + reason + ", status=" + status + ", regDt=" + regDt + ", modDt=" + modDt
				+ ", toString()=" + super.toString() + "]";
	}
	
	
	
}
