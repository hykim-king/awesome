<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>회원가입</title>
  <style>
    body{font-family:system-ui,-apple-system,Segoe UI,Roboto,"Noto Sans KR",sans-serif;background:#f7f7fb;margin:0}
    .wrap{max-width:520px;margin:48px auto;background:#fff;border-radius:12px;box-shadow:0 10px 30px rgba(0,0,0,.08);padding:24px}
    h1{margin:0 0 16px;font-size:22px}
    .msg{margin:8px 0 16px;font-size:14px}
    .msg.ok{color:#15803d}.msg.err{color:#dc2626}
    .group{margin:12px 0}
    label{display:block;margin-bottom:6px;font-weight:700}
    input{width:100%;height:44px;padding:0 12px;border:1px solid #e5e7eb;border-radius:10px;background:#f9fafb}
    input:focus{outline:none;border-color:#6366f1;box-shadow:0 0 0 4px rgba(99,102,241,.15);background:#fff}
    .btn{display:block;width:100%;height:48px;border:0;border-radius:12px;background:#6366f1;color:#fff;font-weight:700;margin-top:18px;cursor:pointer}
    .row{display:flex;gap:10px}
  </style>
</head>
<body>
<div class="wrap">
  <h1>회원가입</h1>

  <c:if test="${not empty message}">
    <div class="msg ok">${message}</div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="msg err">${error}</div>
  </c:if>

  <c:set var="form" value="${form}" />

  <form method="post" action="<c:url value='/member/register.do'/>" id="joinForm">
    <div class="group">
      <label for="userId">아이디</label>
      <input id="userId" name="userId" type="text" required
             value="${form != null ? fn:escapeXml(form.userId) : ''}">
    </div>

    <div class="group">
      <label for="pwd">비밀번호</label>
      <input id="pwd" name="pwd" type="password" minlength="8" maxlength="20" required>
    </div>

    <div class="group">
      <label for="pwd2">비밀번호 확인</label>
      <input id="pwd2" type="password" minlength="8" maxlength="20" required>
    </div>

    <div class="group">
      <label for="userNm">이름</label>
      <input id="userNm" name="userNm" type="text" required
             value="${form != null ? fn:escapeXml(form.userNm) : ''}">
    </div>

    <div class="group">
      <label for="nickNm">닉네임</label>
      <input id="nickNm" name="nickNm" type="text" required
             value="${form != null ? fn:escapeXml(form.nickNm) : ''}">
    </div>

    <div class="group">
      <label for="birthDt">생년월일</label>
      <input id="birthDt" name="birthDt" type="date"
             value="${form != null ? fn:escapeXml(form.birthDt) : ''}">
    </div>

    <div class="group">
      <label for="mailAddr">이메일</label>
      <input id="mailAddr" name="mailAddr" type="email" required
             value="${form != null ? fn:escapeXml(form.mailAddr) : ''}">
    </div>

    <!-- 기본 회원등급 -->
    <input type="hidden" name="userGradeCd" value="1"/>

    <button type="submit" class="btn">회원가입 완료</button>
  </form>
</div>

<script>
  // 간단한 클라이언트 검증: 비밀번호 일치
  document.getElementById('joinForm').addEventListener('submit', function(e){
    const p1 = document.getElementById('pwd').value;
    const p2 = document.getElementById('pwd2').value;
    if(p1 !== p2){
      e.preventDefault();
      alert('비밀번호가 일치하지 않습니다.');
    }
  });
</script>
</body>
</html>
