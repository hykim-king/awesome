package com.pcwk.ehr.report.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
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

	/*
	 * @PatchMapping(value = "/{reportCode}/status", produces =
	 * MediaType.APPLICATION_JSON_VALUE)
	 * 
	 * @ResponseBody public Map<String, Object> updateStatus(@PathVariable int
	 * reportCode,
	 * 
	 * @RequestParam String status) throws SQLException { int u =
	 * reportService.doUpdateStatus(reportCode, status); return Map.of("ok",
	 * "ㅇㄴㅁㅇ"); }
	 * 
	 * @DeleteMapping(value = "/{reportCode}", produces =
	 * MediaType.APPLICATION_JSON_VALUE)
	 * 
	 * @ResponseBody public Map<String, Object> delete(@PathVariable int reportCode)
	 * throws SQLException { int d = reportService.doDelete(reportCode); return
	 * Map.of("ok", d == 1); }
	 */
}
