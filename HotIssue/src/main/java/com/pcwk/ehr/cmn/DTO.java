/**
 * Package Name : com.pcwk.ehr.cmn <br/>
 * 파일명: DTO.java <br/>
 */
package com.pcwk.ehr.cmn;

public class DTO {
	private int no;
	private int totalCnt;
	
	private int pageSize;
	private int pageNo;
	
	
	public DTO() {}
	
	

	/**
	 * @return the pageSize
	 */
	public int getPageSize() {
		return pageSize;
	}



	/**
	 * @param pageSize the pageSize to set
	 */
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}



	/**
	 * @return the pageNo
	 */
	public int getPageNo() {
		return pageNo;
	}



	/**
	 * @param pageNo the pageNo to set
	 */
	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}



	/**
	 * @return the totalCnt
	 */
	public int getTotalCnt() {
		return totalCnt;
	}

	/**
	 * @param totalCnt the totalCnt to set
	 */
	public void setTotalCnt(int totalCnt) {
		this.totalCnt = totalCnt;
	}

	/**
	 * @return the no
	 */
	public int getNo() {
		return no;
	}

	/**
	 * @param no the no to set
	 */
	public void setNo(int no) {
		this.no = no;
	}



	@Override
	public String toString() {
		return "DTO [no=" + no + ", totalCnt=" + totalCnt + ", pageSize=" + pageSize + ", pageNo=" + pageNo + "]";
	}


	
	

}
