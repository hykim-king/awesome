package com.pcwk.ehr.keyword;

import static org.junit.jupiter.api.Assertions.*;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import com.pcwk.ehr.keyword.domain.KeywordDTO;
import com.pcwk.ehr.mapper.KeywordMapper;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {
    "file:src/main/webapp/WEB-INF/spring/root-context.xml",
    "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
public class KeywordMapperTest {

    Logger log = LogManager.getLogger(getClass());

    @Autowired
    KeywordMapper mapper;

    KeywordDTO dto01;
    KeywordDTO dto02;
    KeywordDTO dto03;

    Date today;

    @BeforeEach
    public void setUp() {
        // 1) 전체 삭제
        mapper.deleteAll();
        log.debug("daily_keyword 전체삭제");

        // 2) 테스트 데이터 준비
        today = Date.valueOf(LocalDate.now());
        dto01 = new KeywordDTO(null, today, "10AM", 10, "반도체");
        dto02 = new KeywordDTO(null, today, "10AM", 20, "금리인하");
        dto03 = new KeywordDTO(null, today, "10AM", 30, "증시반등");
    }

    @AfterEach
    public void tearDown() {
        log.debug("--------- @AfterEach ---------");
    }
    
    @Test
    @DisplayName("doSave 단건 저장 및 selectKey 채번 검증")
    void doSave() {
        int flag = mapper.doSave(dto01);
        assertEquals(1, flag);
        assertNotNull(dto01.getDkCode());

        KeywordDTO saved = mapper.doSelectOne(dto01);
        isSameKeyword(saved, dto01);
    }

    @Test
    @DisplayName("doSelectOne 단건 조회")
    void doSelectOne() {
        mapper.doSave(dto01);
        assertNotNull(dto01.getDkCode());

        KeywordDTO out = mapper.doSelectOne(dto01);
        assertNotNull(out);
        isSameKeyword(out, dto01);
    }

    @Test
    @DisplayName("doUpdate 수정")
    void doUpdate() {
        mapper.doSave(dto01);

        dto01.setCategory(11);
        dto01.setKeyword("초전도체");
        dto01.setUpdatePeriod("6PM");

        int flag = mapper.doUpdate(dto01);
        assertEquals(1, flag);

        KeywordDTO up = mapper.doSelectOne(dto01);
        assertNotNull(up);
        assertEquals(11, up.getCategory());
        assertEquals("초전도체", up.getKeyword());
        assertEquals("6PM", up.getUpdatePeriod());
    }

    @Test
    @DisplayName("doDelete 삭제")
    void doDelete() {
        mapper.doSave(dto01);

        int flag = mapper.doDelete(dto01);
        assertEquals(1, flag);

        KeywordDTO out = mapper.doSelectOne(dto01);
        assertNull(out);
    }

    @Test
    @DisplayName("doRetrieve 다건 조회")
    void doRetrieve() {
        mapper.doSave(dto01);
        mapper.doSave(dto02);
        mapper.doSave(dto03);

        List<KeywordDTO> list = mapper.doRetrieve();
        assertEquals(3, list.size());
        list.forEach(log::debug);
    }

 

    /** 필드 비교 헬퍼 */
    private void isSameKeyword(KeywordDTO out, KeywordDTO in) {
        assertEquals(in.getDkCode(), out.getDkCode());
        assertEquals(in.getDkDt(), out.getDkDt());
        assertEquals(in.getUpdatePeriod(), out.getUpdatePeriod());
        assertEquals(in.getCategory(), out.getCategory());
        assertEquals(in.getKeyword(), out.getKeyword());
    }
}