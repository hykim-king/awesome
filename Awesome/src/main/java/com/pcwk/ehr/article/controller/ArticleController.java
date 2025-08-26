package com.pcwk.ehr.article.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.pcwk.ehr.article.domain.ArticleDTO;
import com.pcwk.ehr.article.domain.ArticleSearchDTO;
import com.pcwk.ehr.article.service.ArticleService;
import com.pcwk.ehr.userKeyword.service.UserKeywordService;


@Controller
@RequestMapping("/article")
public class ArticleController {

	Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	ArticleService service;	
	
	@Autowired
	UserKeywordService userKeywordService;



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
		int currentBlk = (pageNum-1)/blockSize;
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
	//유효성 검증 후 기사 url로 리다이렉트
	@GetMapping("/visit.do")
	public String visit(@RequestParam("articleCode") long articleCode,
						@SessionAttribute(name = "userId", required = false) String userId) throws Exception{
		
		log.debug("visit.do: articleCode={}, userId={}", articleCode, userId);
		
		ArticleDTO req = new ArticleDTO();
		req.setArticleCode(articleCode);
		
		ArticleDTO article = service.doSelectOne(req);
		
		//기사나 기사url이 없거나 기사url이 null값이면 리스트로 돌아감
		if(article == null || article.getUrl() == null || article.getUrl().isEmpty()) {
			log.warn("Article or URL not found for articleCode: {}", articleCode);
			return "redirect:/article/list.do";
		}
		String url = article.getUrl();
		String title = article.getTitle(); // 기사 제목을 가져옵니다.
		//url이 http나 https로 시작하는 게 아니라면 리스트로 돌아감
		if(!(url.startsWith("http://")||url.startsWith("https://"))) {
			log.warn("Invalid URL format for articleCode: {}", articleCode);
			return "redirect:/article/list.do";
		}
		
		// 로그인된 사용자이고 제목이 있다면 키워드 추출 및 저장 로직 실행
		if (userId != null && title != null && !title.isEmpty()) {
			try {
				userKeywordService.processArticleKeywords(userId, title);
				log.debug("Keyword processing successful for user: {} and title: {}", userId, title);
			} catch (Exception e) {
				log.error("Failed to process keywords for articleCode: " + articleCode, e);
			}
		}
		
		return "redirect:"+url;
	}
	
	//조회수 증가
	@PostMapping(value = "/hit.do", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String,Object> hit(@RequestParam("articleCode") long articleCode) throws Exception{
		ArticleDTO req = new ArticleDTO();
		req.setArticleCode(articleCode);
		
		int updated = service.updateReadCnt(req);
		ArticleDTO one = service.doSelectOne(req);
		
		Map<String, Object> body = new HashMap<>();
	    
		
		body.put("ok", updated >0);
		body.put("views", one !=null ? one.getViews():null);
		
		
		return body;
	}
	
	@PostMapping("/delete.do")
	public String delete(@RequestParam("articleCode") long articleCode, Model model) throws Exception{
		
		log.debug("delete: articleCode()={}",articleCode);
		int flag = service.doDelete(articleCode);
		model.addAttribute("message", flag == 1? "삭제 성공":"삭제 실패");
		
		return "redirect:/article/list.do";
	}


}
