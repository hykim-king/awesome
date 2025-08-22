package com.pcwk.ehr.keyword;

import static org.junit.jupiter.api.Assertions.*;

import java.util.Date;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
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

    @BeforeEach
    public void setUp() {
//        // 1) 전체 삭제
//        mapper.deleteAll();
//        log.debug("daily_keyword 전체삭제");

        // 2) 테스트 데이터 준비
        dto01 = new KeywordDTO(null, new Date(), "10AM", 10, "정치키워드");
        dto02 = new KeywordDTO(null, new Date(), "10AM", 20, "경제 키워드");
        dto03 = new KeywordDTO(null, new Date(), "6PM", 30, "총총");
    }

    @AfterEach
    public void tearDown() {
        log.debug("--------- @AfterEach ---------");
    }

  @Disabled
    @Test
    @DisplayName("doSave 단건 저장 및 selectKey 검증")
    void doSave() {
        int flag = mapper.doSave(dto01);
        assertEquals(1, flag, "doSave 성공 여부 확인");
        assertNotNull(dto01.getDkCode(), "selectKey로 dkCode 생성되어야 함");

        KeywordDTO saved = mapper.doSelectOne(dto01);
        isSameKeyword(saved, dto01);
    }
   // @Disabled
    @Test
    @DisplayName("doSelectOne 단건 조회")
    void doSelectOne() {
        mapper.doSave(dto01);
        assertNotNull(dto01.getDkCode(), "사전 저장 후 dkCode 확인");

        KeywordDTO out = mapper.doSelectOne(dto01);
        assertNotNull(out, "doSelectOne 결과는 null이 아니어야 함");
        isSameKeyword(out, dto01);
    }
    @Disabled
    @Test
    @DisplayName("doDelete 삭제")
    void doDelete() {
        mapper.doSave(dto01);

        int flag = mapper.doDelete(dto01);
        assertEquals(1, flag, "doDelete 성공 여부 확인");

        KeywordDTO out = mapper.doSelectOne(dto01);
        assertNull(out, "삭제 후 doSelectOne은 null이어야 함");
    }
    @Disabled
    @Test
    @DisplayName("doRetrieve 다건 조회")
    void doRetrieve() {
        mapper.doSave(dto01);
        mapper.doSave(dto02);
        mapper.doSave(dto03);

        List<KeywordDTO> list = mapper.doRetrieve();
        assertEquals(3, list.size(), "doRetrieve 조회 건수 확인");
        list.forEach(log::debug);
    }
    @Disabled
    @Test
    @DisplayName("doUpdate 수정")
    void doUpdate() {
        mapper.doSave(dto01);
        dto01.setKeyword("수정된 키워드");

        int flag = mapper.doUpdate(dto01);
        assertEquals(1, flag, "doUpdate 성공 여부 확인");

        KeywordDTO updated = mapper.doSelectOne(dto01);
        assertEquals("수정된 키워드", updated.getKeyword(), "키워드가 수정되어야 함");
    }
    @Disabled
    @Test
    @DisplayName("getTotalCount 전체 건수 조회")
    void getTotalCount() {
        mapper.doSave(dto01);
        mapper.doSave(dto02);

        int count = mapper.getTotalCount();
        assertEquals(2, count, "총 건수 확인");
    }

    /** 필드 비교 헬퍼 */
    private void isSameKeyword(KeywordDTO out, KeywordDTO in) {
        assertEquals(in.getDkCode(), out.getDkCode());
        assertEquals(in.getUpdatePeriod(), out.getUpdatePeriod());
        assertEquals(in.getCategory(), out.getCategory());
        assertEquals(in.getKeyword(), out.getKeyword());
        // dkDt는 DB에서 milliseconds 단위까지 보존되지 않을 수 있어 단순 equals 비교는 피하는 게 안전
    }
}