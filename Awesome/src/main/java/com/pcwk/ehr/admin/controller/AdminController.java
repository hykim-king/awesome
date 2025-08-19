package com.pcwk.ehr.admin.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pcwk.ehr.admin.service.AdminMemberService;
import com.pcwk.ehr.member.domain.MemberDTO;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminMemberService adminMemberService;

    // 관리자 메인
    @GetMapping("/dashboard.do")
    public String dashboard() {
        return "admin/dashboard";
    }

    // 회원 관리: 목록/검색/페이징
    @GetMapping("/members.do")
    public String members(@RequestParam(defaultValue = "1") int page,
                          @RequestParam(defaultValue = "10") int size,
                          @RequestParam(required = false) String type,     // id | nick
                          @RequestParam(required = false) String keyword,
                          @RequestParam(required = false) Integer grade,   // 0=관리자, 1=사용자
                          Model model) {

        int total = adminMemberService.count(type, keyword, grade);
        List<MemberDTO> rows = adminMemberService.list(type, keyword, grade, page, size);
        int last = Math.max(1, (int)Math.ceil((double) total / size));

        model.addAttribute("rows", rows);
        model.addAttribute("total", total);
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("type", type);
        model.addAttribute("keyword", keyword);
        model.addAttribute("grade", grade);
        model.addAttribute("last", last);
        return "admin/members";
    }

    // 회원 등급 변경
    @PostMapping("/member/grade.do")
    public String updateGrade(@RequestParam String userId,
                              @RequestParam int grade,
                              RedirectAttributes ra) {
        adminMemberService.updateGrade(userId, grade);
        ra.addFlashAttribute("message", "등급 변경 완료");
        return "redirect:/admin/members.do";
    }

    // 회원 선택 삭제
    @PostMapping("/member/delete.do")
    public String deleteMany(@RequestParam("ids") java.util.List<String> ids,
                             RedirectAttributes ra) {
        int n = adminMemberService.deleteMany(ids);
        ra.addFlashAttribute("message", n + "명 삭제 완료");
        return "redirect:/admin/members.do";
    }

    // 기사 관리 (뼈대)
    @GetMapping("/articles.do")
    public String articles() { return "admin/articles"; }

    // 신고 관리 (뼈대)
    @GetMapping("/reports.do")
    public String reports() { return "admin/reports"; }
}
