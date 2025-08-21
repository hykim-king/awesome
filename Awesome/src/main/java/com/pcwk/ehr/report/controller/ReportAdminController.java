package com.pcwk.ehr.report.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pcwk.ehr.report.domain.ReportDTO;
import com.pcwk.ehr.report.domain.ReportSearchDTO;
import com.pcwk.ehr.report.service.ReportService;

public class ReportAdminController {

	@Autowired
	private ReportService reportService;

	@GetMapping(value = "/list", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> list(ReportSearchDTO cond) throws Exception {
		cond.recalc();
		List<ReportDTO> rows = reportService.doRetrieve(cond);
		int total = reportService.getCount(cond);
		Map<String, Object> res = new HashMap<>();
		res.put("rows", rows);
		res.put("total", total);
		res.put("pageNo", cond.getPageNo());
		res.put("pageSize", cond.getPageSize());
		return res;
	}

	// HashMap : key-value 값을 여러개 담을 수 있음. ex: reuslt.put 안에 있는 응답 외에 추가할꺼면 ok
	// SingletonMap : key-value 값 하나밖에 못담음. 코드가 안전하고 깔끔하긴함

	@PatchMapping(value = "/{reportCode}/status", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> doUpdateStatus(@PathVariable int reportCode, @RequestParam String status)
			throws Exception {
		int u = reportService.doUpdateStatus(reportCode, status);

		Map<String, Object> result = new HashMap<>();
		result.put("ok", u == 1);

		return result;
	}

	@DeleteMapping(value = "/{reportCode}", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> doDelete(@PathVariable int reportCode) throws Exception {
		int d = reportService.doDelete(reportCode);

		Map<String, Object> result = new HashMap<>();
		result.put("ok", d == 1);
		
		return result;
	}
}
