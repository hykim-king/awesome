package com.pcwk.ehr.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pcwk.ehr.admin.service.AdminMemberService;
import com.pcwk.ehr.member.domain.MemberDTO;

import com.pcwk.ehr.report.domain.ReportDTO;
import com.pcwk.ehr.report.domain.ReportSearchDTO;
import com.pcwk.ehr.report.service.ReportService;

import com.pcwk.ehr.article.domain.ArticleDTO;
import com.pcwk.ehr.article.domain.ArticleSearchDTO;
import com.pcwk.ehr.article.service.ArticleService;

// ★ 팀원 코드 그대로: 채팅 본문 조회용
import com.pcwk.ehr.mapper.ChatMessageMapper;
import com.pcwk.ehr.mapper.ReportMapper;
import com.pcwk.ehr.chatmessage.domain.ChatMessageDTO;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private static final Logger log = LogManager.getLogger(AdminController.class);

    @Autowired private ReportService reportService;
    @Autowired private AdminMemberService adminMemberService;
    @Autowired private ArticleService articleService;
    @Autowired private ReportMapper reportMapper;   // ★ 없으면 추가
    

    // ★ 채팅 본문 가져오기용(팀원 코드 사용)
    @Autowired private ChatMessageMapper chatMessageMapper;

    // ─────────────────────────────────────────
    // 대시보드
    // ─────────────────────────────────────────
    @GetMapping("/dashboard.do")
    public String dashboard() {
        return "admin/dashboard";
    }

    // ─────────────────────────────────────────
    // 회원 관리
    // ─────────────────────────────────────────
    @GetMapping("/members.do")
    public String members(@RequestParam(defaultValue = "1") int page,
                          @RequestParam(defaultValue = "10") int size,
                          @RequestParam(required = false) String type,
                          @RequestParam(required = false) String keyword,
                          @RequestParam(required = false) Integer grade,
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

    @PostMapping("/member/grade.do")
    public String updateGrade(@RequestParam String userId,
                              @RequestParam int grade,
                              RedirectAttributes ra) {
        adminMemberService.updateGrade(userId, grade);
        ra.addFlashAttribute("message", "등급 변경 완료");
        return "redirect:/admin/members.do";
    }

    @PostMapping("/member/delete.do")
    public String deleteManyMembers(@RequestParam("ids") List<String> ids,
                                    RedirectAttributes ra) {
        int n = adminMemberService.deleteMany(ids);
        ra.addFlashAttribute("message", n + "명 삭제 완료");
        return "redirect:/admin/members.do";
    }

 // ─────────────────────────────────────────
 // 기사 관리 (폼: field/keyword 사용)
 // ─────────────────────────────────────────
    @GetMapping("/articles.do")
    public String articles(
            @RequestParam(value = "field",     required = false) String field,
            @RequestParam(value = "keyword",   required = false) String keyword,
            @RequestParam(value = "searchDiv", required = false) String searchDiv,
            @RequestParam(value = "searchWord",required = false) String searchWord,
            @RequestParam(value = "category",  required = false) Integer category,
            @RequestParam(value = "dateFilter",required = false) String dateFilter,
            @RequestParam(value = "pageNum",   defaultValue = "1")  int pageNum,
            @RequestParam(value = "pageSize",  defaultValue = "10") int pageSize,
            Model model) throws Exception {

        String effectiveField   = (field   != null) ? field   : searchDiv;
        String effectiveKeyword = (keyword != null) ? keyword : searchWord;

        ArticleSearchDTO s = new ArticleSearchDTO();
        s.setSearchDiv(effectiveField);
        s.setSearchWord(effectiveKeyword);

        if ("category".equalsIgnoreCase(effectiveField) && effectiveKeyword != null && !effectiveKeyword.trim().isEmpty()) {
            try { s.setCategory(Integer.parseInt(effectiveKeyword.trim())); } catch (NumberFormatException ignore) {}
        }
        if (category != null) s.setCategory(category);
        if (dateFilter != null && !dateFilter.isEmpty()) s.setDateFilter(dateFilter);

        int startRow = (pageNum - 1) * pageSize + 1;
        int endRow   = pageNum * pageSize;
        s.setStartRow(startRow);
        s.setEndRow(endRow);

        int totalCount = articleService.getCount(s);
        int totalPage  = (totalCount + pageSize - 1) / pageSize;
        List<ArticleDTO> rows = articleService.doRetrieve(s);

        model.addAttribute("rows", rows);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("pageNum", pageNum);
        model.addAttribute("pageSize", pageSize);

        // JSP 호환용(다른 페이지들과 동일 키)
        model.addAttribute("page", pageNum);
        model.addAttribute("size", pageSize);
        model.addAttribute("last", Math.max(1, totalPage));

        model.addAttribute("field",   effectiveField);
        model.addAttribute("keyword", effectiveKeyword);
        model.addAttribute("category", s.getCategory());
        model.addAttribute("dateFilter", dateFilter);

        return "admin/articles";
        
    }
    
    
    // 선택 삭제(다건) — 서비스에 deleteMany 없으므로 반복 호출
    @PostMapping("/articles/delete.do")
    public String articlestDelete(@RequestParam("ids") List<Integer> ids,
                               @RequestParam(defaultValue = "1") int page,
                               @RequestParam(defaultValue = "10") int size,
                               RedirectAttributes ra) throws Exception {
        int success = 0;
        if (ids != null) {
            for (Integer id : ids) {
                if (id == null) continue;
                try {
                    success += reportService.doDelete(id);
                } catch (Exception e) {
                    log.error("기사 삭제 실패 reportCode={}", id, e);
                }
            }
        }
        ra.addFlashAttribute("message", success + "건 삭제되었습니다.");
      
       return "redirect:/admin/articles.do";
    
    
       
    }


    // ─────────────────────────────────────────
    // 신고 관리
    // ─────────────────────────────────────────

    // 목록/검색/페이징 (+ 채팅 본문 맵 제작)
    @GetMapping("/report.do")
    public String report(@RequestParam(defaultValue = "1")  int page,
                         @RequestParam(defaultValue = "10") int size,
                         @RequestParam(required = false) String field,
                         @RequestParam(required = false) String keyword,
                         Model model) throws Exception {

        ReportSearchDTO cond = new ReportSearchDTO();
        cond.setPageNo(page);
        cond.setPageSize(size);

        if (keyword != null && !keyword.isEmpty()) {
            switch (field == null ? "" : field) {
                case "reporterId": cond.setUserId(keyword); break; // 신고자 ID
                case "targetId"  : cond.setCtId(keyword);   break; // 신고 대상 ID
                default          : cond.setSearchWord(keyword);
            }
        }

        cond.recalc();

        List<ReportDTO> rows = reportService.doRetrieve(cond);
        int total = reportService.getCount(cond);
        int last  = Math.max(1, (int)Math.ceil((double) total / size));

        // ★ 채팅 본문 Map (key = reportCode)
        Map<Integer, String> chatContent = new HashMap<>(); // key = reportCode
        for (ReportDTO r : rows) {
            String content = "";
            try {
                ChatMessageDTO cm = chatMessageMapper.doSelectOne(r.getChatCode());
                if (cm != null && cm.getMessage() != null) {      // ✅ getMessage()
                    content = cm.getMessage();
                }
            } catch (Exception e) {
                log.warn("채팅 본문 조회 실패 chatCode={}", r.getChatCode(), e); // ✅ log.warn
            }
            chatContent.put(r.getReportCode(), content);
        }

        // 모델에 실기
        model.addAttribute("rows", rows);
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("last", last);
        model.addAttribute("field", field);
        model.addAttribute("keyword", keyword);
        model.addAttribute("chatContent", chatContent); 
        return "admin/report";
    }

    // 상태 변경(단건) — 팀 서비스 시그니처에 맞게
    @PostMapping("/report/status.do")
    public String reportStatus(@RequestParam int reportCode,
                               @RequestParam String status,
                               @RequestParam(defaultValue="1") int page,
                               @RequestParam(defaultValue="10") int size,
                               RedirectAttributes ra) throws Exception {
        // UI -> DB 값 매핑
        String dbStatus;
        switch (status) {
            case "DONE": case "COMP": case "RESOLVED":
                dbStatus = "RESOLVED"; break;
            case "RECEIVED": case "REVIEWING": default:
                dbStatus = "RECEIVED";
        }

        Map<String,Object> p = new HashMap<>();
        p.put("reportCode", reportCode);
        p.put("status", dbStatus); //  DB에 저장할 값으로 넣기
        int n = reportMapper.doUpdateStatus(p);

        // 채팅 숨김 처리도 RESOLVED 기준으로
        if ("RESOLVED".equals(status)) {
            Integer chatCode = reportMapper.getChatCodeByReport(reportCode);
            if (chatCode != null) chatMessageMapper.hideMessage(chatCode);
        }


        ra.addFlashAttribute("message", n==1 ? "상태가 변경되었습니다." : "대상이 없습니다.");
        return "redirect:/admin/report.do?page="+page+"&size="+size;
        }

    // 단건 삭제(행별)
    @PostMapping("/report/deleteOne.do")
    public String reportDeleteOne(@RequestParam("reportCode") int reportCode,
                                  @RequestParam(defaultValue = "1") int page,
                                  @RequestParam(defaultValue = "10") int size,
                                  RedirectAttributes ra) throws Exception {
        int n = reportService.doDelete(reportCode);
        ra.addFlashAttribute("message", n == 1 ? "삭제되었습니다." : "삭제할 항목을 찾지 못했습니다.");
        return "redirect:/admin/report.do?page=" + page + "&size=" + size;
    }

    // 선택 삭제(다건) — 서비스에 deleteMany 없으므로 반복 호출
    @PostMapping("/report/delete.do")
    public String reportDelete(@RequestParam("ids") List<Integer> ids,
                               @RequestParam(defaultValue = "1") int page,
                               @RequestParam(defaultValue = "10") int size,
                               RedirectAttributes ra) throws Exception {
        int success = 0;
        if (ids != null) {
            for (Integer id : ids) {
                if (id == null) continue;
                try {
                    success += reportService.doDelete(id);
                } catch (Exception e) {
                    log.error("신고 삭제 실패 reportCode={}", id, e);
                }
            }
        }
        ra.addFlashAttribute("message", success + "건 삭제되었습니다.");
        return "redirect:/admin/report.do?page=" + page + "&size=" + size;
    }
}
