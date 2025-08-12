package com.pcwk.ehr.member.service;

import java.sql.SQLException;
import java.util.Date;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.pcwk.ehr.mapper.MemberMapper;
import com.pcwk.ehr.member.domain.MemberDTO;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired 
    private MemberMapper mapper;
    @Autowired 
    private JavaMailSender mailSender;

    // 인터페이스로 주입 (테스트에선 NoOp, 운영에선 BCrypt)
    @Autowired private PasswordEncoder passwordEncoder;

    // 아이디 중복
    @Override
    public boolean existsById(String userId) throws SQLException {
        return mapper.existsById(userId) > 0;  
    }
    
    @Override
    public int register(MemberDTO dto) throws SQLException {
        // 기본값
        dto.setEmailAuthYn("N");
        dto.setEmailAuthToken(UUID.randomUUID().toString());
        Date now = new Date();
        dto.setRegDt(now);
        dto.setModDt(now);

        // 비밀번호 인코딩 (테스트=NoOp → 20자 제한 OK / 운영=BCrypt)
        dto.setPwd(passwordEncoder.encode(dto.getPwd()));
        return mapper.doSave(dto);
    }

    @Override
    public MemberDTO findById(MemberDTO dto) throws SQLException {
        return mapper.doSelectOne(dto);
    }

    @Override
    public int update(MemberDTO dto) throws SQLException {
        dto.setModDt(new Date());
        return mapper.doUpdate(dto);
    }

    @Override
    public int delete(MemberDTO dto) throws SQLException {
        return mapper.doDelete(dto);
    }

    @Override
    public boolean sendEmailAuth(MemberDTO dto) throws Exception {
        String token = dto.getEmailAuthToken();
        String email = dto.getMailAddr();

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email);
        message.setSubject("[회원가입 인증] 이메일 인증을 완료해주세요");
        // 컨트롤러 매핑과 일치
        message.setText("다음 링크를 클릭하여 이메일 인증을 완료하세요: " +
                "http://localhost:8080/ehr/member/verifyEmail?token=" + token);

        mailSender.send(message);
        return true;
    }

    @Override
    public boolean verifyEmailToken(String token) throws SQLException {
        MemberDTO found = mapper.findByEmailAuthToken(token);
        if (found == null) return false;
        found.setEmailAuthYn("Y");
        found.setModDt(new Date());
        return mapper.doUpdate(found) == 1;
    }

    @Override
    public boolean checkPassword(String inputPwd, String hashedPwd) {
        return passwordEncoder.matches(inputPwd, hashedPwd);
    }

    @Override
    public MemberDTO login(MemberDTO dto) throws SQLException {
        // mapper.doSelectOne(dto)가 userId로 조회하도록 구현되어 있어야 함
        MemberDTO dbUser = mapper.doSelectOne(dto);
        if (dbUser != null && checkPassword(dto.getPwd(), dbUser.getPwd())) {
            dbUser.setPwd(null); // 보안상 비밀번호 제거
            return dbUser;
        }
        return null;
    }
}
