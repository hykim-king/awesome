package com.pcwk.ehr.member.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pcwk.ehr.member.domain.MemberDTO;
import com.pcwk.ehr.member.service.MemberService;

@Controller
@RequestMapping("/member")
public class MemberController {

    private final Logger log = LogManager.getLogger(getClass());

    @Value("${app.devBackdoor:false}")
    private boolean devBackdoor;

    @PostConstruct
    public void init() { log.info("devBackdoor = {}", devBackdoor); }

    @Autowired
    private MemberService memberService;

    /* ===== Views ===== */
    @GetMapping("/register.do") public String registerForm() { return "member/register"; }
    @GetMapping("/login.do")    public String loginForm()    { return "member/login"; }

    /* ===== Logout ===== */
    @GetMapping("/logout.do")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/mainPage/main.do";
    }
    
    /* ===== Logout admin ===== */
    @RequestMapping(value = "/member/logout.do", method = {RequestMethod.GET, RequestMethod.POST})
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();   // 세션 종료
        return "redirect:/";                          // 컨텍스트 루트(= 메인)로 이동
    }

    

    /* ===== ID/Nick Duplicate ===== */
    @GetMapping(value="/checkId.do", produces="text/plain; charset=UTF-8")
    @ResponseBody
    public String checkId(@RequestParam String userId) throws Exception {
        return memberService.existsById(userId) ? "DUP" : "OK";
    }

    @GetMapping(value="/checkNick.do", produces="text/plain; charset=UTF-8")
    @ResponseBody
    public String checkNick(@RequestParam String nickNm) throws Exception {
        return memberService.existsByNick(nickNm) ? "DUP" : "OK";
    }

    /* ===== Email: send code (with duplicate check) ===== */
    @PostMapping(value="/email/sendCode.do", produces="application/json; charset=UTF-8")
    @ResponseBody
    public Map<String,Object> sendEmailCode(@RequestParam String mailAddr,
                                            HttpSession session) throws Exception {
        Map<String,Object> res = new HashMap<>();
        String email = mailAddr == null ? "" : mailAddr.trim();

        if (memberService.existsByEmail(email)) {
            res.put("ok", false);
            res.put("reason", "DUPLICATE_EMAIL");
            res.put("message", "이미 가입된 이메일입니다.");
            return res;
        }

        String code = memberService.sendEmailCode(email);
        if (code == null) {
            res.put("ok", false);
            res.put("reason", "SEND_FAIL");
            res.put("message", "인증 메일 발송에 실패했습니다.");
            return res;
        }

        long exp = System.currentTimeMillis() + 10 * 60 * 1000L;
        session.setAttribute("emailCode:" + email, code);
        session.setAttribute("emailCodeExp:" + email, exp);

        res.put("ok", true);
        res.put("message", "인증 코드가 이메일로 발송되었습니다. 10분 내 입력하세요.");
        return res;
    }

    /* ===== Email: verify code ===== */
    @PostMapping(value="/email/verifyCode.do", produces="application/json; charset=UTF-8")
    @ResponseBody
    public Map<String,Object> verifyEmailCode(@RequestParam String mailAddr,
                                              @RequestParam String code,
                                              HttpSession session) {
        Map<String,Object> res = new HashMap<>();
        String email = mailAddr == null ? "" : mailAddr.trim();

        String key = "emailCode:" + email;
        String keyExp = "emailCodeExp:" + email;
        Object saved = session.getAttribute(key);
        Object exp   = session.getAttribute(keyExp);

        if (saved == null || exp == null) {
            res.put("ok", false); res.put("reason","NO_CODE");
            res.put("message","인증 코드를 먼저 발송해 주세요.");
            return res;
        }

        long expireAt = (Long) exp;
        if (System.currentTimeMillis() > expireAt) {
            session.removeAttribute(key); session.removeAttribute(keyExp);
            res.put("ok", false); res.put("reason","EXPIRED");
            res.put("message","인증 코드가 만료되었습니다. 다시 발송해 주세요.");
            return res;
        }

        if (!((String) saved).equals(code)) {
            res.put("ok", false); res.put("reason","MISMATCH");
            res.put("message","인증 코드가 일치하지 않습니다.");
            return res;
        }

        session.setAttribute("emailVerified:" + email, true);
        res.put("ok", true); res.put("message","이메일 인증이 완료되었습니다.");
        return res;
    }

    /* ===== Register ===== */
    @PostMapping("/register.do")
    public String registerSubmit(@ModelAttribute MemberDTO dto,
                                 RedirectAttributes ra,
                                 HttpSession session) {
        try {
            Object ok = session.getAttribute("emailVerified:" + dto.getMailAddr());
            if (!(ok instanceof Boolean) || !((Boolean) ok)) {
                ra.addFlashAttribute("error", "이메일 인증을 완료해 주세요.");
                ra.addFlashAttribute("form", dto);
                return "redirect:/member/register.do";
            }

            dto.setEmailAuthYn("Y");
            dto.setEmailAuthToken(null);

            memberService.register(dto);

            session.removeAttribute("emailVerified:" + dto.getMailAddr());
            session.removeAttribute("emailCode:" + dto.getMailAddr());
            session.removeAttribute("emailCodeExp:" + dto.getMailAddr());

            ra.addFlashAttribute("message", "회원가입 성공! (이메일 인증 완료)");
            return "redirect:/member/login.do";
        } catch (IllegalArgumentException e) {
            ra.addFlashAttribute("error", e.getMessage());
            ra.addFlashAttribute("form", dto);
            return "redirect:/member/register.do";
        } catch (Exception e) {
            ra.addFlashAttribute("error", "처리 중 오류가 발생했습니다.");
            ra.addFlashAttribute("form", dto);
            return "redirect:/member/register.do";
        }
    }

    /* ===== Token verify (optional) ===== */
    @GetMapping("/verifyEmail")
    public String verifyEmail(@RequestParam("token") String token, Model model) throws Exception {
        boolean ok = memberService.verifyEmailToken(token);
        model.addAttribute("verified", ok);
        return "member/emailResult";
    }

    /* ===== Login ===== */
    @PostMapping("/login.do")
    public String login(@ModelAttribute MemberDTO dto,
                        HttpSession session,
                        RedirectAttributes ra) throws SQLException {

        if (devBackdoor && "admin".equals(dto.getUserId()) && "admin123".equals(dto.getPwd())) {
            MemberDTO admin = new MemberDTO();
            admin.setUserId("admin");
            admin.setUserNm("관리자");
            admin.setUserGradeCd(0);
            session.setAttribute("loginUser", admin);
            session.setAttribute("userGradeCd", 0);
            ra.addFlashAttribute("message", "관리자로 로그인되었습니다.");
            return "redirect:/admin/dashboard.do";
        }

        MemberDTO loginUser = memberService.login(dto);
        if (loginUser != null) {
            session.setAttribute("loginUser", loginUser);
            session.setAttribute("userGradeCd", loginUser.getUserGradeCd());
            ra.addFlashAttribute("message", loginUser.getUserId() + "님 로그인 성공!");
            if (Integer.valueOf(0).equals(loginUser.getUserGradeCd())) {
                return "redirect:/admin/dashboard.do";
            }
            return "redirect:/mainPage/main.do";
        } else {
            ra.addFlashAttribute("error", "로그인 실패. 아이디 또는 비밀번호를 확인해주세요.");
            return "redirect:/member/login.do";
        }
    }

    /* ===== Find ID/PW ===== */
    @GetMapping("/findId.do") public String findIdForm() { return "member/findId"; }

    @PostMapping("/findId.do")
    public String findId(@RequestParam String userNm,
                         @RequestParam String mailAddr,
                         Model model) throws SQLException {
        String userId = memberService.findUserId(userNm, mailAddr);
        model.addAttribute("foundId", userId == null ? null : mask(userId));
        model.addAttribute("submitted", true);
        return "member/findId";
    }

    @GetMapping("/findPwd.do") public String findPwdForm() { return "member/findPwd"; }

    @PostMapping("/findPwd.do")
    public String findPwd(@RequestParam String userId,
                          @RequestParam String mailAddr,
                          RedirectAttributes ra) {
        boolean ok = memberService.sendResetMail(userId, mailAddr);
        if (ok) ra.addFlashAttribute("message", "비밀번호 재설정 메일을 보냈습니다.");
        else     ra.addFlashAttribute("error", "일치하는 계정을 찾을 수 없습니다.");
        return "redirect:/member/login.do";
    }

    @GetMapping("/resetPwd.do")
    public String resetPwdForm(@RequestParam String token, Model model) {
        model.addAttribute("token", token);
        return "member/resetPwd";
    }

    @PostMapping("/resetPwd.do")
    public String resetPwdSubmit(@RequestParam String token,
                                 @RequestParam String newPwd,
                                 RedirectAttributes ra) throws SQLException {
        int updated = memberService.resetPassword(token, newPwd);
        if (updated == 1) {
            ra.addFlashAttribute("message", "비밀번호가 변경되었습니다. 로그인 해주세요.");
            return "redirect:/member/login.do";
        } else {
            ra.addFlashAttribute("error", "유효하지 않은 링크이거나 만료된 토큰입니다.");
            return "redirect:/member/findPwd.do";
        }
    }

    /* ===== Util ===== */
    private String mask(String id) {
        if (id == null || id.isEmpty()) return "";
        if (id.length() <= 3) return id.charAt(0) + "***";
        return id.substring(0, 3) + "****";
    }
}
