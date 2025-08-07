package com.pcwk.ehr.article.service;

import java.util.List;

import com.pcwk.ehr.article.domain.ArticleDTO;

public interface ArticleService {
	
	int doSave(ArticleDTO param) throws Exception;
	
	ArticleDTO doSelectOne(ArticleDTO param) throws Exception;
	
	int doDelete(ArticleDTO param);
	
	List<ArticleDTO> doRetrieve(ArticleDTO param) throws Exception;
		
}
