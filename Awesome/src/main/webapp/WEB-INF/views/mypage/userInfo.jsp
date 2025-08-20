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
	    <h2>회원정보</h2>
		<div class="userInfo-box">
		  <h3>아이디</h3>
		  <p>${user.userId}</p>
		
		  <h3>이름</h3>
		  <p>${user.name}</p>
		
		  <h3>닉네임</h3>
		  <p>${user.nickname}</p>
		
		  <h3>생년월일</h3>
		  <p><fmt:formatDate value="${user.birth}" pattern="yyyy-MM-dd"/></p>
		
		  <h3>이메일</h3>
		  <p>${user.email}</p>
		</div>
		
		<div class="button-box">
		  <a href="${pageContext.request.contextPath}/mypage/edit.do">수정</a>
		  <a href="${pageContext.request.contextPath}/mypage/delete.do">탈퇴</a>
		</div>
	  </div>
	</main>
</body>
</html>