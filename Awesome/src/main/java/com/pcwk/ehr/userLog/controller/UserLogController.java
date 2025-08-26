package com.pcwk.ehr.userLog.controller;

import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.pcwk.ehr.member.domain.MemberDTO;
import com.pcwk.ehr.userLog.domain.UserLogDTO;

import com.pcwk.ehr.userLog.service.UserLogService;

@Controller
@RequestMapping("/userlog")
public class UserLogController {

//    Logger log = LogManager.getLogger(getClass());
//
//    @Autowired
//    UserLogService userLogService;

    /** 이거만 씀 -> 아티클로 이동 
     * 1. 사용자 클릭 로그 저장 (클릭 액션 전용)
     * - 프론트에서 기사 클릭 시 Ajax로 호출해도 되고,
     *   필요하면 GET으로 바꿔서 쿼리스트링으로 호출해도 됨.
     */
/*    @PostMapping("/add.do")
    @ResponseBody
    public String add(@RequestParam("articleCode") Long articleCode,
                      HttpSession session) {
    	MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");  // 로그인 정보
    	String userId = (loginUser != null) ? loginUser.getUserId() : null;
        log.debug("add.do() userId={}, articleCode={}", loginUser, articleCode);

        if (loginUser == null || articleCode == null) {
            return "NOT_LOGGED_IN_OR_BAD_REQUEST";
        }

        userLogService.logArticleClick(userId, articleCode);
        return "OK";
    }
*/
    /**  안씀
     * 2. 사용자별 로그 목록 (페이징 없음) - 안씀
     * - /userlog/list.do?userId=abc  로 특정 유저 조회
     * - 파라미터 없으면 세션 사용자로 조회
     */
/*    @GetMapping("/list.do")
    public String list(@RequestParam(value = "userId", required = false) String userId,
                       HttpSession session,
                       Model model) {

        String targetUserId = (userId != null) ? userId : (String) session.getAttribute("userId");
        log.debug("list.do() targetUserId={}", targetUserId);

        List<UserLogDTO> list = (targetUserId == null)
                ? Collections.emptyList()
                : userLogService.getLogsByUser(targetUserId);

        model.addAttribute("list", list);
        model.addAttribute("userId", targetUserId);

        return "userlog/list"; 
    }*/

}