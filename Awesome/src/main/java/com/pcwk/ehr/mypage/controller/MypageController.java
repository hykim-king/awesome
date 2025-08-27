package com.pcwk.ehr.mypage.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import com.google.gson.Gson;
import com.pcwk.ehr.bookmark.domain.BookmarkDTO;
import com.pcwk.ehr.bookmark.service.BookmarkService;
import com.pcwk.ehr.member.domain.MemberDTO;
import com.pcwk.ehr.member.service.MemberService;
import com.pcwk.ehr.mypage.domain.PagedResult;
import com.pcwk.ehr.report.domain.ReportDTO;
import com.pcwk.ehr.report.domain.ReportSearchDTO;
import com.pcwk.ehr.report.service.ReportService;
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
	
	@Autowired
	ReportService reportService;
	
	public MypageController() {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ MypageController()                    │");
		log.debug("└───────────────────────────────────────┘");	
	}
	
	
	@GetMapping
	public String mypage(Model model, HttpSession session) {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ mypage()                              │");
		log.debug("└───────────────────────────────────────┘");

		MemberDTO loginUser  = (MemberDTO) session.getAttribute("loginUser");
		
		 // 1) 로그인 체크: 모달만 띄우고 바로 반환 (조회 X)
		if(loginUser  == null) {
			log.warn("로그인 없이 마이페이지 조회 시도 차단됨");
			model.addAttribute("loginRequired", true);
			model.addAttribute("message", "로그인이 필요한 기능입니다. 먼저 로그인해 주세요.");
			return "redirect:/member/login.do";
		}
		return "mypage/mypage";
	}
		
	@GetMapping("/userInfo.do")
	public String userInfo(HttpSession session, Model model){
		MemberDTO userId = (MemberDTO) session.getAttribute("loginUser");
		
		MemberDTO param = new MemberDTO();
		param.setUserId(userId.getUserId());
		
		MemberDTO user = memberService.doSelectOne(param);
		model.addAttribute("user", user);
		
		return "mypage/userInfo";
	}
	
	
	@PostMapping("/changePassword.do")
	public String changePassword(
	        @RequestParam String newPwd,
	        @RequestParam String confirmPwd,
	        HttpSession session,
	        RedirectAttributes redirect
	) {
		MemberDTO userId = (MemberDTO) session.getAttribute("loginUser");
	    if (userId == null) {
	        redirect.addFlashAttribute("error", "로그인이 필요합니다.");
	        return "redirect:/login.do";
	    }

	    // 새 비밀번호 확인
	    if (newPwd == null || newPwd.trim().isEmpty() || !newPwd.equals(confirmPwd)) {
	        redirect.addFlashAttribute("error", "비밀번호 확인이 일치하지 않습니다.");
	        return "redirect:/member/changePasswordForm.do";
	    }

	    // DTO 하나로 전달
	    MemberDTO dto = new MemberDTO();
	    dto.setUserId("admin");     // 세션에서 강제
	    dto.setPwd(newPwd);        // 평문(서비스에서 해시)
	    
	    // 서비스에서 encode + update
	    memberService.updatePwdByUserId(dto);

	    redirect.addFlashAttribute("msg", "비밀번호가 변경되었습니다.");
	    return "redirect:/mainpage/main.do";
	}
	
	
	@GetMapping("/edit.do")
	public String editUser(HttpSession session, Model model) {
		MemberDTO userId = (MemberDTO) session.getAttribute("loginUser");
		
		MemberDTO param = new MemberDTO();
		param.setUserId(userId.getUserId());
		
		MemberDTO user = memberService.doSelectOne(param);
		model.addAttribute("user", user);
		
		return "mypage/userInfo_mod";
	}
	
	@PostMapping("/update.do")
	public String updateUser(MemberDTO user, RedirectAttributes redirect) throws SQLException {
		memberService.updateNickNmByUserId(user);
	    redirect.addFlashAttribute("msg", "회원정보가 수정되었습니다.");
	    return "redirect:/mypage/userInfo.do";
	}
	
	@PostMapping("/delete.do")
	public String deleteUser(MemberDTO user, RedirectAttributes redirect) throws SQLException {
		memberService.delete(user);
	    redirect.addFlashAttribute("msg", "회원 탈퇴되었습니다.");
	    return "redirect:/mainpage/main.do";
	}
	
	//각 컨트롤러 마다 로그인 되어있는지 확인
	
	/**
	 * -----------회원정보 END
	 */

	@GetMapping("/bookmarks")
	@ResponseBody
	public PagedResult<BookmarkDTO> myBookmarks(@RequestParam(defaultValue = "1") int pageNo,
	                                            @RequestParam(defaultValue = "5") int pageSize,
	                                            HttpSession session) throws Exception {
	    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

	    BookmarkDTO param = new BookmarkDTO();
	    param.setUserId(loginUser.getUserId());
	    param.setPageNo(pageNo);
	    param.setPageSize(pageSize);

	    List<BookmarkDTO> bkList = bookmarkService.doRetriveMy(param);
	    int bkTotalCnt = bookmarkService.getCountById(param);
	    log.debug("bkList:{}", bkList);
	    log.debug("bkTotalCnt:{}", bkTotalCnt);

	    return new PagedResult<>(bkList, bkTotalCnt);
	}
	
	@GetMapping("/reports")
	@ResponseBody
	public PagedResult<ReportDTO> myReports(@RequestParam(defaultValue = "1") int pageNo,
	                                        @RequestParam(defaultValue = "5") int pageSize,
	                                        HttpSession session) throws Exception {
	    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

	    ReportSearchDTO param = new ReportSearchDTO();
	    param.setUserId(loginUser.getUserId());
	    param.setPageNo(pageNo);
	    param.setPageSize(pageSize);

	    List<ReportDTO> reportList = reportService.doRetrieve(param);
	    int rpTotalCnt = reportService.getCountById(loginUser.getUserId());
	    log.debug("reportList:{}", reportList);
	    log.debug("rpTotalCnt:{}", rpTotalCnt);

	    return new PagedResult<>(reportList, rpTotalCnt);
	}
	
//	//같은 페이지를 그대로 렌더 + 모달 플래그 내려주기(로그인 팝업)
//	//마이페이지에서 내가 북마크한 기사 목록
//	@GetMapping
//	public String doRetriveMy( 
//			@RequestParam(defaultValue = "1") int pageNo,
//	        @RequestParam(defaultValue = "5") int pageSize,
//	        BookmarkDTO param, 
//	        Model model, 
//	        HttpSession session) {
//		String viewName = "/mypage/mypage";
//		log.debug("┌───────────────────────────────────────┐");
//		log.debug("│ doRetriveMy()                         │");
//		log.debug("└───────────────────────────────────────┘");
//		log.debug("param: {}", param);
//		
//		MemberDTO loginUser  = (MemberDTO) session.getAttribute("loginUser");
//
//		
//		 // 1) 로그인 체크: 모달만 띄우고 바로 반환 (조회 X)
//		if(loginUser  == null) {
//			log.warn("로그인 없이 마이페이지 조회 시도 차단됨");
//			model.addAttribute("loginRequired", true);
//			model.addAttribute("message", "로그인이 필요한 기능입니다. 먼저 로그인해 주세요.");
//			return "redirect:/member/login.do";
//		}
//		
//		// 2) 로그인된 경우만 조회
//		param.setUserId(loginUser.getUserId()); //세션에서 주입
//		param.setPageNo(pageNo);
//		param.setPageSize(pageSize);
//		List<BookmarkDTO> list = bookmarkService.doRetriveMy(param);
//		model.addAttribute("list", list);
//		log.debug("북마크 목록 건수: {}", (list != null ? list.size() : 0));
//		
//	    // 전체 건수 (서비스에서 별도로 조회)
//	    int totalCnt = bookmarkService.getCountById(param);
//	    model.addAttribute("totalCnt", totalCnt);
//	    model.addAttribute("pageNo", pageNo);
//	    model.addAttribute("pageSize", pageSize);
//		
//
//	    if(list == null || list.isEmpty()) {
//	        model.addAttribute("noBookmarkMsg", "북마크한 기사가 없습니다. 핫이슈 '오늘의 토픽'을 살펴보세요!");
//	    }
//
//	    return viewName;
//	
//	}
//	
//	@GetMapping("report")
//	public String myReports(@RequestParam(defaultValue = "1") int pageNo,
//			@RequestParam(defaultValue = "5") int pageSize,
//			HttpSession session, Model model
//			) throws Exception {
//		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
//		
//		ReportSearchDTO  search = new ReportSearchDTO();
//		search.setUserId(loginUser.getUserId());
//		search.setPageNo(pageNo);
//		search.setPageSize(pageSize);
//		
//		List<ReportDTO> reportList = reportService.doRetrieve(search);
//		model.addAttribute("reportList", reportList);
//		
//		//전체 건수(페이징용)
//		int totalCnt = reportService.getCountById(loginUser.getUserId());
//		model.addAttribute("totalCnt", totalCnt);
//		model.addAttribute("pageNo", pageNo);
//		model.addAttribute("pageSize", pageSize);
//		
//		if(reportList.isEmpty()) {
//			model.addAttribute("noReportMsg", "신고 내역이 없습니다.");
//		}
//		
//		return "mypage/mypage";
//	}
//	
	@GetMapping(value="/checkOne", produces="application/json;charset=UTF-8")
	@ResponseBody
	public String checkOne(@RequestParam("articleCode") int articleCode, HttpSession session) {
		MemberDTO loginUser  = (MemberDTO) session.getAttribute("loginUser");

	    Map<String, Object> res = new HashMap<>();
	    if (loginUser  == null) {
	        res.put("loggedIn", false);
	        res.put("bookmarked", false);
	        return new Gson().toJson(res);
	    }

	    BookmarkDTO param = new BookmarkDTO();
	    param.setUserId(loginUser.getUserId());
	    param.setArticleCode(articleCode);

	    BookmarkDTO outVO = bookmarkService.doSelectOne(param);
	    res.put("loggedIn", true);
	    res.put("bookmarked", outVO != null);
	    return new Gson().toJson(res);
	}
	
	
	@PostMapping(value = "/toggleBookmark.do", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String toggleBookmark(BookmarkDTO param, HttpSession session) {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ toggleBookmark()                      │");
		log.debug("└───────────────────────────────────────┘");
		String jsonString = "";
		log.debug("1. param:{}", param);
		
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
		
		if(loginUser == null) {
		    Map<String,Object> res = new HashMap<>();
		    res.put("flag", -99);
		    res.put("bookmarked", false);
		    res.put("message", "로그인이 필요한 기능입니다.");
		    return new Gson().toJson(res);
		}
		
		param.setUserId(loginUser.getUserId()); //세션에서 주입
		
		int flag = bookmarkService.toggleBookmark(param);
		boolean bookmarked = (flag == 1);
		Map<String, Object> res = new HashMap<>();
	    res.put("flag", flag);
	    res.put("bookmarked", bookmarked);
	    res.put("message", bookmarked ? "북마크가 추가되었습니다." : "북마크가 삭제되었습니다.");
	    return new Gson().toJson(res);
	}

	
	@GetMapping(value = "/api/mypage/summary", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public String getSummary(HttpSession session) {
	    log.debug("┌───────────────────────────────────────┐");
	    log.debug("│ getSummary()                          │");
	    log.debug("└───────────────────────────────────────┘");
		
	    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

	    UserLogDTO param = new UserLogDTO();
	    param.setUserId(loginUser.getUserId());

	    List<UserChartDTO> list = userLogService.doRetrieveById(param);

	    if (list == null || list.isEmpty()) {
	        return "";
	    }

	    UserChartDTO top = list.get(0);
	    return "안녕하세요 " + param.getUserId()+"님" + "\n이번 주 " + top.getCategory() + " 분야를 유심히 보셨네요.";
	}
	
	@GetMapping("/api/mypage/chart")
	@ResponseBody
	public List<UserChartDTO> getUserChartData(HttpSession session) {
	    log.debug("┌───────────────────────────────────────┐");
	    log.debug("│ getUserChartData()                    │");
	    log.debug("└───────────────────────────────────────┘");

	    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
	    

	    UserLogDTO param = new UserLogDTO();
	    param.setUserId(loginUser.getUserId());

	    List<UserChartDTO> list = userLogService.doRetrieveById(param);

	    // 데이터 없을 경우 빈 리스트 반환 (JSON에서 []로 내려감)
	    return list != null ? list : new ArrayList<>();
	}
	
}
