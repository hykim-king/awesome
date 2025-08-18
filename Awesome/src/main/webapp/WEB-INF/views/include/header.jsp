<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>   

<!--header-->
<header id="header">
<div class="navbar">
<div class="menu-bar">
  <div class="navbar-left">
    <div class="logo">HotIssue</div>
    <ul class="main-menu">
      <li><a href="#">홈</a></li>
      <li><a href="#">퀴즈</a></li>
      <li><a href="#">전체기사</a></li>
      <li><a href="#">마이페이지</a></li>
      <li class="has-submenu">
        <div class="submenu-box">
        <ul class="submenu">
          <li><a href="#">정치</a></li>
          <li><a href="#">경제</a></li>
          <li><a href="#">사회</a></li>
          <li><a href="#">연예</a></li>
          <li><a href="#">스포츠</a></li>
          <li><a href="#">IT/과학</a></li>
        </ul>
        </div>
      </li>
    </ul>
  </div>

  <div class="navbar-right">
  
  <c:choose>
  <c:when test="${not empty sessionScope.userId}">
    <!-- 로그인 상태 -->
    <span>${sessionScope.userId}님</span>
    <a href="/ehr/login/logout.do">로그아웃</a>
  </c:when>
  <c:otherwise>
    <!-- 비로그인 상태 -->
    <a href="/ehr/login/login.do">로그인</a>
    <a href="/ehr/membership/doSaveView.do">회원가입</a>
  </c:otherwise>
</c:choose>
  </div>
</div>
</div>

</header>
<!--//header end------------------->    