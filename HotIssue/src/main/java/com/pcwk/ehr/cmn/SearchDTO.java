package com.pcwk.ehr.cmn;

public class SearchDTO extends DTO {
	
	private String searchDiv;
	
	private String searchWord;
	
	public SearchDTO() {}

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
		return "SearchDTO [searchDiv=" + searchDiv + ", searchWord=" + searchWord + "]";
	}
	
	

}
