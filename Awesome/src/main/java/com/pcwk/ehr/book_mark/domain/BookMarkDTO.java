package com.pcwk.ehr.book_mark.domain;

public class BookMarkDTO {

	private int markedCode;
	private String userId;
	private int articleCode;
	private String regDt;
	
	public BookMarkDTO() {
		// TODO Auto-generated constructor stub
	}



	/**
	 * @param markedCode
	 * @param userId
	 * @param articleCode
	 * @param regDt
	 */
	public BookMarkDTO(int markedCode, String userId, int articleCode, String regDt) {
		super();
		this.markedCode = markedCode;
		this.userId = userId;
		this.articleCode = articleCode;
		this.regDt = regDt;
	}



	/**
	 * @return the regDt
	 */
	public String getRegDt() {
		return regDt;
	}



	/**
	 * @param regDt the regDt to set
	 */
	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}



	/**
	 * @return the markedCode
	 */
	public int getMarkedCode() {
		return markedCode;
	}

	/**
	 * @param markedCode the markedCode to set
	 */
	public void setMarkedCode(int markedCode) {
		this.markedCode = markedCode;
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



	@Override
	public String toString() {
		return "BookMarkDTO [markedCode=" + markedCode + ", userId=" + userId + ", articleCode=" + articleCode
				+ ", regDt=" + regDt + "]";
	}	
	
}
