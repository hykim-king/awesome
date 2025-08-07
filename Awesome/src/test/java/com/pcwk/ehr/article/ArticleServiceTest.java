package com.pcwk.ehr.article;

import static org.junit.Assert.assertNotNull;
import static org.junit.jupiter.api.Assertions.*;

import java.util.Date;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import com.pcwk.ehr.article.domain.ArticleDTO;
import com.pcwk.ehr.article.service.ArticleService;
import com.pcwk.ehr.cmn.SearchDTO;
import com.pcwk.ehr.mapper.ArticleMapper;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })

class ArticleServiceTest {

	Logger log = LogManager.getLogger(getClass());

	@Autowired
	ArticleMapper mapper;

	@Autowired
	ApplicationContext context;

	@Autowired
	ArticleService service;

	ArticleDTO dto01;
	
	SearchDTO search;

	@BeforeEach
	void setUp() throws Exception {
		dto01 = new ArticleDTO(1L, 10, "조선일보", "AI가 세상을 바꾼다", "AI 기술의 발전과 전망", "https://chosun.com/ai-future",
				new Date(), 0, new Date(), new Date());
		search = new SearchDTO();
	}

	@AfterEach
	void tearDown() throws Exception {
	}
	
	@Disabled
	@Test
	void doSave() throws Exception{
		mapper.deleteAll();
		
		int saveResult = service.doSave(dto01);
		log.debug("1. 저장 결과:{}", saveResult);
		
		assertEquals(1, saveResult, "기사 저장 실패");
	}
	
	@Disabled
	@Test
	void doDelete() throws Exception{
		mapper.deleteAll();
		service.doSave(dto01);
		
		int deleteCount = service.doDelete(dto01);
		log.debug("doDelete 결과: 삭제된 행 수={}",deleteCount);
		assertEquals(1, deleteCount);
		
	}
	
	@Test
	void doSelectOne() throws Exception{
		mapper.deleteAll();
		service.doSave(dto01);
		
		
	}
	
	
	

	@Test
	void bean() {
		assertNotNull(context);
		assertNotNull(mapper);

		log.debug(context);
		log.debug(mapper);
	}

}
