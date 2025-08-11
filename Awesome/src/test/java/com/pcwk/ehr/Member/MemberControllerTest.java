package com.pcwk.ehr.Member;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import java.util.Date;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.pcwk.ehr.member.domain.MemberDTO;
import com.fasterxml.jackson.databind.ObjectMapper;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {
    "file:src/main/webapp/WEB-INF/spring/root-context.xml",
    "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
public class MemberControllerTest {

    @Autowired
    private WebApplicationContext context;

    private MockMvc mockMvc;
    private MemberDTO testDto;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();

        testDto = new MemberDTO("user01", "pwd1234", "홍길동", "닉네임",
                "19900101", "hong@test.com", "N", "test-token-uuid",
                1, new Date(), new Date());
    }

    @Test
    @DisplayName("1. 회원가입 페이지 요청")
    void joinPage() throws Exception {
        mockMvc.perform(get("/member/join.do"))
               .andExpect(status().isOk());
    }

    @Test
    @DisplayName("2. 회원가입 처리")
    void register() throws Exception {
        mockMvc.perform(post("/member/register.do")
                .contentType(MediaType.APPLICATION_JSON)
                .content(new ObjectMapper().writeValueAsString(testDto)))
                .andExpect(status().is3xxRedirection());
    }

    @Test
    @DisplayName("3. 로그인 처리")
    void login() throws Exception {
        mockMvc.perform(post("/member/login.do")
                .param("userId", testDto.getUserId())
                .param("pwd", testDto.getPwd()))
               .andExpect(status().isOk())
               .andExpect(model().attributeExists("member"));
    }

    @Test
    @DisplayName("4. 이메일 인증 처리")
    void emailAuth() throws Exception {
        mockMvc.perform(get("/member/emailAuthConfirm.do")
                .param("token", testDto.getEmailAuthToken()))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/member/login.do"));
    }
}
