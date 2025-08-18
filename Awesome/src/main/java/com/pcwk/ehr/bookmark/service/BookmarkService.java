package com.pcwk.ehr.bookmark.service;

import java.util.List;

import com.pcwk.ehr.bookmark.domain.BookmarkDTO;

public interface BookmarkService {
	
	BookmarkDTO doSelectOne(BookmarkDTO param);
	
	List<BookmarkDTO> doRetriveMy(BookmarkDTO param);
	
	int doSave(BookmarkDTO param);
	
	int doDeleteByArticleUser(BookmarkDTO param);
	
	int doDelete(BookmarkDTO param);
	
	public int toggleBookmark(BookmarkDTO param);
	
	int getCount(BookmarkDTO param);

}
