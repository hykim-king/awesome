package com.pcwk.ehr.admin.controller;

import java.util.*;
import java.util.regex.*;
import java.util.stream.Collectors;
import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.pcwk.ehr.admin.service.AdminMemberService;
import com.pcwk.ehr.article.domain.ArticleDTO;
import com.pcwk.ehr.article.domain.ArticleSearchDTO;
import com.pcwk.ehr.article.service.ArticleService;
import com.pcwk.ehr.chatmessage.domain.ChatMessageDTO;
import com.pcwk.ehr.mapper.ChatMessageMapper;
import com.pcwk.ehr.mapper.ReportMapper;
import com.pcwk.ehr.member.domain.MemberDTO;
import com.pcwk.ehr.report.domain.ReportDTO;
import com.pcwk.ehr.report.domain.ReportSearchDTO;
import com.pcwk.ehr.report.service.ReportService;


	@Controller
	@RequestMapping("/admin")
	public class AdminController {

	    private static final Logger log = LogManager.getLogger(AdminController.class);

	    @Autowired private ReportService reportService;
	    @Autowired private AdminMemberService adminMemberService;
	    @Autowired private ArticleService articleService;
	    @Autowired private ReportMapper reportMapper;
	    @Autowired private ChatMessageMapper chatMessageMapper;

	    // ─────────────────────────────────────────
	    // UI 상태 → DB 상태 매핑
	    // ─────────────────────────────────────────
	    private String mapToDbStatus(String status) {
	        if (status == null) return "RECEIVED";
	        switch (status.toUpperCase()) {
	            case "DONE":
	            case "COMP":
	            case "RESOLVED": return "RESOLVED";
	            case "REVIEWING":
	            case "RECEIVED":
	            default: return "RECEIVED";
	        }
	    }

	    // ─────────────────────────────────────────
	    // 대시보드
	    // ─────────────────────────────────────────
	    @GetMapping("/dashboard.do")
	    public String dashboard() { return "admin/dashboard"; }

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

	    /**
	     * 등급 배치 수정(배열 파라미터 버전)
	     * - userIds=a&userIds=b&grades=0&grades=1 처럼 반복 전송
	     */
	    @PostMapping("/members/gradeBatch.do")
	    public String updateGradesBatch(
	            @RequestParam(value="userIds", required=false) List<String> userIds,
	            @RequestParam(value="grades",  required=false) List<Integer> grades,
	            @RequestParam(defaultValue="1") int page,
	            @RequestParam(defaultValue="10") int size,
	            RedirectAttributes ra) {

	        log.info(">>> [POST] /admin/members/gradeBatch.do (array version)");
	        log.info("userIds={}, grades={}", userIds, grades);

	        if (userIds == null || grades == null ||
	            userIds.isEmpty() || grades.isEmpty() ||
	            userIds.size() != grades.size()) {
	            ra.addFlashAttribute("error", "선택된 회원이 없거나 파라미터가 비었습니다.");
	            return "redirect:/admin/members.do?page=" + page + "&size=" + size;
	        }

	        int success = 0, fail = 0;
	        for (int i = 0; i < userIds.size(); i++) {
	            String userId = userIds.get(i);
	            Integer grade  = grades.get(i);
	            try {
	                adminMemberService.updateGrade(userId, grade);
	                success++;
	            } catch (Exception e) {
	                fail++;
	                log.error("[gradeBatch] update fail userId={}, grade={}", userId, grade, e);
	            }
	        }

	        String msg = String.format("등급 변경 완료: %d건 성공, %d건 실패", success, fail);
	        ra.addFlashAttribute(fail == 0 ? "message" : "error", msg);
	        return "redirect:/admin/members.do?page=" + page + "&size=" + size;
	    }

	    // 삭제(다건)
	    @PostMapping("/member/delete.do")
	    public String deleteManyMembers(@RequestParam("ids") List<String> ids,
	                                    RedirectAttributes ra) {
	        int n = adminMemberService.deleteMany(ids);
	        ra.addFlashAttribute("message", n + "명 삭제 완료");
	        return "redirect:/admin/members.do";
	    }

    // ─────────────────────────────────────────
    // 기사 관리
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

        model.addAttribute("page", pageNum);
        model.addAttribute("size", pageSize);
        model.addAttribute("last", Math.max(1, totalPage));

        model.addAttribute("field",   effectiveField);
        model.addAttribute("keyword", effectiveKeyword);
        model.addAttribute("category", s.getCategory());
        model.addAttribute("dateFilter", dateFilter);

        return "admin/articles";
    }

    @PostMapping("/article/delete.do")
    public String deleteArticles(@RequestParam("ids") List<Long> ids, RedirectAttributes ra) {
        if (ids == null || ids.isEmpty()) {
            ra.addFlashAttribute("msg", "삭제할 항목을 선택하세요.");
            return "redirect:/admin/articles.do";
        }
        int n = articleService.deleteMany(ids);
        ra.addFlashAttribute("msg", n + "건 삭제했습니다.");
        return "redirect:/admin/articles.do";
    }

    // ─────────────────────────────────────────
    // 신고 관리
    // ─────────────────────────────────────────
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

        Map<Integer, String> chatContent = new HashMap<>();
        for (ReportDTO r : rows) {
            String content = "";
            try {
                ChatMessageDTO cm = chatMessageMapper.doSelectOne(r.getChatCode());
                if (cm != null && cm.getMessage() != null) {
                    content = cm.getMessage();
                }
            } catch (Exception e) {
                log.warn("채팅 본문 조회 실패 chatCode={}", r.getChatCode(), e);
            }
            chatContent.put(r.getReportCode(), content);
        }

        model.addAttribute("rows", rows);
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("last", last);
        model.addAttribute("field", field);
        model.addAttribute("keyword", keyword);
        model.addAttribute("chatContent", chatContent);
        return "admin/report";
    }

    /** 신고 상태 변경(단건) */
    @PostMapping("/report/status.do")
    public String reportStatus(@RequestParam int reportCode,
                               @RequestParam String status,
                               @RequestParam(defaultValue="1") int page,
                               @RequestParam(defaultValue="10") int size,
                               RedirectAttributes ra) throws Exception {

        String dbStatus = mapToDbStatus(status);
        int n = reportMapper.doUpdateStatus(reportCode, dbStatus);

        if ("RESOLVED".equals(dbStatus)) {
            Integer chatCode = reportMapper.getChatCodeByReport(reportCode);
            if (chatCode != null) chatMessageMapper.hideMessage(chatCode);
        }

        ra.addFlashAttribute("message", n==1 ? "상태가 변경되었습니다." : "대상이 없습니다.");
        return "redirect:/admin/report.do?page="+page+"&size="+size;
    }

    /** 신고 단건 삭제 */
    @PostMapping("/report/deleteOne.do")
    public String reportDeleteOne(@RequestParam("reportCode") int reportCode,
                                  @RequestParam(defaultValue = "1") int page,
                                  @RequestParam(defaultValue = "10") int size,
                                  RedirectAttributes ra) throws Exception {
        int n = reportService.doDelete(reportCode);
        ra.addFlashAttribute("message", n == 1 ? "삭제되었습니다." : "삭제할 항목을 찾지 못했습니다.");
        return "redirect:/admin/report.do?page=" + page + "&size=" + size;
    }

    /** 신고 선택 삭제 */
    @PostMapping("/reports/batchUpdate.do")
    public String batchUpdate(HttpServletRequest req,
                              @RequestParam(defaultValue = "1")  int page,
                              @RequestParam(defaultValue = "10") int size,
                              RedirectAttributes ra) {

        // 1) 정규식: updates[0].reportCode or updates[0].status 형태만 매칭
        Pattern p = Pattern.compile("^updates\\[(\\d+)]\\.(reportCode|status)$");

        // 임시 저장소(idx별로 merge)
        class ReportUpdate { Integer reportCode; String status; }
        Map<Integer, ReportUpdate> map = new HashMap<>();

        // 2) 파라미터 디버깅(필요 시 주석 해제)
        /*
        req.getParameterMap().forEach((k,vs) ->
                System.out.println("[PARAM] " + k + " = " + String.join(",", vs)));
        */

        // 3) 파싱
        req.getParameterMap().forEach((k, vs) -> {
            Matcher m = p.matcher(k);
            if (!m.matches()) return; // updates[] 같은 잡값 무시

            int idx    = Integer.parseInt(m.group(1)); // 캡처된 인덱스
            String fld = m.group(2);                   // reportCode 또는 status
            String val = (vs != null && vs.length > 0) ? vs[0] : null;

            ReportUpdate u = map.computeIfAbsent(idx, __ -> new ReportUpdate());
            if ("reportCode".equals(fld)) {
                try {
                    u.reportCode = Integer.valueOf(val);
                } catch (Exception ignore) {
                    // 무시: 잘못된 값은 skip
                }
            } else {
                u.status = val;
            }
        });

        // 4) 정렬 + 유효성 필터링
        List<ReportUpdate> list = map.entrySet().stream()
                .sorted(Map.Entry.comparingByKey())
                .map(Map.Entry::getValue)
                .filter(u -> u != null && u.reportCode != null) // reportCode는 필수
                .collect(Collectors.toList());

        if (list.isEmpty()) {
            ra.addFlashAttribute("message", "변경할 항목을 선택하세요.");
            return "redirect:/admin/report.do?page=" + page + "&size=" + size;
        }

        // 5) 업데이트 실행
        int success = 0;
        for (ReportUpdate u : list) {
            String dbStatus = mapToDbStatus(u.status);
            try {
                int n = reportMapper.doUpdateStatus(u.reportCode, dbStatus);
                if (n > 0) {
                    success += n;
                    // RESOLVED 된 경우, 관련 채팅 숨김 처리
                    if ("RESOLVED".equals(dbStatus)) {
                        Integer chatCode = reportMapper.getChatCodeByReport(u.reportCode);
                        if (chatCode != null) {
                            try {
                                chatMessageMapper.hideMessage(chatCode);
                            } catch (Exception e) {
                                log.warn("hideMessage 실패 chatCode={}", chatCode, e);
                            }
                        }
                    }
                }
            } catch (Exception e) {
                log.error("batchUpdate 실패 reportCode={}, status={}", u.reportCode, dbStatus, e);
            }
        }

        ra.addFlashAttribute("message", success + "건 상태 변경 완료");
        return "redirect:/admin/report.do?page=" + page + "&size=" + size;
    }
}