package com.pcwk.ehr.Member;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.pcwk.ehr.member.service.MemberService;

@WebAppConfiguration
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {
    "file:src/main/webapp/WEB-INF/spring/root-context.xml",   // DataSource/MyBatis 등
    "classpath:servlet-context-member-test.xml"               // Member만 스캔 + NoOp 인코더
})



public class MemberControllerTest {
	
	

    @Mock
    private MemberService memberService; 
    
    
    @Mock
    private JavaMailSender mailSender;
    
    @Autowired private WebApplicationContext wac;
    private MockMvc mockMvc;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();
    }
    
    //@Disabled
    @Test
    @DisplayName("1. 회원가입 페이지 요청")
    void registerPage() throws Exception {
        mockMvc.perform(get("/member/register.do"))
               .andExpect(status().isOk())
               .andExpect(view().name("member/register"));
    }
    
    //@Disabled
    @Test
    @DisplayName("2. 회원가입 처리(폼 전송)")
    void register() throws Exception {
        String uid   = "user" + System.currentTimeMillis(); // 매번 다른 아이디
        String email = uid + "@test.com";
        String nick  = "nick_" + uid;                       // 닉네임도 유니크

        mockMvc.perform(post("/member/register.do")
                .param("userId", uid)
                .param("pwd", "pwd1234")
                .param("userNm", "홍길동")
                .param("nickNm", nick)
                .param("birthDt", "19900101")   // YYYYMMDD
                .param("mailAddr", email)
                // .param("emailAuthToken", "test-token-uuid")  // 서비스에서 UUID 생성하므로 전달 안함
                .param("userGradeCd", "1")
        )
        .andExpect(status().is3xxRedirection());
       //.andExpect(redirectedUrl("/member/login.do"));
    }
    
    //@Disabled
    @Test
    @DisplayName("3. 로그인 처리(가입 후 로그인)")
    void login() throws Exception {
        String uid   = "user" + System.currentTimeMillis();
        String email = uid + "@test.com";
        String nick  = "nick_" + uid;

        // 1) 가입
        mockMvc.perform(post("/member/register.do")
        		.sessionAttr("emailVerified", email)
                .param("userId", uid)
                .param("pwd", "pwd1234")
                .param("userNm", "홍길동")
                .param("nickNm", nick)
                .param("birthDt", "19900101")
                .param("mailAddr", email)
                .param("userGradeCd", "1"))
            .andExpect(status().is3xxRedirection());

        // 2) 로그인
        mockMvc.perform(post("/member/login.do")
                .param("userId", uid)
                .param("pwd", "pwd1234"))
            .andExpect(status().is3xxRedirection())
            .andExpect(redirectedUrl("/mainPage/main.do")) ;
    }
    
    //@Disabled
    @Test
    @DisplayName("4. 이메일 인증 처리")
    void emailAuth() throws Exception {
        mockMvc.perform(get("/member/verifyEmail")
                .param("token", "test-token-uuid"))
               .andExpect(status().isOk())
               .andExpect(view().name("member/emailResult"))
               .andExpect(model().attributeExists("verified"));
    }
}
