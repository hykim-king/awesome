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

	Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	ArticleService service;	



	// 페이징,검색 동시
	@GetMapping("/list.do")
	public String articleList(@RequestParam(value = "searchDiv", required = false) String searchDiv,
			@RequestParam(value = "searchWord", required = false) String searchWord,
			@RequestParam(value = "category", required = false) Integer category,
			@RequestParam(value = "dateFilter", required = false) String dateFilter,
			@RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize, Model model) throws Exception {

		// 검색 조건 설정
		ArticleSearchDTO search = new ArticleSearchDTO();
		search.setSearchDiv(searchDiv);
		search.setSearchWord(searchWord);
		if (category != null) {
			search.setCategory(category);
		}
		if (dateFilter != null && !dateFilter.isEmpty()) {
			search.setDateFilter(dateFilter);
		}
		
		int startRow = (pageNum -1) * pageSize+1;
		int endRow = pageNum * pageSize;
		search.setStartRow(startRow);
		search.setEndRow(endRow);
		
		int totalCount = service.getCount(search);
		
		int totalPage = (totalCount+pageSize-1)/pageSize;
		
		int blockSize = 10;
		int currentBlk = (pageNum-1)/pageSize;
		int startPage = currentBlk*blockSize+1;
		int endPage = Math.min(startPage + blockSize-1, totalPage);
		
		log.debug("시작");
		// 기사 조회
		List<ArticleDTO> list = service.doRetrieve(search);
		
		int totalAll = service.getCountAll();
		
		log.debug("search={}, totalCount={}, pageNum={}, pageSize={}, startRow={}, endRow={}",
                search, totalCount, pageNum, pageSize, startRow, endRow);

		// 결과 전달
		model.addAttribute("list", list);
		model.addAttribute("searchDiv", searchDiv);
		model.addAttribute("searchWord", searchWord);
		model.addAttribute("category",category);
		model.addAttribute("dateFilter",dateFilter);
		model.addAttribute("pageSize",pageSize);
		model.addAttribute("pageNum",pageNum);
		
		model.addAttribute("totalCount",totalCount);
		model.addAttribute("totalPage",totalPage);
		model.addAttribute("blockSize",blockSize);
		model.addAttribute("startPage",startPage);
		model.addAttribute("endPage",endPage);
		
		model.addAttribute("totalAll",totalAll);
		

		return "article/list";
	}


}
