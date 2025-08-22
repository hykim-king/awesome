package com.pcwk.ehr.quiz;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import java.sql.SQLException;
import java.util.Date;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;

import com.pcwk.ehr.mapper.MemberMapper;
import com.pcwk.ehr.mapper.QuizMapper;
import com.pcwk.ehr.member.domain.MemberDTO;
import com.pcwk.ehr.quiz.domain.QuizDTO;

// JUnit5 + Spring
@ExtendWith(SpringExtension.class)
// 테스트 순서 지정 (메소드 이름 오름차순)
@TestMethodOrder(MethodOrderer.MethodName.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/spring/root-context.xml",
                                   "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
class QuizControllerTest {
    
    @Autowired
    WebApplicationContext webApplicationContext;
    
    // Quiz, Member 데이터 직접 관리를 위해 Mapper 주입
    @Autowired
    QuizMapper quizMapper;
    
    @Autowired
    MemberMapper memberMapper;
    
    // 테스트용 회원 비밀번호 암호화를 위해 주입
    @Autowired
    PasswordEncoder passwordEncoder;

    MockMvc mockMvc;
    MockHttpSession mockSession;
    MemberDTO testUser; // 세션에 저장될 객체를 실제 MemberDTO로 변경

    // 각 @Test 메소드 실행 전에 매번 실행
    @BeforeEach
    void setUp() throws Exception {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        
        // 테스트용 사용자 정보 설정 (실제 DB에 저장될 데이터)
        testUser = new MemberDTO();
        testUser.setUserId("junit_tester"); // 테스트용 아이디
        testUser.setPwd("password123!");      // 암호화될 비밀번호 원문
        testUser.setUserNm("테스터");
        testUser.setNickNm("주니테스터");
        testUser.setBirthDt("20000101");
        testUser.setMailAddr("tester@pcwk.com");
        testUser.setEmailAuthYn("Y");
        testUser.setUserGradeCd(1);
        testUser.setRegDt(new Date());
        testUser.setModDt(new Date());
        
        // Mock 세션 생성 및 로그인 정보 저장
        mockSession = new MockHttpSession();
        // ★★★ 세션에 저장할 때 비밀번호는 null로 설정하는 것이 일반적
        MemberDTO sessionUser = new MemberDTO();
        sessionUser.setUserId(testUser.getUserId());
        sessionUser.setNickNm(testUser.getNickNm());
        mockSession.setAttribute("loginUser", sessionUser);
    }
    
    // 테스트 데이터를 생성하는 헬퍼 메소드
    void setupRealDatabaseData() throws SQLException {
        // 1. 기존 데이터 삭제 (테스트 독립성 확보)
        QuizDTO quizUserParam = new QuizDTO();
        quizUserParam.setUserId(testUser.getUserId());
        quizMapper.deleteAllQuizResult(quizUserParam); // 테스트 유저의 퀴즈 결과 삭제
        memberMapper.doDelete(testUser.getUserId());   // 테스트 유저 삭제
        
        quizMapper.deleteAllQuizQuestions();
        quizMapper.deleteAllQuizSets();
        
        // 2. 테스트용 사용자 생성 (암호화된 비밀번호 사용)
        testUser.setPwd(passwordEncoder.encode(testUser.getPwd()));
        memberMapper.doSave(testUser);
        
        // 3. 오늘의 퀴즈 세트 생성 (qsCode=999)
        QuizDTO quizSet = new QuizDTO();
        quizSet.setQsCode(999);
        quizMapper.insertQuizSet(quizSet);
        
        // 4. 오늘의 퀴즈 문제 2개 생성
        QuizDTO q1 = new QuizDTO();
        q1.setQsCode(999); q1.setQqCode(9991); q1.setArticleCode(1); q1.setQuestionNo(1);
        q1.setQuestion("지구는 둥글다."); q1.setAnswer("O"); q1.setExplanation("지구는 평평하지 않고 둥급니다.");
        quizMapper.insertQuizQuestion(q1);
        
        QuizDTO q2 = new QuizDTO();
        q2.setQsCode(999); q2.setQqCode(9992); q2.setArticleCode(1); q2.setQuestionNo(2);
        q2.setQuestion("물은 10도에서 끓는다."); q2.setAnswer("X"); q2.setExplanation("물은 100도에서 끓습니다.");
        quizMapper.insertQuizQuestion(q2);
    }
    
    @Disabled
    @Test
    @Transactional // 테스트 후 DB 변경사항(회원, 퀴즈 데이터) 모두 롤백
    void showQuizForm_firstTime() throws Exception {
        // 1. DB에 테스트 데이터 생성
        setupRealDatabaseData();
        
        // 2. 처음 퀴즈를 푸는 사용자가 퀴즈 폼 페이지 요청
        mockMvc.perform(get("/quiz/quizForm.do").session(mockSession))
               .andExpect(status().isOk())
               .andExpect(view().name("quiz/quizForm"))
               .andExpect(model().attributeExists("quizList"))
               .andDo(print());
    }
    
    @Disabled
    @Test
    @Transactional
    void showQuizForm_alreadyPlayed() throws Exception {
        // 1. DB에 테스트 데이터 생성
        setupRealDatabaseData();
        
        // 2. 이미 푼 기록을 DB에 직접 삽입
        QuizDTO result = new QuizDTO();
        result.setUserId(testUser.getUserId());
        result.setQqCode(9991);
        result.setUserAnswer("O");
        quizMapper.insertQuizResult(result);
        
        // 3. 이미 푼 사용자가 퀴즈 폼 페이지 요청 시
        mockMvc.perform(get("/quiz/quizForm.do").session(mockSession))
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/quiz/main.do"))
               .andDo(print());
    }
    
    @Disabled
    @Test
    @Transactional
    void submitQuiz_allCorrect() throws Exception {
        // 1. DB에 테스트 데이터 생성
        setupRealDatabaseData();
        
        // 2. 퀴즈 제출 (모두 정답)
        mockMvc.perform(post("/quiz/submit.do")
                       .session(mockSession)
                       .param("questionNos", "9991", "9992")
                       .param("userAnswers", "O", "X"))
               .andExpect(status().isOk())
               .andExpect(view().name("quiz/quizForm"))
               .andExpect(model().attributeExists("resultList", "correctCount", "totalCount"))
               .andExpect(model().attribute("correctCount", 2))
               .andDo(print());
    }
    
    @Disabled
    @Test
    void showResult() throws Exception {
        // 이 테스트는 DB와 직접적인 연동 없이 파라미터 전달만 검증하므로
        // @Transactional이나 DB 데이터 셋업이 필수는 아님
        mockMvc.perform(post("/quiz/result.do")
                       .session(mockSession)
                       .param("correctCount", "1")
                       .param("totalCount", "2"))
               .andExpect(status().isOk())
               .andExpect(view().name("quiz/quizResult"))
               .andExpect(model().attribute("correctCount", 1))
               .andExpect(model().attribute("totalCount", 2))
               .andDo(print());
    }
    
    @Test
    void beans() {
        // Spring 컨텍스트와 의존성 주입이 제대로 되었는지 확인
        assertNotNull(webApplicationContext);
        assertNotNull(quizMapper);
        assertNotNull(memberMapper);
        assertNotNull(passwordEncoder);
    }
}