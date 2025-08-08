package com.pcwk.ehr.article.domain;

import com.pcwk.ehr.cmn.DTO;

public class ArticleSearchDTO extends DTO {

	private String searchDiv; // 검색 구분
	private String searchWord;// 검색어
	private String div; // 구분(게시)
	private int category;

	/**
	 * 
	 */
	public ArticleSearchDTO() {
	}

	/**
	 * @return the searchDiv
	 */
	public String getSearchDiv() {
		return searchDiv;
	}

	/**
	 * @param searchDiv the searchDiv to set
	 */
	public void setSearchDiv(String searchDiv) {
		this.searchDiv = searchDiv;
	}

	/**
	 * @return the searchWord
	 */
	public String getSearchWord() {
		return searchWord;
	}

	/**
	 * @param searchWord the searchWord to set
	 */
	public void setSearchWord(String searchWord) {
		this.searchWord = searchWord;
	}

	/**
	 * @return the div
	 */
	public String getDiv() {
		return div;
	}

	/**
	 * @param div the div to set
	 */
	public void setDiv(String div) {
		this.div = div;
	}

	/**
	 * @return the category
	 */
	public int getCategory() {
		return category;
	}

	/**
	 * @param category the category to set
	 */
	public void setCategory(int category) {
		this.category = category;
	}

	@Override
	public String toString() {
		return "ArticleSearchDTO [searchDiv=" + searchDiv + ", searchWord=" + searchWord + ", div=" + div
				+ ", category=" + category + super.toString() + "]";
	}

}
