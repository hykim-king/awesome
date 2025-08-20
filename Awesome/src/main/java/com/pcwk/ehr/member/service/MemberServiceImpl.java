package com.pcwk.ehr.member.service;

import java.sql.SQLException;
import java.util.Date;
import java.util.UUID;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.pcwk.ehr.mapper.MemberMapper;
import com.pcwk.ehr.member.domain.MemberDTO;

@Service
public class MemberServiceImpl implements MemberService {

    private static final Logger log = LogManager.getLogger(MemberServiceImpl.class);

    @Autowired
    private MemberMapper mapper;

    // 이름 충돌 방지
    @Autowired @Qualifier("javaMailSender")
    private JavaMailSender mailSender;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // 링크 베이스 URL을 외부화 (없으면 기본값 사용)
    @Value("${app.baseUrl:http://localhost:8080/ehr}")
    private String baseUrl;

    // 아이디 중복
    @Override
    public boolean existsById(String userId) throws SQLException {
        return mapper.existsById(userId) > 0;
    }
    
    //닉네임 중복
    @Override
    public boolean existsByNick(String nickNm) throws Exception {
        return mapper.existsByNick(nickNm) > 0;
    }


    @Override
    public int register(MemberDTO dto) throws SQLException {
        dto.setEmailAuthYn("N");

        // ★ 폼에서 온 토큰이 비어있을 때만 새로 생성
        if (dto.getEmailAuthToken() == null || dto.getEmailAuthToken().isEmpty()) {
            dto.setEmailAuthToken(UUID.randomUUID().toString());
        }

        Date now = new Date();
        dto.setRegDt(now);
        dto.setModDt(now);

        dto.setPwd(passwordEncoder.encode(dto.getPwd()));
        return mapper.doSave(dto);
    }

    @Override
    public String findUserId(String userNm, String mailAddr) throws SQLException {
        return mapper.findUserId(userNm, mailAddr);
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

 
    /** 인증메일 발송: DB 업데이트 X, 토큰만 만들어 메일 전송 후 반환 */
    @Override
    public String sendEmailAuth(MemberDTO dto) throws Exception {
        if (dto == null || !StringUtils.hasText(dto.getMailAddr())) return null;

        String token = UUID.randomUUID().toString();
        try {
            SimpleMailMessage msg = new SimpleMailMessage();
            String from = (mailSender instanceof JavaMailSenderImpl)
                    ? ((JavaMailSenderImpl) mailSender).getUsername()
                    : "com0494@naver.com";

            msg.setFrom(from);
            msg.setTo(dto.getMailAddr());
            msg.setSubject("[회원가입 인증] 이메일 인증을 완료해주세요");
            msg.setText("아래 링크를 클릭해 인증을 완료하세요.\n"
                    + baseUrl + "/member/verifyEmail?token=" + token);

            mailSender.send(msg);
            return token;                     // ★ 토큰을 반환
        } catch (Exception e) {
            log.error("[MAIL] sendEmailAuth fail", e);
            return null;
        }
    }

    @Override
    public boolean verifyEmailToken(String token) throws SQLException {
        return mapper.markEmailVerifiedByToken(token) == 1;
    }


    @Override
    public boolean checkPassword(String inputPwd, String hashedPwd) {
        return passwordEncoder.matches(inputPwd, hashedPwd);
    }

    @Override
    public MemberDTO login(MemberDTO dto) throws SQLException {
        // 1) 아이디로만 조회
        MemberDTO dbUser = mapper.findByUserId(dto.getUserId());

        // 2) 해시 비교 (원문 vs 해시)
        if (dbUser != null && passwordEncoder.matches(dto.getPwd(), dbUser.getPwd())) {
            dbUser.setPwd(null); // 노출 방지
            return dbUser;
        }
        return null;
    }

    @Override
    public boolean sendResetMail(String userId, String mailAddr) {
        try {
            String token = UUID.randomUUID().toString();

            // 1) 토큰 저장
            int rows = mapper.updateResetToken(userId, mailAddr, token);
            if (rows != 1) return false;

            // 2) 메일 발송 (.do 패턴)
            SimpleMailMessage msg = new SimpleMailMessage();
            String from = (mailSender instanceof JavaMailSenderImpl)
                    ? ((JavaMailSenderImpl) mailSender).getUsername()
                    : "no-reply@example.com";
            msg.setFrom(from);
            msg.setTo(mailAddr);
            msg.setSubject("[비밀번호 재설정] 안내");
            msg.setText("아래 링크에서 비밀번호를 재설정하세요.\n"
                    + baseUrl + "/member/resetPwd.do?token=" + token);
            mailSender.send(msg);
            return true;
        } catch (Exception e) {
            log.error("[MAIL] sendResetMail fail", e);
            return false;
        }
    }


    @Override
    public int resetPassword(String token, String newPwd) throws SQLException {
        String hashed = passwordEncoder.encode(newPwd);
        return mapper.updatePasswordByToken(token, hashed); // 1이면 성공
    }

	@Override
	public MemberDTO doSelectOne(MemberDTO param) {
		return mapper.doSelectOne(param);
	}
	
    
}
