package com.pcwk.ehr.report.domain;

import java.util.Date;

public class ReportDTO {

	
	
	
	private String reasonLabel; // 화면 표시용 라벨(한글)

	
	private String reasonDetail; // 신고 기타사항 상세 텍스트

	public String getReasonDetail() { return reasonDetail; }
	public void setReasonDetail(String reasonDetail) { this.reasonDetail = reasonDetail; }
	
	
    // 기본 정보
    private int reportCode;   // 신고 코드 (PK)
    private int chatCode;     // 신고 대상 채팅 코드
    private String userId;    // 신고자 ID
    private String ctId;      // 신고 대상 ID
    private String reason;    // 신고 사유 (SPAM, OBSCENITY 등)
    private String status;    // 처리 상태 (검토중/조치완료)
    private Date regDt;       // 신고일
    private Date modDt;       // 수정일

    // === 신고 당시 채팅 스냅샷(신규) ===
    private String targetUserId;   // 신고 대상 채팅의 작성자
    private String targetMessage;  // 신고 대상 채팅의 메시지
    private Date   targetSendDt;   // 신고 대상 채팅의 전송시각

    public ReportDTO() {}

    public ReportDTO(int reportCode, int chatCode, String userId, String ctId,
                     String reason, String status, Date regDt, Date modDt,
                     String targetUserId, String targetMessage, Date targetSendDt,
                     String reasonDetail) {
    	
        this.reportCode = reportCode;
        this.chatCode = chatCode;
        this.userId = userId;
        this.ctId = ctId;
        this.reason = reason;
        this.status = status;
        this.regDt = regDt;
        this.modDt = modDt;
        this.targetUserId = targetUserId;
        this.targetMessage = targetMessage;
        this.targetSendDt = targetSendDt;
        this.reasonDetail  = reasonDetail;
        

    }
    
    public ReportDTO(int reportCode, int chatCode, String userId, String ctId,
            String reason, String status, Date regDt, Date modDt,
            String targetUserId, String targetMessage, Date targetSendDt) {
		this(reportCode, chatCode, userId, ctId, reason, status, regDt, modDt,
		    targetUserId, targetMessage, targetSendDt, null);
		}
    
    
    

    public String getReasonLabel() { return reasonLabel; }
    public void setReasonLabel(String reasonLabel) { this.reasonLabel = reasonLabel; }
    
    public int getReportCode() { return reportCode; }
    public void setReportCode(int reportCode) { this.reportCode = reportCode; }

    public int getChatCode() { return chatCode; }
    public void setChatCode(int chatCode) { this.chatCode = chatCode; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getCtId() { return ctId; }
    public void setCtId(String ctId) { this.ctId = ctId; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getRegDt() { return regDt; }
    public void setRegDt(Date regDt) { this.regDt = regDt; }

    public Date getModDt() { return modDt; }
    public void setModDt(Date modDt) { this.modDt = modDt; }

    public String getTargetUserId() { return targetUserId; }
    public void setTargetUserId(String targetUserId) { this.targetUserId = targetUserId; }

    public String getTargetMessage() { return targetMessage; }
    public void setTargetMessage(String targetMessage) { this.targetMessage = targetMessage; }

    public Date getTargetSendDt() { return targetSendDt; }
    public void setTargetSendDt(Date targetSendDt) { this.targetSendDt = targetSendDt; }
    
  

    @Override
    public String toString() {
        return "ReportDTO{" +
                "reportCode=" + reportCode +
                ", chatCode=" + chatCode +
                ", userId='" + userId + '\'' +
                ", ctId='" + ctId + '\'' +
                ", reason='" + reason + '\'' +
                ", status='" + status + '\'' +
                ", regDt=" + regDt +
                ", modDt=" + modDt +
                ", targetUserId='" + targetUserId + '\'' +
                ", targetMessage='" + targetMessage + '\'' +
                ", targetSendDt=" + targetSendDt +
                ",reasonDetail='" + reasonDetail + "'}";
               
    }
}
