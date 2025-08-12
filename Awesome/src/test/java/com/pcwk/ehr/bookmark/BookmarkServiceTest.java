package com.pcwk.ehr.bookmark;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import java.util.Date;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import com.pcwk.ehr.article.domain.ArticleDTO;
import com.pcwk.ehr.bookmark.domain.BookmarkDTO;
import com.pcwk.ehr.bookmark.service.BookmarkService;
import com.pcwk.ehr.mapper.ArticleMapper;
import com.pcwk.ehr.mapper.BookmarkMapper;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/spring/root-context.xml" 
		,"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
class BookmarkServiceTest {
	
	Logger log = LogManager.getLogger(getClass());

	@Autowired
	ApplicationContext context;
	
	@Autowired
	BookmarkService service;
	
	@Autowired
	BookmarkMapper bMapper;
	
	@Autowired
	ArticleMapper aMapper;
	
	BookmarkDTO bDto01;
	BookmarkDTO bDto02;
	BookmarkDTO bDto03;
	

	ArticleDTO aDto01;
	
	Long articleCode;
	
	@BeforeEach
	void setUp() throws Exception {
		log.debug("┌─────────────────────────────────────────────────────────┐");
		log.debug("│ setUp()                                                 │");
		log.debug("└─────────────────────────────────────────────────────────┘");
		
//		aDto01 = new ArticleDTO(null, 10, "조선일보", "더위가 기승을 이루고 있는 가운데 폭우가 내릴 예정입니다.", "최근 체감 온도 40도를 육박하는 역대급 폭염인 가운데 다음 주 상당한 양의 비가 내릴 예정입니다.", "https://n.news.naver.com/mnews/article/001/0015554603?rc=N&ntype=RANKING",new Date(), 0, new Date(), new Date());
//		
//		//1. Article 데이터 단건 주입
//		aMapper.doSave(aDto01);
//		
//		articleCode = aDto01.getArticleCode();

		bDto01 = new BookmarkDTO(2960, "user01");
		bDto02 = new BookmarkDTO(2965, "user01");
		bDto03 = new BookmarkDTO(2967, "user01");
	}

	
	@Test 
	void toggleBookmark() {
		log.debug("┌─────────────────────────────────────────────────────────┐");
		log.debug("│ toggleBookmark()                                        │");
		log.debug("└─────────────────────────────────────────────────────────┘");
		
		//1. 전체삭제
		//2. 단건등록 x 3
		//2.1 등록 건수 조회
		//3. 토글
		//4. 토글
		
		//1. 
		bMapper.deleteAll();
		
		//2.
		bMapper.doSave(bDto01);
		bMapper.doSave(bDto02);
		bMapper.doSave(bDto03);
		
		int count = bMapper.getCount();
		assertEquals(3, count);
		log.debug(count);
		
		//3. 
		BookmarkDTO param = new BookmarkDTO();
		param.setArticleCode(bDto01.getArticleCode());
		param.setUserId(bDto01.getUserId());
		int result = service.toggleBookmark(param);
		
		log.debug("result:{}",result);
		
		count = bMapper.getCount();
		assertEquals(2, count);
		log.debug("count:{}",count);
		
		//4.
		param.setArticleCode(bDto01.getArticleCode());
		param.setUserId(bDto01.getUserId());
		result = service.toggleBookmark(param);
		
		log.debug("result:{}",result);
		
		count = bMapper.getCount();
		assertEquals(3, count);
		log.debug("count:{}",count);
		
	}

	@Disabled
	@Test
	void beans() {
		log.debug("┌─────────────────────────────────────────────────────────┐");
		log.debug("│ beans()                                                 │");
		log.debug("└─────────────────────────────────────────────────────────┘");
		
		assertNotNull(context);
		assertNotNull(service);
		assertNotNull(bMapper);
		assertNotNull(aMapper);

		log.debug("context: {}", context);
		log.debug("service: {}", service);
		log.debug("bMapper: {}", bMapper);
		log.debug("aMapper: {}", aMapper);

	}

}
