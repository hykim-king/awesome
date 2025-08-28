package com.pcwk.ehr.bookmark.domain;

import java.util.Date;

public class BookmarkDTO {

	private int bmCode;      //북마크 코드
	private int articleCode; //기사 코드
	private String userId;   //사용자 Id
	private String title;	 //기사 제목
	private String summary;  //기사 요약
	private String press;	 //언론사
	private String url;      //url
	private Date regDt;	 //북마크 날짜
	private int totalCnt;	 //총 개수
	
    private int pageNo;     //페이지 번호
    private int pageSize;	//페이지 사이즈
	
	public BookmarkDTO() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param bmCode
	 * @param articleCode
	 * @param userId
	 * @param regDt
	 */
	public BookmarkDTO(int articleCode, String userId) {
		super();
		this.articleCode = articleCode;
		this.userId = userId;
	}
	
    	

	/**
	 * @return the url
	 */
	public String getUrl() {
		return url;
	}

	/**
	 * @param url the url to set
	 */
	public void setUrl(String url) {
		this.url = url;
	}

	/**
	 * @return the pageNo
	 */
	public int getPageNo() {
		return pageNo;
	}

	/**
	 * @param pageNo the pageNo to set
	 */
	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}

	/**
	 * @return the pageSize
	 */
	public int getPageSize() {
		return pageSize;
	}

	/**
	 * @param pageSize the pageSize to set
	 */
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	/**
	 * @return the totalCnt
	 */
	public int getTotalCnt() {
		return totalCnt;
	}

	/**
	 * @param totalCnt the totalCnt to set
	 */
	public void setTotalCnt(int totalCnt) {
		this.totalCnt = totalCnt;
	}

	/**
	 * @return the title
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * @param title the title to set
	 */
	public void setTitle(String title) {
		this.title = title;
	}

	/**
	 * @return the summary
	 */
	public String getSummary() {
		return summary;
	}

	/**
	 * @param summary the summary to set
	 */
	public void setSummary(String summary) {
		this.summary = summary;
	}

	/**
	 * @return the press
	 */
	public String getPress() {
		return press;
	}

	/**
	 * @param press the press to set
	 */
	public void setPress(String press) {
		this.press = press;
	}

	/**
	 * @return the bmCode
	 */
	public int getBmCode() {
		return bmCode;
	}

	/**
	 * @param bmCode the bmCode to set
	 */
	public void setBmCode(int bmCode) {
		this.bmCode = bmCode;
	}

	/**
	 * @return the articleCode
	 */
	public int getArticleCode() {
		return articleCode;
	}

	/**
	 * @param articleCode the articleCode to set
	 */
	public void setArticleCode(int articleCode) {
		this.articleCode = articleCode;
	}

	/**
	 * @return the userId
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * @param userId the userId to set
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * @return the regDt
	 */
	public Date getRegDt() {
		return regDt;
	}

	/**
	 * @param regDt the regDt to set
	 */
	public void setRegDt(Date regDt) {
		this.regDt = regDt;
	}

	@Override
	public String toString() {
		return "BookmarkDTO [bmCode=" + bmCode + ", articleCode=" + articleCode + ", userId=" + userId + ", title="
				+ title + ", summary=" + summary + ", press=" + press + ", url=" + url + ", regDt=" + regDt
				+ ", totalCnt=" + totalCnt + ", pageNo=" + pageNo + ", pageSize=" + pageSize + "]";
	}




}
