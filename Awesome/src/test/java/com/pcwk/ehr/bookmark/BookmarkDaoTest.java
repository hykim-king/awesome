package com.pcwk.ehr.bookmark;

import static org.junit.jupiter.api.Assertions.*;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;

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
import com.pcwk.ehr.bookmark.domain.BookmarkDTO;
import com.pcwk.ehr.mapper.ArticleMapper;
import com.pcwk.ehr.mapper.BookmarkMapper;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })
class BookmarkDaoTest {
	
	Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	ApplicationContext context;
	
	@Autowired
	BookmarkMapper bMapper;
	
	@Autowired
	ArticleMapper aMapper;
	
	BookmarkDTO bDto01;
	BookmarkDTO bDto02;
	BookmarkDTO bDto03;

	ArticleDTO aDto01;
	
	Long arCode;
	
	@BeforeEach
	void setUp() throws Exception {
		log.debug("┌─────────────────────────────────────────────────────────┐");
		log.debug("│ setUp()                                                 │");
		log.debug("└─────────────────────────────────────────────────────────┘");
		
		aDto01 = new ArticleDTO(arCode, 10, "조선일보", "더위가 기승을 이루고 있는 가운데 폭우가 내릴 예정입니다.", "최근 체감 온도 40도를 육박하는 역대급 폭염인 가운데 다음 주 상당한 양의 비가 내릴 예정입니다.", "https://n.news.naver.com/mnews/article/001/0015554603?rc=N&ntype=RANKING",new Date(), 0, new Date(), new Date());
		
		//1. Article 데이터 단건 주입
		aMapper.doSave(aDto01);

		bDto01 = new BookmarkDTO(arCode.intValue(), "User01");
		bDto02 = new BookmarkDTO(arCode.intValue(), "User01");
		bDto03 = new BookmarkDTO(arCode.intValue(), "User03");
		
	}

	@AfterEach
	void tearDown() throws Exception {
		log.debug("┌─────────────────────────────────────────────────────────┐");
		log.debug("│ tearDown()                                              │");
		log.debug("└─────────────────────────────────────────────────────────┘");
	}

	@Test
	void  doRetrieve() throws SQLException{
		log.debug("┌─────────────────────────────────────────────────────────┐");
		log.debug("│ doRetrieve()                                            │");
		log.debug("└─────────────────────────────────────────────────────────┘");
		
		//1. 전체삭제
		//2. 단건등록
		//3. 등록건수비교
		//4. 단건조회
		
		//1. 
		bMapper.deleteAll();
		
		//2. 
		bMapper.doSave(bDto01);
		bMapper.doSave(bDto02);
		bMapper.doSave(bDto03);
		
		//3. 
		int count = bMapper.getCount();
		assertEquals(3, count);
		log.debug(count);
		
		//4.
		List<BookmarkDTO> outVO = bMapper.doRetrive(bDto01);
		assertNotNull(outVO);
		log.debug("outVO: {}", outVO);
		
		
	}
	
	
	@Disabled
	@Test
	void beans() {
		assertNotNull(context);
		assertNotNull(bMapper);
		assertNotNull(aMapper);
		
		log.debug("context: {}", context);
		log.debug("bMapper: {}", bMapper);
		log.debug("aMapper: {}", aMapper);
		
	}

}
