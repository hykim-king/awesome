package com.pcwk.ehr.userLog.domain;

public class UserChartDTO {
	
    private String category;
    private int clickCount;
    private String dayOfWeek;  // 요일 (일~토)
    
    public UserChartDTO() {
    }

    
	public String getDayOfWeek() {return dayOfWeek;}
	public void setDayOfWeek(String dayOfWeek) {this.dayOfWeek = dayOfWeek;}


	public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public int getClickCount() { return clickCount; }
    public void setClickCount(int clickCount) { this.clickCount = clickCount; }


	@Override
	public String toString() {
		return "UserChartDTO [category=" + category + ", clickCount=" + clickCount + ", dayOfWeek=" + dayOfWeek + "]";
	}


}
