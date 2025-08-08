package com.pcwk.ehr.Member;

import static org.junit.Assert.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.Date;

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

import com.pcwk.ehr.mapper.MemberMapper;
import com.pcwk.ehr.member.domain.MemberDTO;


@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })
class DaoTest {

Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	MemberMapper mapper;
	
	@Autowired
	ApplicationContext context;
	
	MemberDTO dto01;
	
	@BeforeEach
	void setUp() throws Exception {
		dto01 = new MemberDTO("test","132","test","test01","2000/11/11","dlwhd0614@naver.com","Y","125",1,new Date(),new Date());
	}
	

	@AfterEach
	void tearDown() throws Exception {
	}
	
	@Test
	void doSave() throws Exception {
		mapper.deleteAll();
		
		int flag = mapper.doSave(dto01);
		assertEquals(1, flag);
	}

	@Test
	void bean() {
		assertNotNull(context);
		assertNotNull(mapper);

		log.debug(context);
		log.debug(mapper);
				
	}

}