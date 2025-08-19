package com.pcwk.ehr.report.controller;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.pcwk.ehr.report.service.ReportService;

@Controller
@RequestMapping("/report")
public class ReportController {
	
	Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	ReportService service;
	
	

}
