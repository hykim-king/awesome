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
	 * 기사 별 북마크 조회
	 * @param param
	 * @return
	 */
	BookmarkDTO doSelectOne(BookmarkDTO param);
	
	
	/**
	 * 마이페이지 북마크한 기사 조회
	 * @param param
	 * @return BookmarkDTO
	 */
	List<BookmarkDTO> doRetriveMy(BookmarkDTO param);
	
	
	/**
	 * 전체 등록 건수 조회
	 * @return 1(True)/ 0(False)
	 */
	int getCount();
	
	/**
	 * 유저별 건수 조회
	 * @param param
	 * @return
	 */
	int getCountById(BookmarkDTO param);
	
	
	/**
	 * 북마크 단건 삭제(아이디, 기사코드로)
	 * @param param
	 * @return 1(True)/ 0(False)
	 */
	int doDeleteByArticleUser(BookmarkDTO param);
	
	/**
	 * 북마크 단건 삭제
	 * @param marked_code
	 */
	int doDelete(BookmarkDTO param);
	
	
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