package com.pcwk.ehr.article.service;

import java.util.Date;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pcwk.ehr.article.domain.ArticleDTO;
import com.pcwk.ehr.article.domain.ArticleSearchDTO;
import com.pcwk.ehr.cmn.SearchDTO;
import com.pcwk.ehr.mapper.ArticleMapper;

@Service
public class ArticleServiceImpl implements ArticleService {

	Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	private ArticleMapper mapper;
	
	
	
	public ArticleServiceImpl() {

	}

	@Override
	public int doSave(ArticleDTO dto) throws Exception {
		
		Date now = new Date();
		dto.setRegDt(now);
		dto.setModDt(now);		
		
		int result = mapper.doSave(dto);
		
		if(result > 0) {
			ArticleDTO saved = mapper.doSelectOne(dto);
			dto.setRegDt(saved.getRegDt());
			dto.setModDt(saved.getModDt());
		}
		
		return result;
	}

	@Override
	public ArticleDTO doSelectOne(ArticleDTO dto) throws Exception {
		
		
		return mapper.doSelectOne(dto);
	}

	@Override
	public int doDelete(ArticleDTO dto) {
		return mapper.doDelete(dto);
	}

	@Override
	public List<ArticleDTO> doRetrieve(ArticleSearchDTO param) throws Exception {

		return mapper.doRetrieve(param);
	}

	@Override
	public int getCount(ArticleSearchDTO param) throws Exception {
		return mapper.getCount(param);
	}

	@Override
	public int getCountAll() throws Exception {
		return mapper.getCountAll();
	}

	@Override
	public int updateReadCnt(ArticleDTO param) throws Exception {
		return mapper.updateReadCnt(param);
	}

}
