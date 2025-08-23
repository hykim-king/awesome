package com.pcwk.ehr.test;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;

public class SmtpProbe {
    public static void main(String[] args) throws Exception {
        final String host = "smtp.naver.com";
        final String from = "com0494@naver.com";
        final String user = "com0494@naver.com";
        final String pass = "V6WVCT2BL99T"; // <-- 여기 꼭 앱 비밀번호 넣으세요

        System.out.println("== SMTP PROBE TEST START ==");
        
        Properties p = new Properties();
        p.put("mail.smtp.host", host);
        p.put("mail.smtp.auth", "true");
        p.put("mail.smtp.port", "465");
        p.put("mail.smtp.ssl.enable", "true");
        p.put("mail.smtp.starttls.enable", "false");
        p.put("mail.smtp.ssl.protocols", "TLSv1.2");
        p.put("mail.smtp.ssl.trust", host);

        Session s = Session.getInstance(p, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, pass);
            }
        });
        s.setDebug(true); // ★ SMTP 대화 로그 출력됨

        Transport t = null;
        try {
            t = s.getTransport("smtp");
            t.connect();
            System.out.println("[OK] 465 SSL 연결/인증 성공");
        } finally {
            if (t != null) t.close();
        }
    }
}
