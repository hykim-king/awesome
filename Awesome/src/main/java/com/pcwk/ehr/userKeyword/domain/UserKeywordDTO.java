package com.pcwk.ehr.userKeyword.domain;

public class UserKeywordDTO {
	
	private String keyword;
	private int    count;
	
	public UserKeywordDTO() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @return the keyword
	 */
	public String getKeyword() {
		return keyword;
	}

	/**
	 * @param keyword the keyword to set
	 */
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	/**
	 * @return the count
	 */
	public int getCount() {
		return count;
	}

	/**
	 * @param count the count to set
	 */
	public void setCount(int count) {
		this.count = count;
	}

	@Override
	public String toString() {
		return "UserKeywordDTO [keyword=" + keyword + ", count=" + count + "]";
	}

}
