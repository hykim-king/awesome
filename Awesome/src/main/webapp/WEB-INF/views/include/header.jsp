<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<% response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires", 0);%>



<!--header-->
<header id="header">
  <div class="navbar">
    <!-- 좌: 로고 -->
    <div class="nav-left">
      <a class="logo" href="http://localhost:8080/ehr/mainPage/main.do">
        <img src="<c:url value='/resources/file/logo_hotissue.png'/>" alt="HotIssue">
      </a>
    </div>

    <!-- 가운데: 메인 메뉴 (중앙 정렬) -->
    <nav class="nav-center">
      <ul class="main-menu">
        <li><a href="http://localhost:8080/ehr/mainPage/main.do">메인</a></li>
        <li><a href="http://localhost:8080/ehr/quiz/main.do">퀴즈</a></li>
        <li><a href="http://localhost:8080/ehr/article/list.do">기사 보기</a></li>
        <li><a href="<c:url value='/mypage'/>">마이페이지</a></li>
      </ul>
    </nav>

    <!-- 우: 사용자 아이콘 + 팝오버 메뉴 -->
    <div class="nav-right">
      <div class="user-menu">
        <button id="userBtn" class="user-icon" aria-haspopup="menu" aria-expanded="false" type="button">
          <!-- bootstrap person icon -->
          <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
            <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4"/>
          </svg>
        </button>

        <!-- 드롭다운(팝오버) -->
        <div id="userMenu" class="user-popover" role="menu" aria-labelledby="userBtn">
          <c:choose>
            <c:when test="${not empty sessionScope.loginUser}">
              <a href="<c:url value='/mypage'/>" role="menuitem">마이페이지</a>
              <a href="<c:url value='/member/logout.do'/>" role="menuitem">로그아웃</a>
            </c:when>
            <c:otherwise>
              <a href="<c:url value='/member/login.do'/>" role="menuitem">로그인</a>
              <a href="<c:url value='/member/register.do'/>" role="menuitem">회원가입</a>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </div>


<%-- 각 링크 URL --%> 
<c:url var="cate10" value="/article/list.do"><c:param name="category" value="10"/></c:url> 
<c:url var="cate20" value="/article/list.do"><c:param name="category" value="20"/></c:url> 
<c:url var="cate30" value="/article/list.do"><c:param name="category" value="30"/></c:url> 
<c:url var="cate40" value="/article/list.do"><c:param name="category" value="40"/></c:url> 
<c:url var="cate50" value="/article/list.do"><c:param name="category" value="50"/></c:url> 
<c:url var="cate60" value="/article/list.do"><c:param name="category" value="60"/></c:url>

  <div class="category-bar">
	<ul class="submenu"> 
	    <li><a href="${cate10}" class="${curCat == 10 || curCat == '10' ? 'active' : ''}">정치</a></li> 
	    <li><a href="${cate20}" class="${curCat == 20 || curCat == '20' ? 'active' : ''}">경제</a></li> 
	    <li><a href="${cate30}" class="${curCat == 30 || curCat == '30' ? 'active' : ''}">사회</a></li> 
	    <li><a href="${cate50}" class="${curCat == 50 || curCat == '50' ? 'active' : ''}">연예</a></li> 
	    <li><a href="${cate40}" class="${curCat == 40 || curCat == '40' ? 'active' : ''}">스포츠</a></li> 
	    <li><a href="${cate60}" class="${curCat == 60 || curCat == '60' ? 'active' : ''}">IT/과학</a></li> 
	</ul>
  </div>
</header>


<!--//header end------------------->    

<script>
  (function(){
    const btn  = document.getElementById('userBtn');
    const menu = document.getElementById('userMenu');

    if(!btn || !menu) return;

    btn.addEventListener('click', function(e){
      e.preventDefault();
      const open = menu.style.display === 'block';
      menu.style.display = open ? 'none' : 'block';
      btn.setAttribute('aria-expanded', String(!open));
    });

    document.addEventListener('click', function(e){
      if (!menu.contains(e.target) && !btn.contains(e.target)){
        menu.style.display = 'none';
        btn.setAttribute('aria-expanded', 'false');
      }
    });

    // ESC 닫기
    document.addEventListener('keydown', function(e){
      if(e.key === 'Escape'){ menu.style.display = 'none'; btn.setAttribute('aria-expanded','false'); }
    });
  })();
</script>
