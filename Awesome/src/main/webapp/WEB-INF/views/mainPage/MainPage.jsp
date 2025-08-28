<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="UTF-8">
  <title> HOT ISSUE - 오늘의 흐름을 잡다</title>

  <link rel="stylesheet" href="${ctx}/resources/css/MainPage.css">
  
  
<!--  더보기 박스 강제주입 -->
<style>
.keyword {             
  min-width:300px;                   
  max-width:800px;  
  }

#main-bottom-section{
  display: grid;
  /* 추천기사 : 날씨  =  4 : 1  (날씨 더 작게)  */
  grid-template-columns: 4.5fr 1.5fr;
  gap: 16px;
  align-items: start;
}


/* --- 추천 카드: 라이트 테마 --- */
#main-recommended .rec-cards{
  display:grid;
  grid-template-columns:repeat(3,1fr);
  gap:12px;
  margin-top:8px;
}

#main-recommended .rec-card{
  display:block;
  padding:14px 16px;
  border-radius:14px;
  background:#fff;                 /* 화이트 카드 */
  color:#111;
  text-decoration:none;
  border:1px solid #eee;
  box-shadow:0 6px 18px rgba(0,0,0,.06);
  transition:transform .12s ease, box-shadow .12s ease, border-color .12s ease;
}
#main-recommended .rec-card:hover{
  transform:translateY(-2px);
  box-shadow:0 10px 22px rgba(0,0,0,.09);
  border-color:#e6e6e6;
}

/* 언론사 */
#main-recommended .press-badge{
  display:inline-block;
  font-size:11px;
  line-height:1;
  color:#555;
  background:#f4f6ff;             /* 은은한 블루톤 */
  border:1px solid #e3e9ff;
  border-radius:999px;
  padding:6px 10px;
}

/* 제목 */
#main-recommended .title{
  display:block;
  margin:10px 0 6px;
  font-size:15px;
  font-weight:700;
  line-height:1.35;
  color:#111;
  word-break:keep-all;
}

/* 요약: 제목보다 작고 옅게, 2줄 clamp */
#main-recommended .summary{
  margin:0;
  font-size:13px;                 /* 제목보다 작게 */
  line-height:1.45;
  color:#666;
  display:-webkit-box;
  -webkit-line-clamp:3;           /* 2줄로 줄임 */
  -webkit-box-orient:vertical;
  overflow:hidden;
}

/* 상단 텍스트 링크는 라이트에 맞춰 밑줄 제거 정도만 */
#main-recommended .top-text a{
  color:#111;
  text-decoration:none;
}
#main-recommended .top-text a:hover{
  text-decoration:underline;
}

/* 해더 */

:root{
  --blue:#0a45ff;           /* 상단 바 색 */
  --text:#111;
  
}

*{ box-sizing:border-box; }


/* ===== 헤더 상단 바 ===== */
#header .navbar{ background:transparent; }
#header .menu-bar{
  height:80px;
  background:022ca8;
  display:flex;
  align-items:center;
  padding:0 20px;
}

#header .logo img{
  height:80px;
  display:block;
}

/* 메인 메뉴: 화면 '정중앙' 고정 배치 */
#header .main-menu{
  position:absolute;            /* 부모(menu-bar) 기준 중앙 고정 */
  left:50%;
  transform:translateX(-50%);
  top:0;
  height:55px;
  display:flex;
  align-items:center;
  gap:52px;
  list-style:none;
  margin:0;
  padding:0;
}
#header .main-menu > li > a{
  color:#eaf0ff;                /* 거의 흰색 */
  text-decoration:none;
  font-weight:700;
  font-size:22px;
  opacity:.90;       
  padding:0 2px;
}
#header .main-menu > li > a:hover{
  text-decoration:underline;
  text-underline-offset: 3px;
}

/* 우측 로그인/회원가입 */
#header .navbar-right{
  margin-left:auto;             /* 오른쪽 끝으로 */
  display:flex;
  align-items:center;
  gap:16px;
}
#header .navbar-right a{
  color:#eaf0ff;
  font-size:14px;
  text-decoration:none;
}
#header .navbar-right a:hover{
  text-decoration:underline;
}
/* 로그인한 사용자 색상 */
.user-id {
  color: #FFD54F;      /* 은은한 골드 노랑 (#FFD54F) */
  font-weight: 700;    /* 조금 굵게 */
}

</style>

</head>
<body>

    <!-- 알림 메시지!!!!!!!!!!!!!!! -->
    <c:if test="${not empty msg}">
      <div id="flash-msg" style="display:none;">${fn:escapeXml(msg)}</div>
      <script>
        alert(document.getElementById('flash-msg').textContent);
      </script>
     </c:if>

<!--header-->
<header id="header">
  <div class="navbar">
    <div class="menu-bar">
      <div class="navbar-left">
<a href="http://localhost:8080/ehr/mainPage/main.do" class="logo"><img src="${ctx}/resources/file/logo.png" alt="HotIssue Logo" style="height:40px;">
</a>
        <ul class="main-menu">
          <li><a href="http://localhost:8080/ehr/mainPage/main.do">홈</a></li>
          <li><a href="http://localhost:8080/ehr/quiz/main.do">퀴즈</a></li>
          <li><a href="http://localhost:8080/ehr/article/list.do">전체기사</a></li>
          <li><a href="<c:url value='/mypage'/>">마이페이지</a></li>
        </ul>
      </div>

      <div class="navbar-right">
        <c:choose>
          <c:when test="${not empty sessionScope.loginUser}">
            <!-- 로그인 상태 -->
            <span class="user-id">${sessionScope.loginUser.nickNm} 님 안녕하세요☀️</span>
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
      <h2> 당신을 위한 추천기사</h2>

      <c:choose>
  <%--  메시지 모드: 비로그인 or 로그인했지만 로그 없음 --%>
        <c:when test="${not empty recommendMessage}">
          <p class="mute">${recommendMessage}</p>
        </c:when>

  <%-- 추천 기사 모드 --%>
         <c:otherwise>
      <!-- 1번: 텍스트 -->
      <c:set var="mainRec" value="${personalRecs[0]}" />
      <c:url var="visitMain" value="/article/visit.do">
        <c:param name="articleCode" value="${mainRec.articleCode}" />
      </c:url>
<!-- 대표 추천 1개: 텍스트지만 카드 느낌으로 강조 -->
<div class="top-feature">
   <!-- 인트로 텍스트 -->
  <p class="top-intro">이런 기사는 어때요?</p>

  <!-- 언론사 + 제목 -->
  <div class="top-headline">
    <span class="press-badge"><c:out value="${mainRec.press}" /></span>
    <h3 class="top-title">
      <a href="${visitMain}" target="_blank" rel="noopener noreferrer">
        <c:out value="${mainRec.title}" />
      </a>
    </h3>
  </div>
  <p class="top-summary"><c:out value="${mainRec.summary}" /></p>
</div>


      <%-- 2) 더보기 클릭 시 3개 카드 가로 펼침 --%>
<div style="margin-top:14px"></div>
<details class="more-recs">
  <summary>다른 추천 보기</summary>

        <div class="rec-cards">
  <c:forEach var="it" items="${personalRecs}" begin="1" end="3">
    <c:url var="visitSub" value="/article/visit.do">
      <c:param name="articleCode" value="${it.articleCode}" />
    </c:url>

    <a class="rec-card" href="${visitSub}" target="_blank" rel="noopener noreferrer">
      <span class="press-badge"><c:out value="${it.press}" /></span>
      <strong class="title"><c:out value="${it.title}" /></strong>

      <!-- 요약: 길면 줄임 -->
      <p class="summary">
        <c:out value="${it.summary}" />
      </p>
            </a>
          </c:forEach>
        </div>
      </details>
    </c:otherwise>
  </c:choose>
</section>
  </div>

  <!-- 오른쪽: 날씨 -->
<div class="right">
  <section id="main-weather">
  
  <h4>현재날씨</h4>
<jsp:include page="/widget/weather"/>


  
  </section>
</div>

</section>

</body>
</html>