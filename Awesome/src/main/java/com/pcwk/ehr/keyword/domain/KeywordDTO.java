package com.pcwk.ehr.keyword.domain;

import java.util.Date;

public class KeywordDTO {
/*
 *  DK_CODE	데일리 키워드 고유코드		NUMBER(15)
 *  DK_DT	키워드 소속일(날짜)		DATE
 *  UPDATE_PERIOD	시간대(10AM / 6PM)		VARCHAR2(5)
 *  CATEGORY	기사 카테고리		NUMBER(3)
 *  KEYWORD	키워드		VARCHAR2(150)
 */
	 private Long   dkCode;        // DK_CODE
	    private Date   dkDt;          // DK_DT
	    private String updatePeriod;  // UPDATE_PERIOD ("10AM" / "6PM")
	    private int category;      // CATEGORY
	    private String keyword;       // KEYWORD
	    
	    // 기본 생성자
	    public KeywordDTO() {}

	    // 전체 필드 생성자
	   	public KeywordDTO(Long dkCode, Date dkDt, String updatePeriod, int category, String keyword) {
			super();
			this.dkCode = dkCode;
			this.dkDt = dkDt;
			this.updatePeriod = updatePeriod;
			this.category = category;
			this.keyword = keyword;
		}
		public Long getDkCode() {
			return dkCode;
		}
		public void setDkCode(Long dkCode) {
			this.dkCode = dkCode;
		}
		public Date getDkDt() {
			return dkDt;
		}
		public void setDkDt(Date dkDt) {
			this.dkDt = dkDt;
		}
		public String getUpdatePeriod() {
			return updatePeriod;
		}
		public void setUpdatePeriod(String updatePeriod) {
			this.updatePeriod = updatePeriod;
		}
		public int getCategory() {
			return category;
		}
		public void setCategory(int category) {
			this.category = category;
		}
		public String getKeyword() {
			return keyword;
		}
		public void setKeyword(String keyword) {
			this.keyword = keyword;
		}
		
		@Override
		public String toString() {
			return "KeywordDTO [dkCode=" + dkCode + ", dkDt=" + dkDt + ", updatePeriod=" + updatePeriod + ", category="
					+ category + ", keyword=" + keyword + "]";
		}
	  
	
}
