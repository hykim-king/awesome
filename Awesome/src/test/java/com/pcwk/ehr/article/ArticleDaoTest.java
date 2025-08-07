package com.pcwk.ehr.article;

import static org.junit.Assert.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertEquals;

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
import com.pcwk.ehr.mapper.ArticleMapper;
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })

class ArticleDaoTest {
	Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	ArticleMapper mapper;
	
	@Autowired
	ApplicationContext context;
	

	
	ArticleDTO dto01;

	@BeforeEach
	void setUp() throws Exception {
		
		
		dto01 = new ArticleDTO(1L,10,"조선일보","AI가 세상을 바꾼다","AI 기술의 발전과 전망",
		        "https://chosun.com/ai-future",new Date(),0,new Date(),new Date());
	}

	@AfterEach
	void tearDown() throws Exception {
	}
	
	@Disabled
	@Test
	public void doSave() throws Exception{
		mapper.deleteAll();
		
		int flag=mapper.doSave(dto01);
		assertEquals(1, flag);
	}
	
	@Disabled
	@Test
	public void doDelete() throws Exception{
		
		mapper.doSave(dto01);
		
		
		int count = mapper.doDelete(dto01);
		assertEquals(1, count);
		
	}
	
	@Test
	public void doRetrieve() throws Exception{
		
		mapper.deleteAll();
		
		
		
	}

	@Test
	void bean() {
		assertNotNull(context);
		assertNotNull(mapper);
		
		log.debug(context);
		log.debug(mapper);

		
	}

}
