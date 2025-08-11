package com.pcwk.ehr.member.service;

import java.sql.SQLException;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.pcwk.ehr.mapper.MemberMapper;
import com.pcwk.ehr.member.domain.MemberDTO;
import com.pcwk.ehr.member.service.MemberService;

import java.util.UUID;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired
    MemberMapper mapper;

    @Autowired
    JavaMailSender mailSender;

    @Autowired
    BCryptPasswordEncoder passwordEncoder;

    @Override
    public int register(MemberDTO dto) throws SQLException {
        String encodedPwd = passwordEncoder.encode(dto.getPwd());
        dto.setPwd(encodedPwd);

        dto.setEmailAuthYn("N");
        dto.setEmailAuthToken(UUID.randomUUID().toString());
        dto.setRegDt(new Date());
        dto.setModDt(new Date());

        return mapper.doSave(dto);
    }

    @Override
    public MemberDTO findById(MemberDTO dto) throws SQLException {
        return mapper.doSelectOne(dto);
    }

    @Override
    public int update(MemberDTO dto) throws SQLException {
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
        message.setText("다음 링크를 클릭하여 이메일 인증을 완료하세요: " +
                "http://localhost:8080/ehr/member/email-auth?token=" + token);

        mailSender.send(message);
        return true;
    }

    @Override
    public boolean verifyEmailToken(String token) throws SQLException {
        MemberDTO dto = mapper.findByEmailAuthToken(token);
        if (dto == null) return false;

        dto.setEmailAuthYn("Y");
        dto.setModDt(new Date());
        return mapper.doUpdate(dto) == 1;
    }

    @Override
    public boolean checkPassword(String inputPwd, String hashedPwd) {
        return passwordEncoder.matches(inputPwd, hashedPwd);
    }

    @Override
    public MemberDTO login(MemberDTO dto) throws SQLException {
        MemberDTO dbUser = mapper.doSelectOne(dto);
        if (dbUser != null && checkPassword(dto.getPwd(), dbUser.getPwd())) {
            dbUser.setPwd(null); // 비밀번호 제거
            return dbUser;
        }
        return null;
    }
}
