package com.pcwk.ehr.article.service;

import java.util.List;

import com.pcwk.ehr.article.domain.ArticleDTO;
import com.pcwk.ehr.article.domain.ArticleSearchDTO;

public interface ArticleService {
	
	int doSave(ArticleDTO param) throws Exception;
	
	ArticleDTO doSelectOne(ArticleDTO param) throws Exception;
	
	int doDelete(long articleCode);
	
	List<ArticleDTO> doRetrieve(ArticleSearchDTO param) throws Exception;
	
	int getCount(ArticleSearchDTO param) throws Exception;
	
	int getCountAll() throws Exception;
	
	int updateReadCnt(ArticleDTO param) throws Exception;
	
	
	//가민경 메인사용
	  ArticleDTO getTopArticleByCategory(int category);
	    List<ArticleDTO> getPopularTop1PerCategory();
}
