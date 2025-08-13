package com.pcwk.ehr.member.controller;

import com.pcwk.ehr.member.domain.MemberDTO;
import com.pcwk.ehr.member.service.MemberService;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.sql.SQLException;

@Controller
@RequestMapping("/member")
public class MemberController {

    private final Logger log = LogManager.getLogger(getClass());

    @Autowired private MemberService memberService;

    // 메일 발송에 사용 (root-context.xml의 bean id가 "javaMailSender"라면 Qualifier 지정)
    @Autowired @Qualifier("javaMailSender")
    private JavaMailSender mailSender;

    // ============ 뷰 이동 ============
    @GetMapping("/register.do")
    public String registerForm() { return "member/register"; }

    @GetMapping("/login.do")
    public String loginForm() { return "member/login"; }

    // ============ 아이디 중복 체크 ============
    @GetMapping(value = "/checkId", produces = "text/plain; charset=UTF-8")
    @ResponseBody
    public String checkId(@RequestParam String userId) throws Exception {
        return memberService.existsById(userId) ? "DUP" : "OK";
    }

    // ============ 1) 인증코드 메일 발송 ============
    // 프런트에서 '/ehr/member/sendEmailAuth.do' 로 호출
    @PostMapping(value="/sendEmailAuth.do", produces="text/plain; charset=UTF-8")
    @ResponseBody
    public String sendEmailAuth(@RequestParam(required=false) String userId,
                                @RequestParam String mailAddr,
                                HttpSession session) {

        if (mailAddr == null || mailAddr.trim().isEmpty()) return "INVALID_EMAIL_EMPTY";
        if (!mailAddr.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) return "INVALID_EMAIL_FORMAT";

        // 6자리 코드 + 5분 만료
        String code = String.format("%06d", new SecureRandom().nextInt(1_000_000));
        long   exp  = System.currentTimeMillis() + 5 * 60 * 1000;

        // 세션에 저장(이메일별 key로 저장)
        session.setAttribute("emailCode:" + mailAddr, code);
        session.setAttribute("emailCodeExp:" + mailAddr, exp);

        try {
            // 메일 작성/발송
            SimpleMailMessage msg = new SimpleMailMessage();

            // 네이버 SMTP는 from 이 로그인 계정과 동일해야 함
            String from = (mailSender instanceof JavaMailSenderImpl)
                    ? ((JavaMailSenderImpl) mailSender).getUsername()
                    : "com0494@naver.com";

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

    // ============ 2) 인증코드 검증 ============
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

        // 검증 완료 표시 (가입 시 이 값으로 확인)
        session.setAttribute("emailVerified", mailAddr);
        return "OK";
    }

    // ============ 3) 회원가입 처리 (세션 검증 필수) ============
    @PostMapping("/register.do")
    public String register(@ModelAttribute MemberDTO dto,
                           RedirectAttributes ra,
                           HttpSession session) throws Exception {

        // 세션에 검증된 이메일이 있어야 가입 허용
        String verifiedEmail = (String) session.getAttribute("emailVerified");
        if (verifiedEmail == null || !verifiedEmail.equalsIgnoreCase(dto.getMailAddr())) {
            ra.addFlashAttribute("message", "이메일 인증을 먼저 완료하세요.");
            return "redirect:/member/register.do";
        }

        // DB에는 인증완료로 저장(토큰은 안쓰므로 null)
        dto.setEmailAuthYn("Y");
        dto.setEmailAuthToken(null);

        int result = memberService.register(dto);

        // 세션 정리
        session.removeAttribute("emailCode:" + dto.getMailAddr());
        session.removeAttribute("emailCodeExp:" + dto.getMailAddr());
        session.removeAttribute("emailVerified");

        ra.addFlashAttribute("message", result == 1 ? "회원가입 성공!" : "회원가입 실패!");
        return "redirect:" + (result == 1 ? "/member/login.do" : "/member/register.do");
    }

    // ============ 로그인 처리 ============
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
