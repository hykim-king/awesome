package com.pcwk.ehr.article.controller;

import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.pcwk.ehr.article.domain.ArticleDTO;
import com.pcwk.ehr.article.domain.ArticleSearchDTO;
import com.pcwk.ehr.article.service.ArticleService;


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
	

	Logger log = LogManager.getLogger(getClass());


	// 페이징,검색 동시
	@GetMapping("/list.do")
	public String articleList(@RequestParam(value = "searchDiv", required = false) String searchDiv,
			@RequestParam(value = "searchWord", required = false) String searchWord,
			@RequestParam(value = "category", required = false) Integer category,
			@RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize, Model model) throws Exception {

		// 검색 조건 설정
		ArticleSearchDTO search = new ArticleSearchDTO();
		search.setSearchDiv(searchDiv);
		search.setSearchWord(searchWord);
		if (category != null) {
			search.setCategory(category);
		}
		
		int startRow = (pageNum -1) * pageSize+1;
		int endRow = pageNum * pageSize;
		search.setStartRow(startRow);
		search.setEndRow(endRow);
		
		log.debug("시작");
		// 기사 조회
		List<ArticleDTO> list = service.doRetrieve(search);

		// 결과 전달
		model.addAttribute("list", list);
		model.addAttribute("searchDiv", searchDiv);
		model.addAttribute("searchWord", searchWord);
		model.addAttribute("category",category);
		model.addAttribute("pageSize",pageSize);
		model.addAttribute("pageNum",pageNum);
		

		return "article/list";
	}


}
