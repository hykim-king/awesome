package com.pcwk.ehr.cmn;

public class SearchDTO extends DTO {

	private String searchDiv; //검색 구분
	private String searchWord;//검색어
	private String div;       //구분(게시)
	
	
	public SearchDTO() {}

	
	
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



	@Override
	public String toString() {
		return "SearchDTO [searchDiv=" + searchDiv + ", searchWord=" + searchWord + ", div=" + div + ", toString()="
				+ super.toString() + "]";
	}


	
	
}
