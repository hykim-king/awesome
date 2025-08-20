<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
    <main id="main">
      <div class="main-container">
		<h2>회원정보 수정</h2>
		<form action="${pageContext.request.contextPath}/mypage/update.do" method="post">
		  <label>아이디</label>
		  <input type="text" name="userId" value="${user.userId}" readonly>
		
		  <label>이름</label>
		  <input type="text" name="name" value="${user.name}" readonly>
		
		  <label>닉네임</label>
		  <input type="text" name="nickname" value="${user.nickname}">
		
		  <label>생년월일</label>
		  <input type="date" name="birth" value="${user.birth}" readonly>
		
		  <label>이메일</label>
		  <input type="email" name="email" value="${user.email}">
		
		  <div class="button-box">
		    <a href="${pageContext.request.contextPath}/mypage/changePassword.do">비밀번호 변경</a>
		    <button type="submit">저장</button>
		    <a href="${pageContext.request.contextPath}/mypage/userInfo.do">취소</a>
		  </div>
		</form>
      </div>
    </main>
</body>
</html>