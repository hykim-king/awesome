<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>이메일 인증 결과</title>
  <style>
    body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Apple SD Gothic Neo,Noto Sans KR,sans-serif;margin:0;background:#f7fafc;color:#0f172a}
    .wrap{max-width:420px;margin:64px auto;padding:28px 22px;background:#fff;border-radius:16px;box-shadow:0 10px 30px rgba(15,23,42,.08)}
    h1{font-size:20px;margin:0 0 8px}
    p{margin:6px 0 0}
    .ok{color:#15803d}
    .fail{color:#b91c1c}
    a.btn{display:inline-block;margin-top:14px;padding:10px 14px;background:#84cc16;color:#fff;border-radius:10px;text-decoration:none}
  </style>
</head>
<body>
<div class="wrap">
  <c:choose>
    <c:when test="${verified == true}">
      <h1 class="ok">이메일 인증이 완료되었습니다.</h1>
      <p>이제 로그인을 진행해 주세요.</p>
      <a class="btn" href="<c:url value='/member/login.do'/>">로그인하기</a>
    </c:when>
    <c:otherwise>
      <h1 class="fail">이메일 인증에 실패했습니다.</h1>
      <p>토큰이 유효하지 않거나 만료되었을 수 있어요.</p>
      <a class="btn" href="<c:url value='/member/register.do'/>">다시 시도</a>
    </c:otherwise>
  </c:choose>
</div>
</body>
</html>
