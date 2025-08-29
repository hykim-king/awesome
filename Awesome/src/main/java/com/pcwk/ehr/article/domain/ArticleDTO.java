package com.pcwk.ehr.article.domain;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

public class ArticleDTO {

	// 1. 기사 코드
	private Long articleCode;

	// 2. 카테고리 번호
	private int category;

	// 3. 언론사
	private String press;

	// 4. 기사 제목
	private String title;

	// 5. 요약 본문
	private String summary;

	// 6. 기사 URL
	private String url;

	// 7. 게시일시 (기사 발행일)
	private Date publicDt;

	// 8. 조회수
	private int views;

	// 9. 등록일
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	private Date regDt;

	// 10. 수정일
	private Date modDt;
	
	// 11. 어드민기사관리 카테고리
	private String categoryLabel;
	

	/**
	 * 
	 */
	public ArticleDTO() {

	}

	/**
	 * @param articleCode
	 * @param category
	 * @param press
	 * @param title
	 * @param summary
	 * @param url
	 * @param publicDt
	 * @param views
	 * @param regDt
	 * @param modDt
	 */
	public ArticleDTO(Long articleCode, int category, String press, String title, String summary, String url,
			Date publicDt, int views, Date regDt, Date modDt) {
		super();
		this.articleCode = articleCode;
		this.category = category;
		this.press = press;
		this.title = title;
		this.summary = summary;
		this.url = url;
		this.publicDt = publicDt;
		this.views = views;
		this.regDt = regDt;
		this.modDt = modDt;
	}

	/**
	 * @return the articleCode
	 */
	public Long getArticleCode() {
		return articleCode;
	}

	/**
	 * @param articleCode the articleCode to set
	 */
	public void setArticleCode(Long articleCode) {
		this.articleCode = articleCode;
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
	 * @return the publicDt
	 */
	public Date getPublicDt() {
		return publicDt;
	}

	/**
	 * @param publicDt the publicDt to set
	 */
	public void setPublicDt(Date publicDt) {
		this.publicDt = publicDt;
	}

	/**
	 * @return the views
	 */
	public int getViews() {
		return views;
	}

	/**
	 * @param views the views to set
	 */
	public void setViews(int views) {
		this.views = views;
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

	/**
	 * @return the modDt
	 */
	public Date getModDt() {
		return modDt;
	}

	/**
	 * @param modDt the modDt to set
	 */
	public void setModDt(Date modDt) {
		this.modDt = modDt;
	}

	/* 어드민 기사관리 카테고리 */
	public String getCategoryLabel() { 
		return categoryLabel; 
		}
	
	public void setCategoryLabel(String categoryLabel) { 
		this.categoryLabel = categoryLabel; }
	
	@Override
	public String toString() {
		return "ArticleDTO [articleCode=" + articleCode + ", category=" + category + ", press=" + press + ", title="
				+ title + ", summary=" + summary + ", url=" + url + ", publicDt=" + publicDt + ", views=" + views
				+ ", regDt=" + regDt + ", modDt=" + modDt + "]";
	}

}
