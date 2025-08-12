package com.pcwk.ehr.bookmark;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.google.gson.Gson;
import com.pcwk.ehr.bookmark.domain.BookmarkDTO;
import com.pcwk.ehr.cmn.MessageDTO;
import com.pcwk.ehr.mapper.BookmarkMapper;


@WebAppConfiguration
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml" 
		,"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
class BookmarkControllerTest {
	
	Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	WebApplicationContext webApplicationContext;
	
	//웹브라우저 대역 객체
	MockMvc mockMvc;
	
	@Autowired
	BookmarkMapper mapper;
	
	BookmarkDTO bDto01;

	@BeforeEach
	void setUp() throws Exception {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ setUp()                               │");
		log.debug("└───────────────────────────────────────┘");
		
		mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
		
		bDto01 = new BookmarkDTO(2960, "user01");
	}

	@AfterEach
	void tearDown() throws Exception {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ tearDown()                            │");
		log.debug("└───────────────────────────────────────┘");
	}
	
	@Disabled
	@Test
	void toggleBookmark() throws Exception{
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ toggleBookmark()                      │");
		log.debug("└───────────────────────────────────────┘");
		
		//1. 전체삭제
		//2. 단건저장
		//3. 토글
		
	    MockHttpSession session = new MockHttpSession();
	    session.setAttribute("userId", "user01"); // ✅ 로그인 세션 주입
		
		//1. 
		mapper.deleteAll();
		assertEquals(0, mapper.getCount());
		
		//2. 
		mapper.doSave(bDto01);
		assertEquals(1, mapper.getCount());
		
		//3.
		MockHttpServletRequestBuilder requestBuilder 
		    = MockMvcRequestBuilders.post("/bookmark/toggleBookmark.do")
			    	.param("articleCode", "2960")
			    	.session(session); // 👈 세션 주입

		ResultActions resultActions = mockMvc.perform(requestBuilder)
		    .andExpect(status().isOk())
		    .andExpect(
		        MockMvcResultMatchers.content().contentType("text/plain;charset=UTF-8"));

		//2.3 호출 결과 받기
		String returnBody = resultActions.andDo(print())
		    .andReturn().getResponse().getContentAsString();

		log.debug("returnBody: {}", returnBody);
		MessageDTO resultMessage = new Gson().fromJson(returnBody, MessageDTO.class);
		log.debug("resultMessage: {}", resultMessage.toString());

		assertEquals(0, resultMessage.getMessageId());
		assertEquals("북마크가 삭제 되었습니다.", resultMessage.getMessage());
	}
	
	@Disabled
	@Test
	void doSelectOne() throws Exception{
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ doSelectOne()                         │");
		log.debug("└───────────────────────────────────────┘");
		//1. 전체삭제
		//2. 등록
		//3. 단건조회
		
	    MockHttpSession session = new MockHttpSession();
	    session.setAttribute("userId", "user01"); // ✅ 로그인 세션 주입
		
		//1. 
		mapper.deleteAll();
		assertEquals(0, mapper.getCount());
		
		//2. 
		mapper.doSave(bDto01);
		assertEquals(1, mapper.getCount());
		
		//3. 
		MockHttpServletRequestBuilder requestBuilder
			= MockMvcRequestBuilders.get("/bookmark/doSelectOne.do")
		    	.param("articleCode", "2960")
		    	.session(session); // 👈 세션 주입
		
		//3.1
		ResultActions resultActions = mockMvc.perform(requestBuilder)
				.andExpect(status().isOk());
		
		//3.2 
		MvcResult mvcResult = resultActions.andDo(print()).andReturn();
		Map<String, Object> model = mvcResult.getModelAndView().getModel();
		BookmarkDTO outVO = (BookmarkDTO)model.get("outVO");
		log.debug("outVO: {}", outVO);
		
		//3.3
		String viewName = mvcResult.getModelAndView().getViewName();
		log.debug("viewName: {}", viewName);
		
		assertEquals("/article/list", viewName);
		
	}
	
	@Disabled
	@Test
	void doRetriveMy() throws Exception{
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ doRetriveMy()                         │");
		log.debug("└───────────────────────────────────────┘");
		
		//1. 전체삭제
		//2. 단건등록
		//3. 목록 조회
		//4. 비교
		
	    MockHttpSession session = new MockHttpSession();
	    session.setAttribute("userId", "user01"); // ✅ 로그인 세션 주입
		
		//1. 
		mapper.deleteAll();
		assertEquals(0, mapper.getCount());
		
		//2. 
		mapper.doSave(bDto01);
		assertEquals(1, mapper.getCount());
		
		//3. 
		MockHttpServletRequestBuilder requestBuilder
			= MockMvcRequestBuilders.get("/bookmark/doRetriveMy.do")
		    	.param("pageNo", "1")
		    	.param("pageSize", "5")
		    	.session(session); // 👈 세션 주입
		
		//3.1
		ResultActions resultActions = mockMvc.perform(requestBuilder)
				.andExpect(status().isOk());
		
		//3.2 
		MvcResult mvcResult = resultActions.andDo(print()).andReturn();
		Map<String, Object> model = mvcResult.getModelAndView().getModel();
		
		List<BookmarkDTO> list = (List<BookmarkDTO>) model.get("list");
		for(BookmarkDTO vo : list) {
			log.debug(vo);
		}
		
		assertEquals(1, list.size());
		
	}
	

	@Disabled
	@Test
	void beans() {
		log.debug("┌───────────────────────────────────────┐");
		log.debug("│ beans()                               │");
		log.debug("└───────────────────────────────────────┘");
		
		
		assertNotNull(webApplicationContext);
		assertNotNull(mockMvc);
		assertNotNull(mapper);
		
		log.debug("webApplicationContext:{}", webApplicationContext);
		log.debug("mockMvc:{}", mockMvc);
		log.debug("mapper:{}", mapper);
	}

}
