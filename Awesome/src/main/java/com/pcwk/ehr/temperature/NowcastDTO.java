package com.pcwk.ehr.temperature;

public class NowcastDTO {

	private int nowcastNo;
	private String baseDate;
	private String baseTime;
	private int nx;
	private int ny;
	private String category;
	private int obsrValue;

	public NowcastDTO() {
	}

	
	public int getNowcastNo() {
		return nowcastNo;
	}

	public void setNowcastNo(int nowcastNo) {
		this.nowcastNo = nowcastNo;
	}

	public String getBaseDate() {
		return baseDate;
	}

	public void setBaseDate(String baseDate) {
		this.baseDate = baseDate;
	}

	public String getBaseTime() {
		return baseTime;
	}

	public void setBaseTime(String baseTime) {
		this.baseTime = baseTime;
	}

	public int getNx() {
		return nx;
	}

	public void setNx(int nx) {
		this.nx = nx;
	}

	public int getNy() {
		return ny;
	}

	public void setNy(int ny) {
		this.ny = ny;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public int getObsrValue() {
		return obsrValue;
	}

	public void setObsrValue(int obsrValue) {
		this.obsrValue = obsrValue;
	}

	public NowcastDTO(int nowcastNo, String baseDate, String baseTime, int nx, int ny, String category, int obsrValue) {
		super();
		this.nowcastNo = nowcastNo;
		this.baseDate = baseDate;
		this.baseTime = baseTime;
		this.nx = nx;
		this.ny = ny;
		this.category = category;
		this.obsrValue = obsrValue;
	}

	@Override
	public String toString() {
		return "NowcastDTO [nowcastNo=" + nowcastNo + ", baseDate=" + baseDate + ", baseTime=" + baseTime + ", nx=" + nx
				+ ", ny=" + ny + ", category=" + category + ", obsrValue=" + obsrValue + "]";
	}
	
	
	
}
