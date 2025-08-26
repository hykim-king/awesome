<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="UTF-8">
  <title>MainPage</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/MainPage.css"><!--디자인불러옴 -->
  <link rel="stylesheet" href="<c:url value='/resources/css/header.css?v=3'/>">
</head>
<body>
<!--header-->
<header id="header">
  <div class="navbar">
    <div class="menu-bar">
      <div class="navbar-left">
<a href="http://localhost:8080/ehr/mainPage/main.do" class="logo">HotIssue</a>
        <ul class="main-menu">
          <li><a href="http://localhost:8080/ehr/mainPage/main.do">홈</a></li>
          <li><a href="http://localhost:8080/ehr/article/list.do">퀴즈</a></li>
          <li><a href="http://localhost:8080/ehr/article/list.do">전체기사</a></li>
          <li><a href="<c:url value='/mypage'/>">마이페이지</a></li>
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

  <!---------------------- #1 Today’s HOT ISSUE + 키워드 6개 -->
<section id="main-hot-issue">
<!-- 배경이랑 키워드 섹션분리 -->
  <div class="hot-issue-inner">

  <div class="keywords-left">
    <c:forEach var="k" items="${keywords}" varStatus="st">
      <c:if test="${st.index lt 3}">
       <c:set var="kwRaw" value="${k.keyword}" />
<c:set var="idx1" value="${fn:indexOf(kwRaw, '(')}" />
<c:set var="idx2" value="${fn:indexOf(kwRaw, '（')}" />
<c:choose>
  <c:when test="${idx1 ne -1}">
    <c:set var="kwClean" value="${fn:trim(fn:substring(kwRaw, 0, idx1))}" />
  </c:when>
  <c:when test="${idx2 ne -1}">
    <c:set var="kwClean" value="${fn:trim(fn:substring(kwRaw, 0, idx2))}" />
  </c:when>
  <c:otherwise>
    <c:set var="kwClean" value="${fn:trim(kwRaw)}" />
  </c:otherwise>
</c:choose>

<c:url var="kwUrl" value="${k.link}">
  <c:param name="pageNum"    value="1"/>
  <c:param name="pageSize"   value="20"/>
  <c:param name="searchDiv"  value="10"/>          <!-- 제목 검색 -->
  <c:param name="searchWord" value="${kwClean}"/>  <!-- 괄호 앞부분만 -->
</c:url>

<a class="keyword" href="${kwUrl}">
  <c:out value="${kwRaw}" />
</a>
      </c:if>
    </c:forEach>
  </div>
  <div class="hot-title">
<!--  텍스트 삭제 GIF로 대체 -->
  </div>
  <div class="keywords-right">
    <c:forEach var="k" items="${keywords}" varStatus="st">
      <c:if test="${st.index ge 3}">
        <c:set var="kwRaw" value="${k.keyword}" />
<c:set var="idx1" value="${fn:indexOf(kwRaw, '(')}" />
<c:set var="idx2" value="${fn:indexOf(kwRaw, '（')}" />
<c:choose>
  <c:when test="${idx1 ne -1}">
    <c:set var="kwClean" value="${fn:trim(fn:substring(kwRaw, 0, idx1))}" />
  </c:when>
  <c:when test="${idx2 ne -1}">
    <c:set var="kwClean" value="${fn:trim(fn:substring(kwRaw, 0, idx2))}" />
  </c:when>
  <c:otherwise>
    <c:set var="kwClean" value="${fn:trim(kwRaw)}" />
  </c:otherwise>
</c:choose>

<c:url var="kwUrl" value="${k.link}">
  <c:param name="pageNum"    value="1"/>
  <c:param name="pageSize"   value="20"/>
  <c:param name="searchDiv"  value="10"/>          <!-- 제목 검색 -->
  <c:param name="searchWord" value="${kwClean}"/>  <!-- 괄호 앞부분만 -->
</c:url>

<a class="keyword" href="${kwUrl}">
  <c:out value="${kwRaw}" />
</a>
      </c:if>
    </c:forEach>

  <c:if test="${empty keywords}">
    <p>키워드를 불러오는 중입니다.</p>
  </c:if>
</div>
</div> 
  </section>

  <!--------------------------------------- #2 조회수 기반 인기 기사 -->
<section id="main-popular">
  <div class="section-box">
    <h2>조회수 기반 인기 기사</h2>

    <ul class="popular-grid">
      <c:forEach var="item" items="${popularArticles}">
        <li class="popular-card">
          <a href="${item.url}" target="_blank">
            
            <!-- 아이콘 영역 -->
            <div class="icon">
              <c:choose>
                <c:when test="${item.category == 10}">
                  <img src="${ctx}/resources/img/politics.png" alt="정치" />
                </c:when>
                <c:when test="${item.category == 20}">
                  <img src="${ctx}/resources/img/economy.png" alt="경제" />
                </c:when>
                <c:when test="${item.category == 30}">
                  <img src="${ctx}/resources/img/society.png" alt="사회/문화" />
                </c:when>
                <c:when test="${item.category == 40}">
                  <img src="${ctx}/resources/img/sports.png" alt="스포츠" />
                </c:when>
                <c:when test="${item.category == 50}">
                  <img src="${ctx}/resources/img/ent.png" alt="연예" />
                </c:when>
                <c:when test="${item.category == 60}">
                  <img src="${ctx}/resources/img/it.png" alt="IT/과학" />
                </c:when>
                <c:otherwise>
                  <img src="${ctx}/resources/img/etc.png" alt="기타" />
                </c:otherwise>
              </c:choose>
            </div>

            <!-- 기사 제목 -->
            <div class="title"><c:out value="${item.title}"/></div>
          </a>
        </li>
      </c:forEach>

      <c:if test="${empty popularArticles}">
        <li>인기 기사 수집 중…</li>
      </c:if>
    </ul>
  </div>
</section>
  
  
<!----------------------------------------------- #3 + #4 묶기 -->
<section id="main-bottom-section">

  <!-- 왼쪽: 추천 기사 -->
  <div class="left">
    <section id="main-recommended">
      <h2>회원별 추천 기사</h2>

      <c:choose>
        <c:when test="${not empty recommended}">
          <ul>
            <c:forEach var="item" items="${recommended}">
              <li><c:out value="${item}" /></li>
            </c:forEach>
          </ul>
        </c:when>
        <c:otherwise>
          <p>로그인하면 추천 기사가 보여요.</p>
        </c:otherwise>
      </c:choose>
    </section>
  </div>

  <!-- 오른쪽: 날씨 -->
<div class="right">
  <section id="main-weather">
  
  <h2>오늘의 날씨</h2>
<jsp:include page="/widget/weather"/>
<%--     <jsp:include page="/WEB-INF/views/widget/weather"/> --%>
<%--   <%@ include file="/WEB-INF/views/widget/weather.jsp" %> --%>


  
  </section>
</div>

</section>

</body>
</html>