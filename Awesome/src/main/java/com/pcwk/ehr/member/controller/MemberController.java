package com.pcwk.ehr.member.controller;

import java.security.SecureRandom;
import java.sql.SQLException;

import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pcwk.ehr.member.domain.MemberDTO;
import com.pcwk.ehr.member.service.MemberService;

@Controller
@RequestMapping("/member")
public class MemberController {

    private final Logger log = LogManager.getLogger(getClass());

    @Autowired
    private MemberService memberService;

    // 메일 발송에 사용 (root-context.xml 의 bean id 가 "javaMailSender" 여야 함)
    @Autowired @Qualifier("javaMailSender")
    private JavaMailSender mailSender;

    /* ================== 뷰 이동 ================== */
    @GetMapping("/register.do")
    public String registerForm() { return "member/register"; }

    @GetMapping("/login.do")
    public String loginForm() { return "member/login"; }

    /* ================== 아이디/닉네임 중복 ================== */
    @GetMapping(value = "/checkId", produces = "text/plain; charset=UTF-8")
    @ResponseBody
    public String checkId(@RequestParam String userId) throws Exception {
        return memberService.existsById(userId) ? "DUP" : "OK";
    }

    @GetMapping(value = "/checkNick", produces = "text/plain; charset=UTF-8")
    @ResponseBody
    public String checkNick(@RequestParam String nickNm) throws Exception {
        return memberService.existsByNick(nickNm) ? "DUP" : "OK";
    }

    /* ================== 이메일 인증(코드) ================== */
    @PostMapping(value="/sendEmailAuth.do", produces="text/plain; charset=UTF-8")
    @ResponseBody
    public String sendEmailAuth(@RequestParam(required=false) String userId,
                                @RequestParam String mailAddr,
                                HttpSession session) {

        if (mailAddr == null || mailAddr.trim().isEmpty()) return "INVALID_EMAIL_EMPTY";
        if (!mailAddr.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) return "INVALID_EMAIL_FORMAT";

        // 6자리 코드, 5분 만료
        String code = String.format("%06d", new SecureRandom().nextInt(1_000_000));
        long   exp  = System.currentTimeMillis() + 5 * 60 * 1000;

        session.setAttribute("emailCode:" + mailAddr, code);
        session.setAttribute("emailCodeExp:" + mailAddr, exp);

        try {
            SimpleMailMessage msg = new SimpleMailMessage();
            String from = (mailSender instanceof JavaMailSenderImpl)
                    ? ((JavaMailSenderImpl) mailSender).getUsername()
                    : "com0494@naver.com"; // fallback

            msg.setFrom(from);
            msg.setTo(mailAddr);
            msg.setSubject("[회원가입] 이메일 인증코드 (5분 유효)");
            msg.setText("인증코드: " + code + "\n유효시간: 5분\n※ 타인에게 공유하지 마세요.");

            mailSender.send(msg);
            log.info("[MAIL] code sent to {} (exp in 5min)", mailAddr);
            return "SENT";
        } catch (Exception e) {
            log.error("[MAIL] send fail: {}", mailAddr, e);
            return "FAIL_SEND";
        }
    }

    @PostMapping(value="/verifyEmailCode", produces="text/plain; charset=UTF-8")
    @ResponseBody
    public String verifyEmailCode(@RequestParam String mailAddr,
                                  @RequestParam String code,
                                  HttpSession session) {

        String saved = (String) session.getAttribute("emailCode:" + mailAddr);
        Long   exp   = (Long)   session.getAttribute("emailCodeExp:" + mailAddr);

        if (saved == null || exp == null) return "NO_CODE";
        if (System.currentTimeMillis() > exp) return "EXPIRED";
        if (!saved.equals(code)) return "INVALID";

        session.setAttribute("emailVerified", mailAddr);
        return "OK";
    }

    /* ================== 회원가입 처리 ================== */
    @PostMapping("/register.do")
    public String register(@ModelAttribute MemberDTO dto,
                           RedirectAttributes ra,
                           HttpSession session) throws Exception {

        String verifiedEmail = (String) session.getAttribute("emailVerified");
        if (verifiedEmail == null || !verifiedEmail.equalsIgnoreCase(dto.getMailAddr())) {
            ra.addFlashAttribute("message", "이메일 인증을 먼저 완료하세요.");
            return "redirect:/member/register.do";
        }

        dto.setEmailAuthYn("Y");
        dto.setEmailAuthToken(null);

        int result = memberService.register(dto);

        session.removeAttribute("emailCode:" + dto.getMailAddr());
        session.removeAttribute("emailCodeExp:" + dto.getMailAddr());
        session.removeAttribute("emailVerified");

        ra.addFlashAttribute("message", result == 1 ? "회원가입 성공!" : "회원가입 실패!");
        return "redirect:" + (result == 1 ? "/member/login.do" : "/member/register.do");
    }

    /* ================== (옵션) 토큰 방식 이메일 검증 ================== */
    @GetMapping("/verifyEmail")
    public String verifyEmail(@RequestParam("token") String token, Model model) throws Exception {
        boolean ok = memberService.verifyEmailToken(token);
        model.addAttribute("verified", ok);
        return "member/emailResult";
    }

    /* ================== 로그인/로그아웃 ================== */
    @PostMapping("/login.do")
    public String login(@ModelAttribute MemberDTO dto,
                        HttpSession session,
                        RedirectAttributes redirectAttributes) throws SQLException {
        MemberDTO loginUser = memberService.login(dto);
        if (loginUser != null) {
            session.setAttribute("loginUser", loginUser);
            redirectAttributes.addFlashAttribute("message", loginUser.getUserId() + "님 로그인 성공!");
            return "redirect:/mainPage/main.do";
        } else {
            redirectAttributes.addFlashAttribute("error", "로그인 실패. 아이디 또는 비밀번호를 확인해주세요.");
            return "redirect:/member/login.do";
        }
    }

    @GetMapping("/logout.do") // 클래스 레벨 /member 가 붙으므로 실제 경로는 /member/logout.do
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/mainPage/main.do";
    }

    /* ================== 아이디/비밀번호 찾기 ================== */
    @GetMapping("/findId.do")
    public String findIdForm() { return "member/findId"; } // /WEB-INF/views/member/findId.jsp

    @PostMapping("/findId.do")
    public String findId(@RequestParam String userNm,
                         @RequestParam String mailAddr,
                         Model model) throws SQLException {

        String userId = memberService.findUserId(userNm, mailAddr); // 없으면 null
        model.addAttribute("foundId", userId == null ? null : mask(userId));
        model.addAttribute("submitted", true);
        return "member/findId";
    }

    @GetMapping("/findPwd.do")
    public String findPwdForm() { return "member/findPwd"; } // /WEB-INF/views/member/findPwd.jsp

    @PostMapping("/findPwd.do")
    public String findPwd(@RequestParam String userId,
                          @RequestParam String mailAddr,
                          RedirectAttributes ra) {

        boolean ok = memberService.sendResetMail(userId, mailAddr); // 임시비번/재설정 메일 발송
        if (ok) {
            ra.addFlashAttribute("message", "비밀번호 재설정 메일을 보냈습니다.");
        } else {
            ra.addFlashAttribute("error", "일치하는 계정을 찾을 수 없습니다.");
        }
        return "redirect:/member/login.do";
    }

    /* ================== 유틸 ================== */
    private String mask(String id) {
        if (id == null || id.isEmpty()) return "";
        if (id.length() <= 3) return id.charAt(0) + "***";
        return id.substring(0, 3) + "****";
    }
}
