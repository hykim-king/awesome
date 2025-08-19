package com.pcwk.ehr.report.controller;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.pcwk.ehr.report.service.ReportService;

@Controller
@RequestMapping("/report")
public class ReportController {
	
	Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	ReportService service;
	
	//공백 제거(중간에 있는 거 제외)
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		binder.registerCustomEditor(String.class, new StringTrimmerEditor(true));
	}
	
	//신고 모달
	@RequestMapping(value = "/open.do", method = RequestMethod.GET)
	public String open(
			@RequestParam("chatCode") long chatCode,
			@RequestParam("ctId") String ctId,
			@RequestParam("writer") String writerMasked,
			@RequestParam("preview") String preview,
			@RequestParam("reason") int reason,
			@RequestParam(value = "userId", required = false) String reportId,
			Model model) {
		
		model.addAttribute("chatCode",chatCode);
		model.addAttribute("ctId",ctId);
		model.addAttribute("writer",writerMasked);
		model.addAttribute("preview",preview);
		model.addAttribute("reportId",reportId);
		
		model.addAttribute("reason",reason);
		
		return "report/write";
		
	}

}
