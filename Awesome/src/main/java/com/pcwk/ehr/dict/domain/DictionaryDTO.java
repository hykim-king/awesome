package com.pcwk.ehr.dict.domain;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class DictionaryDTO {
	  private int total;
	    private int start;
	    private int display;
	    private List<Item> items;

	    // 기본 생성자
	    public DictionaryDTO() {}

	    // getters & setters
	    public int getTotal() {
	        return total;
	    }
	    public void setTotal(int total) {
	        this.total = total;
	    }
	    public int getStart() {
	        return start;
	    }
	    public void setStart(int start) {
	        this.start = start;
	    }
	    public int getDisplay() {
	        return display;
	    }
	    public void setDisplay(int display) {
	        this.display = display;
	    }
	    public List<Item> getItems() {
	        return items;
	    }
	    public void setItems(List<Item> items) {
	        this.items = items;
	    }

	    @JsonIgnoreProperties(ignoreUnknown = true)
	    public static class Item {
	        private String title;
	        private String link;
	        private String description;
	        private String thumbnail;

	        public Item() {}

	        public String getTitle() {
	            return title;
	        }
	        public void setTitle(String title) {
	            this.title = title;
	        }
	        public String getLink() {
	            return link;
	        }
	        public void setLink(String link) {
	            this.link = link;
	        }
	        public String getDescription() {
	            return description;
	        }
	        public void setDescription(String description) {
	            this.description = description;
	        }
	        public String getThumbnail() {
	            return thumbnail;
	        }
	        public void setThumbnail(String thumbnail) {
	            this.thumbnail = thumbnail;
	        }
	    }
	}