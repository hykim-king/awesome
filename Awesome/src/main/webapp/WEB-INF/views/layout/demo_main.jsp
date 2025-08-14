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
<link rel="stylesheet" href="/ehr/resources/css/pcwk_main.css">
<link rel="stylesheet" href="/ehr/resources/css/header.css">
<title>핫이슈</title>
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
   <div id="container">
   
    <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/include/sidebar.jsp"></jsp:include>
      <!--main-->
      <main id="main">
      <div class="main-container">

      <!-- 이 사이에 각자 항목 넣으시면 됩니다! -->

        <c:choose>
	  <!-- 미로그인 -->
	  <c:when test="${empty sessionScope.loginUser}">
	    <div style="display:flex; gap:12px;">
	      <a class="btn" href="<c:url value='/member/login.do'/>">로그인</a>
	      <a class="btn" href="<c:url value='/member/register.do'/>">회원가입</a>
	    </div>
	  </c:when>
	
	  <!-- 로그인 상태 -->
	  <c:otherwise>
	    <div style="display:flex; gap:12px; align-items:center;">
	      <span><strong>${sessionScope.loginUser.userId}</strong>님 환영합니다!</span>
	      <a class="btn" href="<c:url value='/member/logout.do'/>">로그아웃</a>
	    </div>
	  </c:otherwise>
	</c:choose>

        


      </div>
      </main>
      <!--//main end-------------------->

      
 <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
   </div> 
</body>
</html>


   