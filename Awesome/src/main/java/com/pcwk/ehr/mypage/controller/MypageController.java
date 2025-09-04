package com.pcwk.ehr.mypage.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.pcwk.ehr.article.domain.ArticleDTO;
import com.pcwk.ehr.bookmark.domain.BookmarkDTO;
import com.pcwk.ehr.bookmark.service.BookmarkService;
import com.pcwk.ehr.member.domain.MemberDTO;
import com.pcwk.ehr.member.service.MemberService;
import com.pcwk.ehr.mypage.domain.PagedResult;
import com.pcwk.ehr.report.domain.ReportDTO;
import com.pcwk.ehr.report.domain.ReportSearchDTO;
import com.pcwk.ehr.report.service.ReportService;
import com.pcwk.ehr.userKeyword.domain.UserKeywordDTO;
import com.pcwk.ehr.userKeyword.service.WordCloudService;
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
	
	@Autowired
	WordCloudService wordCloudService;
	
	
	public MypageController() {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ MypageController()                    │");
		log.debug("└───────────────────────────────────────┘");	
	}
	
	/**
	 * 마이페이지 진입 컨트롤러
	 */
	@GetMapping
	public String mypage(Model model, 
			             HttpSession session,
			             RedirectAttributes redirect) {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ mypage()                              │");
		log.debug("└───────────────────────────────────────┘");

		MemberDTO loginUser  = (MemberDTO) session.getAttribute("loginUser");
		
		 // 1) 로그인 체크: 모달만 띄우고 바로 반환 (조회 X)
		if(loginUser  == null) {
			redirect.addFlashAttribute("msg", "로그인이 필요한 기능입니다. 먼저 로그인해 주세요.");
			return "redirect:/member/login.do";
		}
		return "mypage/mypage";
	}
		
	/**
	 * 회원정보 컨트롤러 
	 */
	@GetMapping("/userInfo.do")
	public String userInfo(HttpSession session, Model model){
		MemberDTO userId = (MemberDTO) session.getAttribute("loginUser");
		
		MemberDTO param = new MemberDTO();
		param.setUserId(userId.getUserId());
		
		MemberDTO user = memberService.doSelectOne(param);
		model.addAttribute("user", user);
		
		return "mypage/userInfo";
	}
	

	
	/**
	 * 회원정보 수정 페이지 진입 컨트로러
	 */
	@GetMapping("/edit.do")
	public String editUser(HttpSession session, Model model) {
		MemberDTO userId = (MemberDTO) session.getAttribute("loginUser");
		
		MemberDTO param = new MemberDTO();
		param.setUserId(userId.getUserId());
		
		MemberDTO user = memberService.doSelectOne(param);
		model.addAttribute("user", user);
		
		return "mypage/userInfo_mod";
	}
	
	/**
	 * 회원정보 수정 컨트롤러/ 닉네임 중복 확인 
	 * @throws Exception 
	 */
	@PostMapping("/update.do")
	public String updateUser(MemberDTO user, 
							RedirectAttributes redirect,
							HttpSession session) throws Exception {
	    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
	    if (loginUser == null) {
	        redirect.addFlashAttribute("msg", "로그인이 필요합니다.");
	        return "redirect:/login/login.do";
	    }
	
		
		String nickNm = user.getNickNm();
		boolean result = memberService.existsByNick(nickNm);
		if(result != false) {
			redirect.addFlashAttribute("msg", "중복된 닉네임입니다.");
			return "redirect:/mypage/edit.do";
		}
		
		user.setUserId(loginUser.getUserId());
		memberService.updateNickNmByUserId(user); 
		session.setAttribute("loginUser", user);
		redirect.addFlashAttribute("msg", "회원정보가 수정되었습니다.");
	    return "redirect:/mypage/userInfo.do";
	}
	
	/**
	 * 회원 탈퇴 컨트롤러/ 팝업 창 추가
	 */
	@PostMapping("/delete.do")
	public String deleteUser(HttpSession session, RedirectAttributes redirect) throws SQLException {
		
	    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
	    if (loginUser == null) {
			redirect.addFlashAttribute("msg", "로그인이 필요합니다.");
		    return "redirect:/member/login.do";
	    }
		
		memberService.delete(loginUser.getUserId());
		
	    // ✅ 세션 무효화 (로그아웃 처리)
	    session.invalidate();
		
	    redirect.addFlashAttribute("msg", "회원 탈퇴되었습니다.");
	    return "redirect:/mainPage/main.do";
	}
	
	/**
	 * 비밀번호 변경 컨트롤러
	 */
	@PostMapping(value="/changePassword.do")
	public String changePassword(
	        @RequestParam String newPwd,
	        @RequestParam String confirmPwd,
	        RedirectAttributes redirect,
	        HttpSession session
	) {
	    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
	    if (loginUser == null) {
			redirect.addFlashAttribute("msg", "로그인이 필요합니다.");
		    return "redirect:/member/login.do";
	    }

	    if (newPwd == null || newPwd.trim().isEmpty() || !newPwd.equals(confirmPwd)) {
			redirect.addFlashAttribute("msg", "비밀번호 확인이 일치하지 않습니다.");
		    return "redirect:/mypage/edit.do";
	    }

	    MemberDTO dto = new MemberDTO();
	    dto.setUserId(loginUser.getUserId()); 
	    dto.setPwd(newPwd);                   // 서비스에서 해시 처리
	    memberService.updatePwdByUserId(dto);
	    
	    // ✅ 세션 무효화 (로그아웃 처리)
	    session.invalidate();
	    
		redirect.addFlashAttribute("msg", "비밀번호가 변경되었습니다.");
	    return "redirect:/mainPage/main.do";
	}

	// ----- helpers -----
	private ResponseEntity<String> htmlScript(String msg, String redirectUrl) {
	    return htmlScript(msg, redirectUrl, false);
	}
	private ResponseEntity<String> htmlScript(String msg, String redirectUrl, boolean replace) {
	    String safeMsg = msg.replace("\\", "\\\\").replace("'", "\\'");
	    String safeUrl = redirectUrl.replace("\\", "\\\\").replace("'", "\\'");
	    String script = "<!doctype html><html><head><meta charset='UTF-8'></head><body>"
	            + "<script>"
	            + "alert('" + safeMsg + "');"
	            + (replace ? "location.replace('" + safeUrl + "');" : "location.href='" + safeUrl + "';")
	            + "</script>"
	            + "</body></html>";
	    HttpHeaders headers = new HttpHeaders();
	    headers.setContentType(MediaType.TEXT_HTML);
	    return ResponseEntity.ok().headers(headers).body(script);
	}
	
	
	/**
	 * -----------회원정보 END
	 */

	/**
	 * 북마크된 기사 조회 컨트롤러
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
	    
	    return new PagedResult<>(bkList, bkTotalCnt);
	}
	
	/**
	 * 신고 항목 조회 컨트롤러
	 */
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
	    
	    return new PagedResult<>(reportList, rpTotalCnt);
	}
	
	
	/**
	 * 추천 기사 조회 컨트롤러
	 */
	@GetMapping("/recommend")
	@ResponseBody
	public List<ArticleDTO> myRecommend(HttpSession session){
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ myRecommend()                         │");
		log.debug("└───────────────────────────────────────┘");
		
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
		
		String param = loginUser.getUserId();
		
		List<ArticleDTO> recommendList = userLogService.getRecommendedArticlesByUser(param);
		
		return recommendList;
	}
	
	/**
	 * 북마크 여부 확인 컨트롤러
	 */
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
	
	/**
	 * 북마크 작동 컨트롤러
	 */
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

	/**
	 * 차트 요약 컨트롤러
	 */
	@GetMapping(value = "/api/mypage/summary", produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public String getSummary(HttpSession session,
			   				 @RequestParam(defaultValue = "0") int weekOffset) {
	    log.debug("┌───────────────────────────────────────┐");
	    log.debug("│ getSummary()                          │");
	    log.debug("└───────────────────────────────────────┘");
		
	    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

	    UserLogDTO param = new UserLogDTO();
	    param.setUserId(loginUser.getUserId());
	    param.setNickNm(loginUser.getNickNm());
	    param.setWeekOffset(weekOffset);

	    List<UserChartDTO> list = userLogService.doRetrieveById(param);
	    
	    if (list == null || list.isEmpty()) {
	        return "안녕하세요 " + param.getNickNm()+"님" + (weekOffset == 0 ? "\n이번 주" : "\n지난 주") + " 기사를 읽으신 기록이 없습니다.";
	    }

	    UserChartDTO top = list.get(0);
	    String label = (weekOffset == 0) ? "\n이번 주 " : "\n지난 주 ";
	    
	    
	    return "안녕하세요 " + param.getNickNm()+"님" +  label  + "'" + top.getCategory() + "'" + " 분야를 유심히 보셨네요.";
	}
	
	/**
	 * 요일 별 차트 컨트롤러
	 */
	@GetMapping("/api/mypage/trend")
	@ResponseBody
	public List<UserChartDTO> getUserDate(HttpSession session,
										  @RequestParam(defaultValue = "0") int weekOffset) {
	    log.debug("┌───────────────────────────────────────┐");
	    log.debug("│ getUserDate()                         │");
	    log.debug("└───────────────────────────────────────┘");

	    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
	    

	    UserLogDTO param = new UserLogDTO();
	    param.setUserId(loginUser.getUserId());
	    param.setWeekOffset(weekOffset);

	    List<UserChartDTO> list = userLogService.selectWeeklyTrend(param);

	    // 데이터 없을 경우 빈 리스트 반환 (JSON에서 []로 내려감)
	    return list != null ? list : new ArrayList<>();
	}
	
	
	/**
	 * 차트 컨트롤러
	 */
	@GetMapping("/api/mypage/chart")
	@ResponseBody
	public List<UserChartDTO> getUserChartData(HttpSession session,
									           @RequestParam(defaultValue = "0") int weekOffset) {
	    log.debug("┌───────────────────────────────────────┐");
	    log.debug("│ getUserChartData()                    │");
	    log.debug("└───────────────────────────────────────┘");

	    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
	    

	    UserLogDTO param = new UserLogDTO();
	    param.setUserId(loginUser.getUserId());
	    param.setWeekOffset(weekOffset);

	    List<UserChartDTO> list = userLogService.doRetrieveById(param);

	    // 데이터 없을 경우 빈 리스트 반환 (JSON에서 []로 내려감)
	    return list != null ? list : new ArrayList<>();
	}
	
	/**
	 * 워드 클라우드
	 */
	@GetMapping("/api/mypage/wordcloud")
	@ResponseBody
	public List<UserKeywordDTO> getWordCloud(HttpSession session) {
	    log.debug("┌───────────────────────────────┐");
	    log.debug("│ getWordCloud()                │");
	    log.debug("└───────────────────────────────┘");

	    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

	    String param = loginUser.getUserId();

	    List<UserKeywordDTO> list = wordCloudService.selectKeyword(param);
	    log.debug("list: {}", list);
	   
	    return list != null ? list : new ArrayList<>();
	}
	
	
}
