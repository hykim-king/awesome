package com.pcwk.ehr.Intro.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/intro")
public class IntroController {
	
	@GetMapping("/hotissue.do")
	public String hotIssueIntro() {
		return "intro/hotissue_intro";
	}

}
