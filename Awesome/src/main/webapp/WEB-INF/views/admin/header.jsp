<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="<c:url value='/resources/css/admin.css'/>">

<meta charset="UTF-8">
<title>헤더</title>
</head>
<body>
  <!-- 관리자 전용 메뉴: 관리자(userGradeCd == 0)만 보임 -->
  <c:if test="${sessionScope.loginUser.userGradeCd == 0}">
    <a href="<c:url value='/admin/dashboard.do'/>">관리자</a>
  </c:if>
</body>
</html>
