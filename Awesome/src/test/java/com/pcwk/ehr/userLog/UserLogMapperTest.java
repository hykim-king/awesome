package com.pcwk.ehr.userLog;

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

import com.pcwk.ehr.userLog.domain.UserLogDTO;
import com.pcwk.ehr.mapper.UserLogMapper; // ★ 스캐너 basePackage 맞춘 경로 (com.pcwk.ehr.mapper)

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {
    "file:src/main/webapp/WEB-INF/spring/root-context.xml",
    "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
public class UserLogMapperTest {

    Logger log = LogManager.getLogger(getClass());

    @Autowired
    UserLogMapper mapper;

    UserLogDTO dto01;
    UserLogDTO dto02;
    UserLogDTO dto03;

    // FK가 있으면 실제 존재하는 코드로 바꿔줘
    Long articleCode = 1001L;

    @BeforeEach
    public void setUp() {
        // 1) 전체 삭제
        mapper.deleteAll();
        log.debug("user_click_log 전체삭제");

        // 2) 테스트 데이터 준비 (clickedAt은 비교 제외)
        dto01 = new UserLogDTO(null, "user01", articleCode, new Date());
        dto02 = new UserLogDTO(null, "user02", articleCode, new Date());
        dto03 = new UserLogDTO(null, "user03", articleCode, new Date());
    }

    @AfterEach
    public void tearDown() {
        log.debug("--------- @AfterEach ---------");
    }

    //@Disabled
    @Test
    @DisplayName("doSave 단건 저장 및 selectKey 채번 검증")
    void doSave() {
        int flag = mapper.doSave(dto01);
        assertEquals(1, flag, "doSave 성공 여부 확인");
        assertNotNull(dto01.getLogCode(), "selectKey로 logCode 생성되어야 함");

        UserLogDTO saved = mapper.doSelectOne(dto01);
        isSameUserLog(saved, dto01); // clickedAt 비교 제외
    }

    @Disabled
    @Test
    @DisplayName("doSelectOne 단건 조회")
    void doSelectOne() {
        mapper.doSave(dto01);
        assertNotNull(dto01.getLogCode(), "사전 저장 후 logCode 채번 확인");

        UserLogDTO out = mapper.doSelectOne(dto01);
        assertNotNull(out, "doSelectOne 결과는 null이 아니어야 함");
        isSameUserLog(out, dto01);
    }

    @Disabled
    @Test
    @DisplayName("doDelete 삭제")
    void doDelete() {
        mapper.doSave(dto01);

        int flag = mapper.doDelete(dto01);
        assertEquals(1, flag, "doDelete 성공 여부 확인");

        UserLogDTO out = mapper.doSelectOne(dto01);
        assertNull(out, "삭제 후 doSelectOne은 null이어야 함");
    }
   
    @Disabled
    @Test
    @DisplayName("doRetrieve 다건 조회")
    void doRetrieve() {
        mapper.doSave(dto01);
        mapper.doSave(dto02);
        mapper.doSave(dto03);

        List<UserLogDTO> list = mapper.doRetrieve();
        assertEquals(3, list.size(), "doRetrieve 조회 건수 확인");
        list.forEach(log::debug);
    }

    @Disabled
    @Test
    @DisplayName("doRetrieveByUser 특정 사용자 로그 조회")
    void doRetrieveByUser() {
        mapper.doSave(dto01);
        mapper.doSave(dto02);

        List<UserLogDTO> list = mapper.doRetrieveByUser(dto01); // user01 기준
        assertTrue(list.size() >= 1, "user01 조회는 최소 1건 이상이어야 함");
        list.forEach(vo -> assertEquals("user01", vo.getUserId()));
    }

    /** 필드 비교 헬퍼 (clickedAt은 비교 제외) */
    private void isSameUserLog(UserLogDTO out, UserLogDTO in) {
        assertEquals(in.getLogCode(), out.getLogCode());
        assertEquals(in.getUserId(), out.getUserId());
        assertEquals(in.getArticleCode(), out.getArticleCode());
    }
}