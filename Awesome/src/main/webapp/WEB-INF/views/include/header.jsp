<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<% response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires", 0);%>



<!--header-->
<header id="header">
<div class="navbar">
<div class="menu-bar">
  <div class="navbar-left">
    <div class="logo">HotIssue</div>
    <ul class="main-menu">
      <li><a href="#">홈</a></li>
      <li><a href="#">퀴즈</a></li>
      <li><a href="http://localhost:8080/ehr/article/list.do">전체기사</a></li>
      <li><a href="<c:url value='/mypage'/>">마이페이지</a></li>
      <li class="has-submenu">
        <div class="submenu-box">
        <%-- 현재 카테고리 값을 param/category 중 하나로 통일 --%>
<c:set var="curCat" value="${empty category ? param.category : category}" />

<%-- 각 링크 URL --%>
<c:url var="cate10"  value="/article/list.do"><c:param name="category" value="10"/></c:url>
<c:url var="cate20"  value="/article/list.do"><c:param name="category" value="20"/></c:url>
<c:url var="cate30"  value="/article/list.do"><c:param name="category" value="30"/></c:url>
<c:url var="cate40"  value="/article/list.do"><c:param name="category" value="40"/></c:url>
<c:url var="cate50"  value="/article/list.do"><c:param name="category" value="50"/></c:url>
<c:url var="cate60"  value="/article/list.do"><c:param name="category" value="60"/></c:url>

<ul class="submenu">
  <li><a href="${cate10}" class="${curCat == 10 || curCat == '10' ? 'active' : ''}">정치</a></li>
  <li><a href="${cate20}" class="${curCat == 20 || curCat == '20' ? 'active' : ''}">경제</a></li>
  <li><a href="${cate30}" class="${curCat == 30 || curCat == '30' ? 'active' : ''}">사회</a></li>
  <li><a href="${cate50}" class="${curCat == 50 || curCat == '50' ? 'active' : ''}">연예</a></li>
  <li><a href="${cate40}" class="${curCat == 40 || curCat == '40' ? 'active' : ''}">스포츠</a></li>
  <li><a href="${cate60}" class="${curCat == 60 || curCat == '60' ? 'active' : ''}">IT/과학</a></li>
</ul>
        </div>
      </li>
    </ul>
  </div>

  <div class="navbar-right">
  
  <c:choose>
  <c:when test="${not empty sessionScope.loginUser}">
<!-- 로그인 상태 -->
    <span>${sessionScope.loginUser.userId}님</span>
    <a href="<c:url value='/member/logout.do'/>">로그아웃</a>
  </c:when>
  <c:otherwise>
    <!-- 비로그인 상태 -->
    <a href="<c:url value='/member/login.do'/>">로그인</a>
    <a href="<c:url value='/member/register.do'/>">회원가입</a>
  </c:otherwise>
</c:choose>
  </div>
</div>
</div>

</header>
<!--//header end------------------->    