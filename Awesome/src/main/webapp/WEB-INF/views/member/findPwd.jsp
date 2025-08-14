<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="CP" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>비밀번호 찾기</title>
  <link rel="stylesheet" href="<c:url value='/resources/css/pcwk_main.css'/>">
  <link rel="stylesheet" href="<c:url value='/resources/css/header.css'/>">
  <style>
    /* findId와 동일 스타일 */
    :root{--bg:#f7fafc;--card:#fff;--text:#0f172a;--line:#e5e7eb;--green:#84cc16;--green-dark:#65a30d}
    *{box-sizing:border-box}
    body{margin:0;background:var(--bg);color:var(--text);font-family:Inter,Pretendard,system-ui,-apple-system,Segoe UI,Roboto,Apple SD Gothic Neo,Noto Sans KR,Malgun Gothic,sans-serif}
    .wrap{max-width:420px;margin:60px 0;position:relative;left:50vw;transform:translateX(-50%);
      background:var(--card);border-radius:16px;box-shadow:0 10px 30px rgba(15,23,42,.08);padding:28px 22px}
    h1{font-size:22px;font-weight:800;text-align:center;margin:4px 0 18px}
    .group{margin-bottom:14px}
    label{display:block;font-size:13px;font-weight:700;margin:0 0 6px}
    input{width:100%;height:44px;padding:0 12px;border:1px solid var(--line);border-radius:10px;background:#f9fafb;font-size:14px}
    input:focus{border-color:var(--green);box-shadow:0 0 0 4px rgba(132,204,22,.2);background:#fff}
    .btn{width:100%;height:46px;border:0;border-radius:12px;background:var(--green);color:#fff;font-weight:700;cursor:pointer}
    .btn:hover{background:var(--green-dark)}
    .note{text-align:center;font-size:12px;color:#475569;margin-top:10px}
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/include/header.jsp"/>
  <div class="wrap">
    <h1>비밀번호 찾기</h1>

    <form method="post" action="<c:url value='/member/findPwd.do'/>">
      <div class="group">
        <label for="userId">아이디</label>
        <input id="userId" name="userId" type="text" required>
      </div>
      <div class="group">
        <label for="mailAddr">가입 이메일</label>
        <input id="mailAddr" name="mailAddr" type="email" required>
      </div>
      <button class="btn" type="submit">재설정 메일 보내기</button>
      <p class="note"><a href="<c:url value='/member/login.do'/>">로그인으로 돌아가기</a></p>
    </form>
  </div>
  <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</body>
</html>
