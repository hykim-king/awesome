package com.pcwk.ehr.interceptor;

import javax.servlet.http.*;
import org.springframework.web.servlet.HandlerInterceptor;

public class AdminOnlyInterceptor implements HandlerInterceptor {
  @Override
  public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object handler) throws Exception {
    HttpSession session = req.getSession(false);
    if (session == null) {
      res.sendRedirect(req.getContextPath() + "/member/login.do");
      return false;
    }
    // 로그인 시 세션에 넣어둘 값: loginUser(DTO) + userGradeCd(0=관리자,1=사용자)
    Object gradeObj = session.getAttribute("userGradeCd");
    int grade = gradeObj == null ? 1 : Integer.parseInt(String.valueOf(gradeObj));
    if (grade != 0) {
      res.sendRedirect(req.getContextPath() + "/error/forbidden.jsp"); // 임시 거절 페이지
      return false;
    }
    return true;
  }
}
