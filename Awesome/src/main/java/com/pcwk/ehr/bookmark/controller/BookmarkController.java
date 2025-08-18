package com.pcwk.ehr.bookmark.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.ui.Model;

import com.google.gson.Gson;
import com.pcwk.ehr.bookmark.domain.BookmarkDTO;
import com.pcwk.ehr.bookmark.service.BookmarkService;
import com.pcwk.ehr.cmn.MessageDTO;

@Controller
@RequestMapping("/bookmark")
public class BookmarkController {

	Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	BookmarkService bookmarkService;
	
	public BookmarkController() {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ BookmarkController()                  │");
		log.debug("└───────────────────────────────────────┘");	
		
	}
	
	@GetMapping(value = "/mypage.do")
	public String main() {
		return "mypage/mypage";
	}
	
	//로그인된 유저에 한 해 북마크 토글 기능
	@PostMapping(value = "/toggleBookmark.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String toggleBookmark(BookmarkDTO param, HttpSession session) {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ toggleBookmark()                      │");
		log.debug("└───────────────────────────────────────┘");
		String jsonString = "";
		log.debug("1. param:{}", param);
		
		String userId = (String) session.getAttribute("userId");
		
		if(userId == null || userId.trim().isEmpty()) {
			log.warn("로그인 없이 북마크 등록 시도 차단됨");
			MessageDTO messageDTO = new MessageDTO(-99, "로그인이 필요한 기능입니다. 먼저 로그인해 주세요.");
			return new Gson().toJson(messageDTO);
		}
		
		param.setUserId(userId); //세션에서 주입
	
		int flag = bookmarkService.toggleBookmark(param);
		String message = "";
		
		if(1 == flag) {
			message = "북마크가 추가 되었습니다.";
		}else {
			message = "북마크가 삭제 되었습니다.";
		}
		
		MessageDTO messageDTO = new MessageDTO(flag, message);
		jsonString = new Gson().toJson(messageDTO);
		log.debug("1. jsonString: {}", jsonString);
		
		return jsonString;
	}

	
	//기사 페이지에서 각 기사마다 북마크 여부 조회
	@GetMapping(value = "/doSelectOne.do")
	public String doSelectOne(BookmarkDTO param, Model model,HttpSession session) {
		String viewName = "/article/list";
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ doSelectOne()                         │");
		log.debug("└───────────────────────────────────────┘");
		log.debug("param: {}", param);
		
		String userId = (String) session.getAttribute("userId");
		
		param.setUserId(userId);
		BookmarkDTO outVO = bookmarkService.doSelectOne(param);
		model.addAttribute("outVO", outVO);
		
		if(outVO != null) {
			model.addAttribute("bookmark", true);
		}
		
		return viewName;
	}
	
	
	//같은 페이지를 그대로 렌더 + 모달 플래그 내려주기(로그인 팝업)
	//마이페이지에서 내가 북마크한 기사 목록
	@GetMapping(value = "/doRetriveMy.do")
	public String doRetriveMy( 
			@RequestParam(defaultValue = "1") int pageNo,
	        @RequestParam(defaultValue = "5") int pageSize,
	        BookmarkDTO param, 
	        Model model, 
	        HttpSession session) {
		String viewName = "/mypage/mypage";
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ doRetriveMy()                         │");
		log.debug("└───────────────────────────────────────┘");
		log.debug("param: {}", param);
		
		String userId = (String) session.getAttribute("userId");
		
		 // 1) 로그인 체크: 모달만 띄우고 바로 반환 (조회 X)
		if(userId == null || userId.trim().isEmpty()) {
			log.warn("로그인 없이 마이페이지 조회 시도 차단됨");
			model.addAttribute("loginRequired", true);
			model.addAttribute("message", "로그인이 필요한 기능입니다. 먼저 로그인해 주세요.");
			return viewName;
		}
		
		// 2) 로그인된 경우만 조회
		param.setUserId(userId); //세션에서 주입
		param.setPageNo(pageNo);
		param.setPageSize(pageSize);
		List<BookmarkDTO> list = bookmarkService.doRetriveMy(param);
		model.addAttribute("list", list);
		log.debug("북마크 목록 건수: {}", (list != null ? list.size() : 0));
		
	    // 전체 건수 (서비스에서 별도로 조회)
	    int totalCnt = bookmarkService.getCount(param);
	    model.addAttribute("totalCnt", totalCnt);
	    model.addAttribute("pageNo", pageNo);
	    model.addAttribute("pageSize", pageSize);
		

	    if(list == null || list.isEmpty()) {
	        model.addAttribute("noBookmarkMsg", "북마크한 기사가 없습니다.<br>핫이슈 '오늘의 토픽'을 살펴보세요!");
	    }

	    return viewName;
	
	}
}
