package com.pcwk.ehr.report.controller;

import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.pcwk.ehr.report.domain.ReportDTO;
import com.pcwk.ehr.report.domain.ReportSearchDTO;
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
	
	//신고 목록
	@GetMapping("/list.do")
	public String list(ReportSearchDTO search, Model model) throws Exception {
		
		log.debug("list():{}",search);
		List<ReportDTO> list = service.doRetrieve(search);
		int totalCnt = service.getCount(search);
		
		model.addAttribute("list",list);
		model.addAttribute("search",search);
		model.addAttribute("totalCnt",totalCnt);
		
		return "report/list";
	}
	

}
