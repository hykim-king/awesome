package com.pcwk.ehr.mypage.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pcwk.ehr.bookmark.domain.BookmarkDTO;
import com.pcwk.ehr.bookmark.service.BookmarkService;
import com.pcwk.ehr.member.domain.MemberDTO;
import com.pcwk.ehr.member.service.MemberService;
import com.pcwk.ehr.userLog.domain.UserChartDTO;
import com.pcwk.ehr.userLog.domain.UserLogDTO;
import com.pcwk.ehr.userLog.service.UserLogService;

@Controller
@RequestMapping("/mypage")
public class MypageController {
	
	Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	UserLogService userLogService;
	
	@Autowired
	BookmarkService bookmarkService;
	
	@Autowired
	MemberService memberService;
	
	public MypageController() {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ MypageController()                    │");
		log.debug("└───────────────────────────────────────┘");	
	}
	
	@GetMapping("/userInfo.do")
	public String userInfo(HttpSession session, Model model){
		String userId = (String) session.getAttribute("userId");
		
		MemberDTO param = new MemberDTO();
		param.setUserId(userId);
		
		MemberDTO user = memberService.doSelectOne(param);
		model.addAttribute("user", user);
		
		return "mypage/userInfo";
	}
	
	@GetMapping("/edit.do")
	public String editUser(HttpSession session, Model model) {
		String userId = (String) session.getAttribute("userId");
		
		MemberDTO param = new MemberDTO();
		param.setUserId(userId);
		
		MemberDTO user = memberService.doSelectOne(param);
		model.addAttribute("user", user);
		
		return "mypage/userEdit";
	}
	
	@PostMapping("/update.do")
	public String updateUser(MemberDTO user, RedirectAttributes redirect) throws SQLException {
		memberService.update(user);
	    redirect.addFlashAttribute("msg", "회원정보가 수정되었습니다.");
	    return "redirect:/mypage/userInfo.do";
	}
	
	@PostMapping("/delete.do")
	public String deleteUser(MemberDTO user, RedirectAttributes redirect) throws SQLException {
		memberService.delete(user);
	    redirect.addFlashAttribute("msg", "회원 탈퇴되었습니다.");
	    return "redirect:/mainpage/main.do";
	}
	
	//탈퇴 팝업 비밀번호 수정으로 들어가는 컨트롤러 만들면 됨
	
	/**
	 * -----------회원정보 END
	 */
	
	//같은 페이지를 그대로 렌더 + 모달 플래그 내려주기(로그인 팝업)
	//마이페이지에서 내가 북마크한 기사 목록
	@GetMapping
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
		
//		String userId = (String) session.getAttribute("userId");
		String userId = "user01";
		
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
	    int totalCnt = bookmarkService.getCountById(param);
	    model.addAttribute("totalCnt", totalCnt);
	    model.addAttribute("pageNo", pageNo);
	    model.addAttribute("pageSize", pageSize);
		

	    if(list == null || list.isEmpty()) {
	        model.addAttribute("noBookmarkMsg", "북마크한 기사가 없습니다.<br>핫이슈 '오늘의 토픽'을 살펴보세요!");
	    }

	    return viewName;
	
	}
	
	@GetMapping(value = "/api/mypage/summary", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public String getSummary(HttpSession session) {
	    log.debug("┌───────────────────────────────────────┐");
	    log.debug("│ getSummary()                          │");
	    log.debug("└───────────────────────────────────────┘");
		
		//테스트용 임시 ID
	    UserLogDTO param = new UserLogDTO();
	    param.setUserId("user01");

	    List<UserChartDTO> list = userLogService.doRetrieveById(param);

	    if (list == null || list.isEmpty()) {
	        return "이번 주에는 기사를 보지 않으셨네요!";
	    }

	    UserChartDTO top = list.get(0);
	    return "이번 주 " + top.getCategory() + " 분야를 유심히 보셨네요.";
	}
	
	@GetMapping("/api/mypage/chart")
	@ResponseBody
	public List<UserChartDTO> getUserChartData(HttpSession session) {
	    log.debug("┌───────────────────────────────────────┐");
	    log.debug("│ getUserChartData()                    │");
	    log.debug("└───────────────────────────────────────┘");

//	    String userId = (String) session.getAttribute("userId");
	    

	    UserLogDTO param = new UserLogDTO();
	    param.setUserId("user01");

	    List<UserChartDTO> list = userLogService.doRetrieveById(param);

	    // 데이터 없을 경우 빈 리스트 반환 (JSON에서 []로 내려감)
	    return list != null ? list : new ArrayList<>();
	}
	
}
