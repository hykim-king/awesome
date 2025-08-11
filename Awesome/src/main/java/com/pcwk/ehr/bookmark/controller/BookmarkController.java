package com.pcwk.ehr.bookmark.controller;

import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;

import com.pcwk.ehr.bookmark.domain.BookmarkDTO;

@Controller
@RequestMapping("/bookmark")
public class BookmarkController {

	Logger log = LogManager.getLogger(getClass());
	
	public BookmarkController() {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ BookmarkController()                  │");
		log.debug("└───────────────────────────────────────┘");	
		
	}
	
	//조회, 내 북마크 목록, 토글 정도
	
	@GetMapping(value = "/doRetriveMy.do")
	public String doRetriveMy(BookmarkDTO param, Model model, HttpSession session) {
		String viewName = "/mypage/mypage_mod";
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ doSelectOne()                         │");
		log.debug("└───────────────────────────────────────┘");
		log.debug("param: {}", param);
		
		
		
		
		 return viewName;
	}
	
	
}
