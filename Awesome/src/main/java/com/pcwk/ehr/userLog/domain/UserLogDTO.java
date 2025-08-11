package com.pcwk.ehr.userLog.domain;

import java.util.Date;

public class UserLogDTO {
    /*
     * LOG_CODE      로그 고유 코드      NUMBER(15)
     * USER_ID       회원아이디         VARCHAR2(30)
     * ARTICLE_CODE  기사 고유 코드     NUMBER(15)
     * CLICKED_AT    기사 클릭한 시간   DATE
     */
    private Long logCode;       // LOG_CODE
    private String userId;      // USER_ID
    private Long articleCode;   // ARTICLE_CODE
    private Date clickedAt;     // CLICKED_AT

    // 기본 생성자
    public UserLogDTO() {}

    // 전체 필드 생성자
    public UserLogDTO(Long logCode, String userId, Long articleCode, Date clickedAt) {
        this.logCode = logCode;
        this.userId = userId;
        this.articleCode = articleCode;
        this.clickedAt = clickedAt;
    }

    // Getter / Setter
    public Long getLogCode() { return logCode; }
    public void setLogCode(Long logCode) { this.logCode = logCode; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public Long getArticleCode() { return articleCode; }
    public void setArticleCode(Long articleCode) { this.articleCode = articleCode; }

    public Date getClickedAt() { return clickedAt; }
    public void setClickedAt(Date clickedAt) { this.clickedAt = clickedAt; }

    @Override
    public String toString() {
        return "UserLogDTO{" +
                "logCode=" + logCode +
                ", userId='" + userId + '\'' +
                ", articleCode=" + articleCode +
                ", clickedAt=" + clickedAt +
                '}';
    }
}