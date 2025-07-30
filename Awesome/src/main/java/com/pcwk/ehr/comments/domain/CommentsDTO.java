package com.pcwk.ehr.comments.domain;

public class CommentsDTO {

	private int commentCode;
	private int articeCode;
	private String Id;
	private String conetents;
	private String regDt;

	public CommentsDTO() {}
	
	public int getCommentCode() {
		return commentCode;
	}

	public void setCommentCode(int commentCode) {
		this.commentCode = commentCode;
	}

	public int getArticeCode() {
		return articeCode;
	}

	public void setArticeCode(int articeCode) {
		this.articeCode = articeCode;
	}

	public String getId() {
		return Id;
	}

	public void setId(String id) {
		Id = id;
	}

	public String getConetents() {
		return conetents;
	}

	public void setConetents(String conetents) {
		this.conetents = conetents;
	}

	public String getRegDt() {
		return regDt;
	}

	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}

	@Override
	public String toString() {
		return "CommentsDTO [commentCode=" + commentCode + ", articeCode=" + articeCode + ", Id=" + Id + ", conetents="
				+ conetents + ", regDt=" + regDt + ", toString()=" + super.toString() + "]";
	}

}
