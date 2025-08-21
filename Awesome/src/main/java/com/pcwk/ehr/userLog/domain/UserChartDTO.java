package com.pcwk.ehr.userLog.domain;

public class UserChartDTO {
	
    private String category;
    private int clickCount;
    
    public UserChartDTO() {
    }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public int getClickCount() { return clickCount; }
    public void setClickCount(int clickCount) { this.clickCount = clickCount; }

	@Override
	public String toString() {
		return "UserChartDTO [category=" + category + ", clickCount=" + clickCount + "]";
	}
    
}
