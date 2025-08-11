package com.pcwk.ehr.article;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
@WebAppConfiguration
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {
    "file:src/main/webapp/WEB-INF/spring/root-context.xml",
    "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
class ArticleControllerTest {
	
	@Autowired
	private WebApplicationContext context;
	
	private MockMvc mvc;

	@BeforeEach
	void setUp() throws Exception {
		mvc = MockMvcBuilders.webAppContextSetup(context).build();
	}

	@AfterEach
	void tearDown() throws Exception {
	}
	
	//파라미터 없이 기사 조회
	@Test
	void viewModel() throws Exception{
		mvc.perform(get("/article/list.do"))
		    .andExpect(status().isOk())
		    .andExpect(view().name("article/list"))
		    .andExpect(model().attributeExists("list"))
		    .andExpect(model().attribute("pageNum", 1))
		    .andExpect(model().attribute("pageSize", 10))
		    //검색 조건이 없을 때 빈 값인지 확인, 잘못된 값이나 이전 값이 들어가 있는지 확인
		    .andExpect(model().attribute("searchDiv", (String)null))
		    .andExpect(model().attribute("searchWord", (String) null))
		    .andExpect(model().attribute("category", (Integer)null));
	}

	@Test
	void bean() {
		assertNotNull(context);
	}

}
