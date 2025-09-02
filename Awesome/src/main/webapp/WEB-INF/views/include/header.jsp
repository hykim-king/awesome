<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<header id="header">
  <div class="navbar">

    <!-- 상단 중앙: 로고 -->
    <div class="logo-wrap">
      <a class="logo" href="${ctx}/mainPage/main.do">Hot Issue</a>
    </div>

    <!-- 중앙: 메인 메뉴 -->
    <nav class="nav-center">
      <ul class="main-menu">
        <li><a href="${ctx}/mainPage/main.do">메인</a></li>
        <li><a href="<c:url value='/intro/hotissue.do'/>">핫이슈 소개</a></li>

        <!-- 기사 보기 + 카테고리 팝업 -->
        <li class="has-popover">
          <a href="${ctx}/article/list.do" id="articleBtn">기사 보기</a>
          <div id="articleMenu" class="menu-popover">
            <a href="${ctx}/article/list.do">전체 기사</a>
            <a href="${ctx}/article/list.do?category=10">정치</a>
            <a href="${ctx}/article/list.do?category=20">경제</a>
            <a href="${ctx}/article/list.do?category=30">사회</a>
            <a href="${ctx}/article/list.do?category=50">연예</a>
            <a href="${ctx}/article/list.do?category=40">스포츠</a>
            <a href="${ctx}/article/list.do?category=60">IT/과학</a>
          </div>
        </li>
        <li><a href="${ctx}/quiz/main.do">퀴즈</a></li>
        <li><a href="<c:url value='/mypage'/>">마이페이지</a></li>
      </ul>
    </nav>

    <!-- 우측: 닉네임 + 사용자 메뉴 -->
    <div class="nav-right">
      <c:if test="${not empty sessionScope.loginUser}">
        <span class="nickname-name">${sessionScope.loginUser.nickNm}<a class="nickname">님 안녕하세요</a></span>
      </c:if>
      <div class="user-menu">
        <button id="userBtn" class="user-icon" type="button">
          <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
            <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4"/>
          </svg>
        </button>
        <div id="userMenu" class="user-popover">
          <c:choose>
            <c:when test="${not empty sessionScope.loginUser}">
              <a href="<c:url value='/mypage'/>">마이페이지</a>
              <a href="<c:url value='/mypage/userInfo.do'/>">회원정보</a>
              <a href="<c:url value='/member/logout.do'/>">로그아웃</a>
            </c:when>
            <c:otherwise>
              <a href="<c:url value='/member/login.do'/>">로그인</a>
              <a href="<c:url value='/member/register.do'/>">회원가입</a>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

  </div>
</header>

<script>
document.addEventListener("DOMContentLoaded", function(){

  // ✅ 공용 토글 함수
  function initToggle(btnId, menuId) {
    const btn  = document.getElementById(btnId);
    const menu = document.getElementById(menuId);
    if(!btn || !menu) return;

    btn.addEventListener('click', function(e){
      e.preventDefault();
      const isOpen = menu.style.display === 'block';
      menu.style.display = isOpen ? 'none' : 'block';
      btn.setAttribute('aria-expanded', String(!isOpen));
    });

    // 바깥 클릭 시 닫힘
    document.addEventListener('click', function(e){
      if (!menu.contains(e.target) && !btn.contains(e.target)){
        menu.style.display = 'none';
        btn.setAttribute('aria-expanded','false');
      }
    });

    // ESC 누르면 닫힘
    document.addEventListener('keydown', function(e){
      if(e.key === 'Escape'){
        menu.style.display = 'none';
        btn.setAttribute('aria-expanded','false');
      }
    });
  }

  // ✅ 초기화: 사용자 메뉴 + 기사 메뉴
  initToggle('userBtn', 'userMenu');       // 오른쪽 유저 메뉴
  initToggle('articleBtn', 'articleMenu'); // 기사 보기 메뉴
});
</script>

