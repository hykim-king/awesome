package com.pcwk.ehr.mapper;

import com.pcwk.ehr.book_mark.domain.BookMarkDTO;

public interface BookMarkMapper {

	/**
	 * 북마크 등록
	 * @param BookMarkDTO param
	 * @return 1(성공)/0(실패)
	 */
	int doSave(BookMarkDTO param);
	
	/**
	 * 북마크 단건 삭제
	 * @param marked_code
	 */
	void delete(int param);
	
	/**
	 * 단건 북마크 갯수 카운트
	 * @param marked_code
	 * @return count 갯수
	 */
	int getCount(int param);
	
	/**
	 * 전체 삭제 
	 */
	void deleteAll();
	
	
	/**
	 * 다건 등록
	 * @return 등록건수
	 */
	int saveAll();
	

}