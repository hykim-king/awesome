<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>로그인</title>
  <style>
    :root{--bg:#f7fafc;--card:#ffffff;--text:#0f172a;--line:#e5e7eb;--green:#84cc16;--green-dark:#65a30d}
    *{box-sizing:border-box} body{margin:0;background:var(--bg);color:var(--text);
      font-family:Inter,Pretendard,system-ui,-apple-system,Segoe UI,Roboto,Apple SD Gothic Neo,Noto Sans KR,Malgun Gothic,sans-serif}
    .wrap{max-width:360px;margin:60px auto;padding:28px 22px;background:var(--card);
      border-radius:16px;box-shadow:0 10px 30px rgba(15,23,42,.08)}
    h1{font-size:22px;font-weight:800;text-align:center;margin:4px 0 18px}
    .group{margin-bottom:14px}
    label{display:block;font-size:13px;font-weight:700;margin:0 0 6px}
    input[type="text"],input[type="password"]{width:100%;height:44px;padding:0 12px;border:1px solid var(--line);
      border-radius:10px;background:#f9fafb;font-size:14px;outline:none}
    input:focus{border-color:var(--green);box-shadow:0 0 0 4px rgba(132,204,22,.2);background:#fff}
    .row{display:flex;justify-content:space-between;align-items:center}
    .btn{width:100%;height:46px;border:0;border-radius:12px;background:var(--green);color:#fff;
      font-weight:700;cursor:pointer} .btn:hover{background:var(--green-dark)}
    .note{font-size:12px;color:#475569;margin:8px 0 0;text-align:center}
    .msg{font-size:13px;margin:0 0 10px;text-align:center}
    .msg.ok{color:#15803d}.msg.err{color:#b91c1c}
  </style>
</head>
<body>
<div class="wrap">
  <h1>로그인</h1>

  <!-- 가입/로그인 리다이렉트 메시지 표시 -->
  <c:if test="${not empty message}">
    <div class="msg ok">${message}</div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="msg err">${error}</div>
  </c:if>

  <form id="loginForm" method="post" action="<c:url value='/member/login.do'/>">
    <div class="group">
      <label for="userId">아이디</label>
      <input id="userId" name="userId" type="text" required />
    </div>
    <div class="group">
      <label for="pwd">비밀번호</label>
      <input id="pwd" name="pwd" type="password" required />
    </div>

    <button class="btn" type="submit">로그인</button>

    <p class="note">
      아직 회원이 아니신가요?
      <a href="<c:url value='/member/register.do'/>">회원가입</a>
    </p>
  </form>
</div>

<script>
  // 간단한 클라이언트 검증
  document.getElementById('loginForm').addEventListener('submit', function(e){
    var id = document.getElementById('userId').value.trim();
    var pw = document.getElementById('pwd').value.trim();
    if(!id || !pw){
      e.preventDefault();
      alert('아이디와 비밀번호를 입력하세요.');
    }
  });
</script>
</body>
</html>