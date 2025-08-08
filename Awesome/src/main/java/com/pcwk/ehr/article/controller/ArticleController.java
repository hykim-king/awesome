package com.pcwk.ehr.article.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.pcwk.ehr.article.domain.ArticleDTO;
import com.pcwk.ehr.article.domain.ArticleSearchDTO;
import com.pcwk.ehr.article.service.ArticleService;
import com.pcwk.ehr.cmn.SearchDTO;

@Controller
@RequestMapping("/article")
public class ArticleController {
	
	@Autowired
	ArticleService service;
	
	//검색
	@GetMapping("/list.do")
	public String articleList(@RequestParam(value = "searchDiv", required = false) String searchDiv,
							@RequestParam(value = "searchWord", required = false) String searchWord,
							Model model) throws Exception {
		
		//검색 조건 설정
		ArticleSearchDTO search = new ArticleSearchDTO();
		search.setSearchDiv(searchDiv);
		search.setSearchWord(searchWord);
		
		//기사 조회
		List<ArticleDTO> list = service.doRetrieve(search);
		
		//결과 전달
		model.addAttribute("list", list);
		model.addAttribute("searchDiv", searchDiv);
		model.addAttribute("searchWord", searchWord);
						
		return "article/list";
	}
	
	@GetMapping("/category.do")
	public String categoryByArticleList(@RequestParam("category") int category,
										Model model) throws Exception {
		ArticleSearchDTO search = new ArticleSearchDTO();
		search.setCategory(category);
		
		List<ArticleDTO> list = service.doRetrieve(search);
		
		model.addAttribute("list", list);
		model.addAttribute("category", category);
		
		
		return "article/list";
	}
	

}
