package com.pcwk.ehr.member.controller;

import com.pcwk.ehr.member.domain.MemberDTO;
import com.pcwk.ehr.member.service.MemberService;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.sql.SQLException;

@Controller
@RequestMapping("/member")
public class MemberController {

    final Logger log = LogManager.getLogger(getClass());

    @Autowired
    private MemberService memberService;

    // 회원가입 폼 이동
    @GetMapping("/register.do")
    public String registerForm() {
        return "member/register";
    }

    // 회원가입 처리
    @PostMapping("/register.do")
    public String register(@ModelAttribute MemberDTO dto,
                           RedirectAttributes redirectAttributes) throws Exception {

        int result = memberService.register(dto);
        if (result == 1) {
            redirectAttributes.addFlashAttribute("message", "회원가입 성공! 이메일을 확인해주세요.");
            return "redirect:/member/login.do";
        } else {
            redirectAttributes.addFlashAttribute("message", "회원가입 실패!");
            return "redirect:/member/register.do";
        }
    }

    // 이메일 인증 확인
    @GetMapping("/verifyEmail")
    public String verifyEmail(@RequestParam("token") String token, Model model) throws SQLException {
        boolean isVerified = memberService.verifyEmailToken(token);
        model.addAttribute("verified", isVerified);
        return "member/emailResult";
    }

    // 로그인 폼
    @GetMapping("/login.do")
    public String loginForm() {
        return "member/login";
    }

    // 로그인 처리
    @PostMapping("/login.do")
    public String login(@ModelAttribute MemberDTO dto,
                        RedirectAttributes redirectAttributes) throws SQLException {
        MemberDTO loginUser = memberService.login(dto);

        if (loginUser != null) {
            redirectAttributes.addFlashAttribute("message", loginUser.getUserId() + "님 로그인 성공!");
            return "redirect:/home.do";
        } else {
            redirectAttributes.addFlashAttribute("message", "로그인 실패. 아이디 또는 비밀번호를 확인해주세요.");
            return "redirect:/member/login.do";
        }
    }
}
