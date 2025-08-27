package com.pcwk.ehr.dict.domain;


public class DictionaryItemDTO {
    private String term;
    private String summary;
    private String link;

    public String getTerm() {
		return term;
	}

	public void setTerm(String term) {
		this.term = term;
	}

	public String getSummary() {
		return summary;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}

	public String getLink() {
		return link;
	}

	public void setLink(String link) {
		this.link = link;
	}

	public DictionaryItemDTO(String term, String summary, String link) {
        this.term = term;
        this.summary = summary;
        this.link = link;
    }

}