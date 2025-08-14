package com.pcwk.ehr.Member;

import static org.junit.Assert.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertEquals;

import java.sql.SQLException;
import java.util.Date;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import com.pcwk.ehr.mapper.MemberMapper;
import com.pcwk.ehr.member.domain.MemberDTO;

/*
 * @ExtendWith(SpringExtension.class)
 * 
 * @ContextConfiguration(locations = {
 * "file:src/main/webapp/WEB-INF/spring/root-context.xml"})
 */

@Transactional
@Rollback
@ExtendWith(SpringExtension.class)  //Controller test시 다시 사용
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })

		

class DaoTest {

Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	MemberMapper mapper;	// 테스트 대상 Bean
	
	@Autowired
	ApplicationContext context;	// 컨테이너 확인용
	
	MemberDTO dto01;	//테스트 데이터 & 공용 객체
	
	@BeforeEach
	void setUp() throws Exception {
		dto01 = new MemberDTO("test","132","test","test01","20001111","dlwhd0614@naver.com","Y","125",1,new Date(),new Date());
	}
	

	@AfterEach
	void tearDown() throws Exception {
	}
	
	  	//@Disabled
	    @Test
	    @DisplayName("1. 등록 후 단건 조회 테스트")
	    void doSaveAndSelectOne() throws SQLException {
	        // 삭제
	        mapper.deleteAll();

	        // 저장
	        int saveResult = mapper.doSave(dto01);
	        assertEquals(1, saveResult);

	        // 조회
	        MemberDTO param = new MemberDTO();
	        param.setUserId(dto01.getUserId());

	        MemberDTO result = mapper.doSelectOne(param);
	        assertNotNull(result);
	        assertEquals(dto01.getUserId(), result.getUserId());
	    }
	
	  	//@Disabled
	    @Test
	    @DisplayName("2. 수정 테스트")
	    void doUpdate() throws SQLException {
	  		mapper.deleteAll();
	  		mapper.doSave(dto01);

	  		MemberDTO param = new MemberDTO();
	  	    param.setUserId(dto01.getUserId());
	  	    param.setPwd("NewPassword123!");
	  	    param.setUserNm("테스트유저수정");
	  	    param.setNickNm("닉네임수정");
	  	    param.setBirthDt("20000101");
	  	    param.setMailAddr("updated@email.com");
	  	    param.setEmailAuthYn("Y");
	  	    param.setEmailAuthToken("updated-token-999");
	  	    param.setUserGradeCd(dto01.getUserGradeCd());
	  	    param.setModDt(new Date(System.currentTimeMillis()));

	        int updateResult = mapper.doUpdate(param);
	        assertEquals(1, updateResult);

	        MemberDTO updated = mapper.doSelectOne(param);
	        assertEquals("NewPassword123!", updated.getPwd());
	    }
	
	    
	    
	 //@Disabled
	 @Test
	 @DisplayName("3. 저장 테스트")
	void doSave() throws Exception {
		mapper.deleteAll();
		
		int flag = mapper.doSave(dto01);
		assertEquals(1, flag);
	}
	
	
	//@Disabled
    @Test
    @DisplayName("4. 삭제 테스트")
    void doDelete() throws SQLException {
        mapper.deleteAll();
        mapper.doSave(dto01);

        MemberDTO param = new MemberDTO();
        param.setUserId(dto01.getUserId());

        int deleteResult = mapper.doDelete(param);
        assertEquals(1, deleteResult);
    }
	
	//@Disabled
	@Test
	void bean() {
		assertNotNull(context);
		assertNotNull(mapper);

		log.debug(context);
		log.debug(mapper);
				
	}

}