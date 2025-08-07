package com.pcwk.ehr.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.pcwk.ehr.bookmark.domain.BookmarkDTO;

@Mapper
public interface BookmarkMapper {

	/**
	 * 북마크 등록
	 * @param BookmarkDTO param
	 * @return 1(성공)/0(실패)
	 */
	int doSave(BookmarkDTO param);
	
	
	/**
	 * 북마크한 기사 조회
	 * @param param
	 * @return BookmarkDTO
	 */
	List<BookmarkDTO> doRetrive(BookmarkDTO param);
	
	
	/**
	 * 전체 등록 건수 조회
	 * @return int
	 */
	int getCount();
	
	/**
	 * 북마크 단건 삭제
	 * @param marked_code
	 */
	void doDelete(int param);
	
	
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