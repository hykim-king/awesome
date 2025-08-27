package com.pcwk.ehr.widget.controller;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pcwk.ehr.dict.domain.DictionaryDTO;       // 네이버 응답 DTO (원본)
import com.pcwk.ehr.dict.domain.DictionaryItemDTO;  // 프런트 전용 DTO (term/summary/link)
import com.pcwk.ehr.dict.service.DictionaryService;

@Controller
@RequestMapping("/widget")
public class DictionaryWidgetController {

    Logger log = LogManager.getLogger(getClass());

    private final DictionaryService dictionaryService;

    @Autowired
    public DictionaryWidgetController(DictionaryService dictionaryService) {
        this.dictionaryService = dictionaryService;
    }

    /** 단독 확인용 뷰(.do 중요!) */
    @GetMapping("/dict.do")
    public String dictWidget() {
        // /WEB-INF/views/widget/dict.jsp
        return "widget/dict";
    }

    /** AJAX 검색 (.do 유지) */
    @ResponseBody
    @GetMapping(value = "/dict/search.do", produces = "application/json; charset=UTF-8")
    public List<DictionaryItemDTO> search(@RequestParam("query") String query) {
        String q = (query == null) ? "" : query.trim();
        if (q.isEmpty()) {
            return Collections.emptyList();
        }

        try {
            // 네이버 API: 최대 5건만 요청
            DictionaryDTO apiResult = dictionaryService.search(q, 5, 1);

            if (apiResult == null || apiResult.getItems() == null) {
                return Collections.emptyList();
            }

            // 원본 items → 화면 전용 DTO로 변환
            return apiResult.getItems().stream()
                    .limit(5)
                    .map(it -> new DictionaryItemDTO(
                            stripTags(it.getTitle()),        // term
                            stripTags(it.getDescription()),  // summary
                            it.getLink()                     // link
                    ))
                    .collect(Collectors.toList());

        } catch (Exception e) {
            log.error("사전 검색 실패: {}", e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /** 헬스체크 (브라우저: /ehr/widget/dict/ping.do) */
    @ResponseBody
    @GetMapping("/dict/ping.do")
    public String ping() {
        return "OK-DICT";
    }

    /** 간단 태그/엔티티 제거 */
    private String stripTags(String s) {
        if (s == null) return "";
        return s.replaceAll("<[^>]*>", "")
                .replace("&quot;", "\"")
                .replace("&amp;", "&")
                .replace("&lt;", "<")
                .replace("&gt;", ">");
    }
}