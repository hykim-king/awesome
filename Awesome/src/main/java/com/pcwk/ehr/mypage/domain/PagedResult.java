package com.pcwk.ehr.mypage.domain;

import java.util.List;

public class PagedResult<T> {
	
    private List<T> list;
    private int totalCnt;
    
    public PagedResult() {
    }

    public PagedResult(List<T> list, int totalCnt) {
        this.list = list;
        this.totalCnt = totalCnt;
    }

    
    public List<T> getList() { return list; }
    public int getTotalCnt() { return totalCnt; }
}
