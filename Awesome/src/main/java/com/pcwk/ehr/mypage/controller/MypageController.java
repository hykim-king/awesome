package com.pcwk.ehr.mypage.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pcwk.ehr.userLog.domain.UserLogDTO;
import com.pcwk.ehr.userLog.service.UserLogService;

@Controller
public class MypageController {
	
	Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	UserLogService userLogService;
	
	public MypageController() {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ MypageController()                    │");
		log.debug("└───────────────────────────────────────┘");	
	}
	
//	@GetMapping("/mypage")
//	public String doRetrieveById(UserLogDTO param, Model model, HttpSession session) {
//		String viewName = "/mypage/mypage";
//		log.debug("┌───────────────────────────────────────┐");
//		log.debug("│ doRetrieveById()                      │");
//		log.debug("└───────────────────────────────────────┘");
//		log.debug("param: {}", param);
//		
//		String userId = (String) session.getAttribute("userId");
//		
//		param.setUserId(userId);
//	    List<UserLogDTO> list = userLogService.doRetrieveById(param);
//	    model.addAttribute("list", list);
//	    
//	    if(list == null || list.isEmpty()) {
//	        model.addAttribute("noReadArticle", "이번주 읽은 기사가 없습니다.<br>핫이슈 '오늘의 토픽'을 살펴보세요!");
//	    }
//
//	    return viewName;
//	}
	
	@GetMapping("/api/mypage/chart")
	@ResponseBody
	public List<UserLogDTO> getUserChartData(HttpSession session) {
	    log.debug("┌───────────────────────────────────────┐");
	    log.debug("│ getUserChartData()                    │");
	    log.debug("└───────────────────────────────────────┘");

//	    String userId = (String) session.getAttribute("userId");


	    UserLogDTO param = new UserLogDTO();
	    param.setUserId("user01");

	    List<UserLogDTO> list = userLogService.doRetrieveById(param);

	    // 데이터 없을 경우 빈 리스트 반환 (JSON에서 []로 내려감)
	    return list != null ? list : new ArrayList<>();
	}
	
}
