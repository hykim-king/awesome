package com.pcwk.ehr.bookmark.service;

import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.pcwk.ehr.bookmark.domain.BookmarkDTO;
import com.pcwk.ehr.mapper.BookmarkMapper;

@Service
public class BookmarkServiceImpl implements BookmarkService {
	
	Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	BookmarkMapper mapper;

	@Override
	@Transactional(readOnly = true)
	public BookmarkDTO doSelectOne(BookmarkDTO param) {
		return mapper.doSelectOne(param);
	}

	@Override
	@Transactional(readOnly = true)
	public List<BookmarkDTO> doRetriveMy(BookmarkDTO param) {
		return mapper.doRetriveMy(param);
	}

	@Override
	public int doSave(BookmarkDTO param) {
		return mapper.doSave(param);
	}

	@Override
	public int doDeleteByArticleUser(BookmarkDTO param) {
		return mapper.doDeleteByArticleUser(param);
	}
	
	@Override
	@Transactional
	public int doDelete(BookmarkDTO param) {
		 return mapper.doDelete(param);
	}

	@Override
	@Transactional
	public int toggleBookmark(BookmarkDTO param) {
	    // 1) 먼저 삭제 시도 (있으면 OFF)
	    int deleted = mapper.doDeleteByArticleUser(param);
	    if (deleted > 0) return 0;

	    // 2) 없었으면 ON
	    try {
	        return mapper.doSave(param);
	    } catch (org.springframework.dao.DuplicateKeyException e) { // import 주의!
	        // 경합으로 누군가 먼저 넣은 경우
	        return 1; // 또는 mapper.doDeleteByArticleUser(param)로 OFF 수렴
	    }
	}

	@Override
	public int getCount(BookmarkDTO param) {
		return mapper.getCount(param);
	}

}
