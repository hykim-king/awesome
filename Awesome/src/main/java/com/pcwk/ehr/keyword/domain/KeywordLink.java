package com.pcwk.ehr.keyword.domain;

	public class KeywordLink {
	    private String name;
	    private String link;

	    public KeywordLink(String name, String link) {
	        this.name = name;
	        this.link = link;
	    }

	    public String getName() { return name; }
	    public String getLink() { return link; }
	}