package com.pcwk.ehr.quiz;

import static org.junit.Assert.assertNotNull;
import static org.junit.jupiter.api.Assertions.*;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import com.pcwk.ehr.mapper.QuizMapper;
import com.pcwk.ehr.quiz.domain.QuizDTO;
import com.pcwk.ehr.quiz.service.QuizService;


@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })
class QuizServiceTest {
	
	Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	QuizMapper mapper;
	
	@Autowired
	ApplicationContext context;
	
	@Autowired
	QuizService service;
	
	QuizDTO qdto;
	

	@BeforeEach
	void setUp() throws Exception {
	}

	@AfterEach
	void tearDown() throws Exception {
	}

	@Test
	void bean() {
		assertNotNull(context);
		assertNotNull(mapper);
		
		log.debug(context);
		log.debug(mapper);
	}

}
