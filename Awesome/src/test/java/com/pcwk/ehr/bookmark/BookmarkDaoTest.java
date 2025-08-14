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
import com.pcwk.ehr.cmn.SearchDTO;
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
	BookmarkDTO bDto04;
	BookmarkDTO bDto05;
	BookmarkDTO bDto06;

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

		bDto01 = new BookmarkDTO(7384, "user01");
		bDto02 = new BookmarkDTO(7385, "user01");
		bDto03 = new BookmarkDTO(7389, "user01");
		bDto04 = new BookmarkDTO(7393, "user01");
		bDto05 = new BookmarkDTO(7406, "user01");
		bDto06 = new BookmarkDTO(7410, "user01");
	}

	@AfterEach
	void tearDown() throws Exception {
		log.debug("┌─────────────────────────────────────────────────────────┐");
		log.debug("│ tearDown()                                              │");
		log.debug("└─────────────────────────────────────────────────────────┘");
	}
	
	//@Disabled
	@Test
	void doSelectOne() throws SQLException{
		log.debug("┌─────────────────────────────────────────────────────────┐");
		log.debug("│ doSelectOne()                                           │");
		log.debug("└─────────────────────────────────────────────────────────┘");
		
		//1. 전체삭제
		//2. 다건 등록
		//2.1 등록 건수 조회
		//3. 단건 조회
		//4. 단건 삭제
		//4.1 등록 건수 조회
		
		//1. 
		bMapper.deleteAll();
		
		//2.
		bMapper.doSave(bDto01);
		bMapper.doSave(bDto02);
		bMapper.doSave(bDto03);
		
		//3.
		BookmarkDTO param = new BookmarkDTO();
		param.setArticleCode(bDto02.getArticleCode());
		param.setUserId(bDto02.getUserId());
		BookmarkDTO outVO = bMapper.doSelectOne(param);
		log.debug("outVO: {}", outVO);
		
		//4.
		param.setUserId(outVO.getUserId());
		param.setArticleCode(outVO.getArticleCode());
		bMapper.doDeleteByArticleUser(param);
		
		int count = bMapper.getCount();
		assertEquals(2, count);
		log.debug(count);
	}

	//@Disabled
	@Test
	void doDelete() throws SQLException{
		log.debug("┌─────────────────────────────────────────────────────────┐");
		log.debug("│ doDelete()                                              │");
		log.debug("└─────────────────────────────────────────────────────────┘");
		
		//1. 전체삭제
		//2. 단건등록
		//3. 기사조회
		//4. 단건삭제
		//5. 등록 건수 조회
		
		//1. 
		bMapper.deleteAll();
		
		//2. 
		bMapper.doSave(bDto01);
		bMapper.doSave(bDto02);
		bMapper.doSave(bDto03);
		bMapper.doSave(bDto04);
		bMapper.doSave(bDto05);
		bMapper.doSave(bDto06);
		
		//3. 
		BookmarkDTO param = new BookmarkDTO();
		param.setUserId(bDto01.getUserId());
		param.setPageNo(1);
		param.setPageSize(5);
		List<BookmarkDTO> outVO = bMapper.doRetriveMy(param);
		assertNotNull(outVO);
		log.debug("outVO: {}", outVO);
		
		for(BookmarkDTO list:outVO) {
			log.debug("list:{}",list);
		}
		
		//4. 
		param.setBmCode(outVO.get(0).getBmCode());
		bMapper.doDelete(param);
		
		//5. 
		int count = bMapper.getCount();
		assertEquals(5, count);
		log.debug(count);
		
	}
	
	//@Disabled
	@Test
	void  doRetrieve() throws SQLException{
		log.debug("┌─────────────────────────────────────────────────────────┐");
		log.debug("│ doRetrieve()                                            │");
		log.debug("└─────────────────────────────────────────────────────────┘");
		
		//1. 전체삭제
		//2. 단건등록
		//3. 등록건수비교
		//4. 기사조회
		
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
		BookmarkDTO param = new BookmarkDTO();
		param.setUserId(bDto01.getUserId());
		param.setPageNo(1);
		param.setPageSize(5);
		List<BookmarkDTO> outVO = bMapper.doRetriveMy(param);
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
