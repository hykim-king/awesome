<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>   
<c:set var="CP" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${CP}/resources/css/userInfo.css">
<link rel="stylesheet" href="/ehr/resources/css/pcwk_main.css">
<link rel="stylesheet" href="/ehr/resources/css/header.css">
<title>회원정보</title>
</head>
<body>
   <div id="container">
   
    <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/include/sidebar.jsp"></jsp:include>
      <!--main-->
      <main id="main">
      <div class="main-container">
	    <h2>회원정보</h2>
		<div class="userInfo-box">
		  <h3>아이디</h3>
		  <p>${user.userId}</p>
		
		  <h3>이름</h3>
		  <p>${user.userNm}</p>
		
		  <h3>닉네임</h3>
		  <p>${user.nickNm}</p>
		
		  <h3>생년월일</h3>
		  <p>${user.birthDt}</p>
		
		  <h3>이메일</h3>
		  <p>${user.mailAddr}</p>
		</div>
		
		<div class="button-box">
		  <a href="${pageContext.request.contextPath}/mypage/edit.do">수정</a>
		  <a href="${pageContext.request.contextPath}/mypage/delete.do">탈퇴</a>
		</div>
	  </div>
	</main>
	
  <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
   </div> 
</body>
</html>