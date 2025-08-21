package com.pcwk.ehr.report.controller;

import java.security.Principal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pcwk.ehr.report.domain.ReportDTO;
import com.pcwk.ehr.report.domain.ReportSearchDTO;
import com.pcwk.ehr.report.service.ReportService;

@Controller
public class ReportController {

	Logger log = LogManager.getLogger(getClass());

	@Autowired
	ReportService service;

	@PostMapping(value = "/report", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)

	@ResponseBody
	public Map<String, Object> create(@RequestBody ReportDTO dto, Principal principal) throws SQLException {
		Map<String, Object> res = new HashMap<>();

		if (dto == null) {
			res.put("Ok", false);
			res.put("message", "요청 본문이 비었습니다.");
			return res;
		}
		if (dto.getChatCode() <= 0) {
			res.put("ok", false);
			res.put("message", "대상 채팅 코드가 유효하지 않습니다.");
			return res;
		}
		if (dto.getReason() == null || dto.getReason().trim().isEmpty()) {
			res.put("ok", false);
			res.put("message", "신고 사유를 선택하세요.");
			return res;
		}
		return res;
	}
		
	    /** 마이페이지: 내 신고 목록 페이징 조회 
	     * @throws Exception */
	    @GetMapping(value = "/my/report/list", produces = MediaType.APPLICATION_JSON_VALUE)
	    @ResponseBody
	    public Map<String, Object> myReports(ReportSearchDTO cond, Principal principal) throws Exception {
	        // 내 것만
	        if (principal != null && principal.getName() != null) {
	            cond.setUserId(principal.getName());
	        }
	        // 컨트롤러에서도 보정(서비스에서도 다시 보정함)
	        cond.recalc();

	        List<ReportDTO> rows = service.doRetrieve(cond);
	        int total = service.getCount(cond); // 현재 getCount() 전체 건수. 조건 카운트가 필요하면 전용 쿼리 추가

	        Map<String, Object> res = new HashMap<>();
	        res.put("rows", rows);
	        res.put("total", total);
	        res.put("pageNo", cond.getPageNo());
	        res.put("pageSize", cond.getPageSize());
	        return res;
		
	}


}
