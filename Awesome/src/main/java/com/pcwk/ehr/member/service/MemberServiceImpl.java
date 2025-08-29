package com.pcwk.ehr.member.service;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;
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
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.pcwk.ehr.mapper.MemberMapper;
import com.pcwk.ehr.member.domain.MemberDTO;

@Service
public class MemberServiceImpl implements MemberService {

    private static final Logger log = LogManager.getLogger(MemberServiceImpl.class);

    @Autowired private MemberMapper mapper;
    @Autowired @Qualifier("javaMailSender") private JavaMailSender mailSender;
    @Autowired private PasswordEncoder passwordEncoder;

    @Value("${app.baseUrl:http://localhost:8080/ehr}")
    private String baseUrl;

    // ======== 내부 유틸 ========
    private JavaMailSenderImpl asImpl() {
        if (!(mailSender instanceof JavaMailSenderImpl)) {
            throw new IllegalStateException("JavaMailSenderImpl 이 필요합니다 (mailSender bean 확인)");
        }
        return (JavaMailSenderImpl) mailSender;
    }

    private String ensureFrom(JavaMailSenderImpl impl) {
        String from = impl.getUsername();
        if (!StringUtils.hasText(from)) {
            throw new IllegalStateException("MailSender username(발신자 계정)이 비어있습니다");
        }
        return from;
    }

    // ======== 중복 체크 ========
    @Override
    public boolean existsById(String userId) throws SQLException {
        return mapper.existsById(userId) > 0;
    }

    @Override
    public boolean existsByNick(String nickNm) throws Exception {
        return mapper.existsByNick(nickNm) > 0;
    }

    // 이메일 중복 검사(컨트롤러에서 사용)
    @Override
    public boolean existsByEmail(String mailAddr) throws Exception {
        if (!StringUtils.hasText(mailAddr)) return false;
        return mapper.existsByEmail(mailAddr) > 0;
    }

    // ======== 회원 CRUD ========
    @Override
    public int register(MemberDTO dto) throws SQLException {
        dto.setEmailAuthYn("N");
        if (!StringUtils.hasText(dto.getEmailAuthToken())) {
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
    public int delete(String dto) throws SQLException {
        return mapper.doDelete(dto);
    }

    // ======== 이메일 인증(링크) ========
    /** DB 업데이트 없이 토큰 생성 후 메일 발송 */
    @Override
    public String sendEmailAuth(MemberDTO dto) throws Exception {
        if (dto == null || !StringUtils.hasText(dto.getMailAddr())) return null;

        String token = UUID.randomUUID().toString();
        try {
            JavaMailSenderImpl impl = asImpl();
            String from = ensureFrom(impl);

            SimpleMailMessage msg = new SimpleMailMessage();
            msg.setFrom(from);                        // ★ 발신자 = SMTP 계정
            msg.setTo(dto.getMailAddr());
            msg.setSubject("[회원가입 인증] 이메일 인증을 완료해주세요");
            msg.setText("아래 링크를 클릭해 인증을 완료하세요.\n"
                    + baseUrl + "/member/verifyEmail?token=" + token);

            log.info("[MAIL] sendEmailAuth host={}, port={}, from={}, to={}",
                    impl.getHost(), impl.getPort(), from, dto.getMailAddr());

            mailSender.send(msg);
            return token;
        } catch (Exception e) {
            log.error("[MAIL] sendEmailAuth fail", e);
            return null;
        }
    }

    @Override
    public boolean verifyEmailToken(String token) throws SQLException {
        return mapper.markEmailVerifiedByToken(token) == 1;
    }

    // ======== 로그인/비밀번호 ========
    @Override
    public boolean checkPassword(String inputPwd, String hashedPwd) {
        return passwordEncoder.matches(inputPwd, hashedPwd);
    }

    @Override
    public MemberDTO login(MemberDTO dto) throws SQLException {
        MemberDTO dbUser = mapper.findByUserId(dto.getUserId());
        if (dbUser != null && passwordEncoder.matches(dto.getPwd(), dbUser.getPwd())) {
            dbUser.setPwd(null);
            return dbUser;
        }
        return null;
    }

    @Override
    public boolean sendResetMail(String userId, String mailAddr) {
        try {
            String token = UUID.randomUUID().toString();

            int rows = mapper.updateResetToken(userId, mailAddr, token);
            if (rows != 1) return false;

            JavaMailSenderImpl impl = asImpl();
            String from = ensureFrom(impl);

            SimpleMailMessage msg = new SimpleMailMessage();
            msg.setFrom(from);                        // ★ 발신자 = SMTP 계정
            msg.setTo(mailAddr);
            msg.setSubject("[비밀번호 재설정] 안내");
            msg.setText("아래 링크에서 비밀번호를 재설정하세요.\n"
                    + baseUrl + "/member/resetPwd.do?token=" + token);

            log.info("[MAIL] sendResetMail host={}, port={}, from={}, to={}",
                    impl.getHost(), impl.getPort(), from, mailAddr);

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
        return mapper.updatePasswordByToken(token, hashed);
    }

    // ======== 6자리 코드 메일 ========
    @Override
    public String sendEmailCode(String mailAddr) throws Exception {
        if (!StringUtils.hasText(mailAddr)) return null;

        String code = String.format("%06d", new java.security.SecureRandom().nextInt(1_000_000));
        try {
            JavaMailSenderImpl impl = asImpl();
            String from = ensureFrom(impl);

            SimpleMailMessage msg = new SimpleMailMessage();
            msg.setFrom(from);                        // ★ 발신자 = SMTP 계정
            msg.setTo(mailAddr);
            msg.setSubject("[이메일 인증] 인증 코드 안내");
            msg.setText("아래 6자리 인증 코드를 입력해 주세요.\n\n인증코드: " + code + "\n\n(유효시간: 10분)");

            log.info("[MAIL] sendEmailCode host={}, port={}, from={}, to={}",
                    impl.getHost(), impl.getPort(), from, mailAddr);

            mailSender.send(msg);
            return code;
        } catch (Exception e) {
            log.error("[MAIL] sendEmailCode fail", e);
            return null;
        }
    }

	@Override
	public MemberDTO doSelectOne(MemberDTO param) {
		return mapper.doSelectOne(param);
	}

	@Override
	public int updateNickNmByUserId(MemberDTO param) {
		return mapper.updateNickNmByUserId(param);
	}

	@Override
	public int updatePwdByUserId(MemberDTO param) {
		param.setPwd(passwordEncoder.encode(param.getPwd()));
		return mapper.updatePwdByUserId(param);
	}
	

	
	@Override
	@Transactional
	public int deleteMany(List<String> ids) {
	    if (ids == null || ids.isEmpty()) return 0;

	    
		/*
		 * // 1) 자식 데이터 먼저 삭제 (존재하지 않으면 0건만 처리됨) mapper.deleteQuizByUserIds(ids); //
		 * QUIZ_RESULT.USER_ID mapper.deleteReportByReporterIds(ids); // REPORT.USER_ID
		 * (신고자) mapper.deleteReportByTargetIds(ids); // REPORT.CT_ID (신고대상)
		 * mapper.deleteChatByUserIds(ids); // CHAT_MESSAGE.USER_ID
		 * mapper.deleteReportByUserIds(ids);
		 */
	    
	    
	    
	    int quizCnt   = mapper.countQuizByIds(ids);
	    int reportCnt = 0; // 필요 시 mapper.countReportByUserIds(ids)+mapper.countReportByTargetIds(ids);
	    int chatCnt   = 0; // 필요 시 mapper.countChatByUserIds(ids);

	    if (quizCnt > 0 || reportCnt > 0 || chatCnt > 0) {
	        // 자식이 하나라도 있으면 예외 발생시켜 컨트롤러에서 메시지 처리
	        throw new org.springframework.dao.DataIntegrityViolationException(
	            "연결된 데이터 존재: quiz=" + quizCnt + ", report=" + reportCnt + ", chat=" + chatCnt);
	    }

	    return mapper.deleteMembersByIds(ids);
	}
	
	
	
	
}
