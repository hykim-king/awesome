package com.pcwk.ehr.report.domain;

import java.util.Date;

public class ReportDTO {
	private int reportCode; //신고 코드
	
	private int commentCode; //댓글 코드
	
	private String userId; //사용자Id
	
	private String coId; //신고 대상Id
	
	private int reason; //신고 사유
	
	private String status; //상태값(검토중/조치완료)
	
	private Date regDt; //신고일

	public ReportDTO() {}
	
	public ReportDTO(int reportCode, int commentCode, String userId, String coId, int reason, String status,
			Date regDt) {
		super();
		this.reportCode = reportCode;
		this.commentCode = commentCode;
		this.userId = userId;
		this.coId = coId;
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

	public int getCommentCode() {
		return commentCode;
	}

	public void setCommentCode(int commentCode) {
		this.commentCode = commentCode;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getCoId() {
		return coId;
	}

	public void setCoId(String coId) {
		this.coId = coId;
	}

	public int getReason() {
		return reason;
	}

	public void setReason(int reason) {
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

	@Override
	public String toString() {
		return "ReportDTO [reportCode=" + reportCode + ", commentCode=" + commentCode + ", userId=" + userId + ", coId="
				+ coId + ", reason=" + reason + ", status=" + status + ", regDt=" + regDt + ", toString()="
				+ super.toString() + "]";
	}
	
	
	
}
