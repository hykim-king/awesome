<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="CP" value="${pageContext.request.contextPath }" /> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="/ehr/resources/css/pcwk_main.css">
<link rel="stylesheet" href="/ehr/resources/css/header.css">
<link rel="stylesheet" href="/ehr/resources/css/intro.css">
<c:url var="bannerImg" value="/resources/file/banner.png"/>

<style>

/* 소개 페이지 전용 레이아웃 */
.page-intro #container{
  grid-template-areas:
    "header header header header"
    "banner banner banner banner"   /* ← 헤더 아래 배너 */
    "leftsidebar main   main   sidebar"
    "footer footer footer footer";
  grid-template-rows: auto auto minmax(650px,auto) 100px;
}

/* 배너 스타일 (이미 쓰던 introBanner 그대로) */
.page-intro #container > .category-hero{
  grid-area: banner;
  grid-column: 1 / -1;

  /* 레이아웃/크기 */
  width: 100%;
  max-width: none;
  margin: 0 0 12px;
  border-radius: 0;      

  /* 배경(오버레이 + 이미지) */
  background:
    linear-gradient(to right, rgba(0,0,0,.30), rgba(0,0,0,.15)),
    url('${bannerImg}') center/cover no-repeat;
  color: #fff;
  min-height: 100px;      

  /* 텍스트 중앙 정렬 */
  display: grid;
  place-items: center;    
  padding: 0 20px;  
}

/* 타이틀 */
.page-intro .category-hero h1{
  margin: 0;
  font-size: 28px;        
  font-weight: 800;
  letter-spacing: .2px;
  text-shadow: 0 2px 8px rgba(0,0,0,.35); 
}

/* 헤더와 배너 사이 그리드 간격만 0으로 */
.page-intro #container { row-gap: 0 !important; }

/* 배너만 살짝 내리기 — 숫자만 조절해서 미세 튜닝 */
.page-intro #container > .category-hero{
  margin-top: 0px !important;
}

</style>

<title>핫이슈 소개</title>
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>


<body class = "page-intro">
  <div id="container">

    <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>

        <!-- 배너 -->
    <section class="category-hero" role="banner" aria-label="핫이슈 소개">
      <h1>핫이슈 소개</h1>
    </section>
    
    <jsp:include page="/WEB-INF/views/chatBot/chatBot.jsp"></jsp:include>

    <!-- main -->
    <main id="intro-main">

      <!-- Hero Section -->
      <section class="intro-hero">
        <!-- 왼쪽 텍스트 -->
        <div class="hero-content">
    <h1>뉴스 빅데이터 플랫폼,<br>Hot Issue</h1>
    <p>핫이슈는 최신 뉴스와 데이터를 분석하고,<br>사용자에게 맞춤형 정보를 제공합니다.</p>
  </div>

        <!-- 오른쪽 이미지 -->
        <div class="hero-image">
          <img src="${CP}/resources/file/intro-banner.png" alt="HotIssue 소개 이미지">
        </div>
      </section>

	    <!-- Features -->
  <section class="intro-features">
    <div class="feature">
      <h3>실시간 뉴스</h3>
      <p>정치, 경제, 스포츠, IT 등 다양한 카테고리의 실시간 뉴스 제공</p>
    </div>
    <div class="feature">
      <h3>커뮤니티</h3>
      <p>채팅 기능으로 사용자 간의 활발한 소통</p>
    </div>
    <div class="feature">
      <h3>퀴즈 & 랭킹</h3>
      <p>재미있는 퀴즈와 랭킹 시스템으로 뉴스 학습</p>
    </div>
  </section>
	  

      
	     <!-- 조직도 -->
	<section id="team">
	  <div class="team-container">
	    <h2 class="section-title">핫이슈 팀</h2>
	    <div class="team-grid">
	      <div class="team-card hidden">
	        <img src="${CP}/resources/file/team1.png" alt="member">
	        <h3>팀장</h3>
	        <p>이종민</p>
	      </div>
	      <div class="team-card hidden">
	        <img src="${CP}/resources/file/team2.png" alt="member">
	        <h3>팀원</h3>
	        <p>가민경</p>
	      </div>
	      <div class="team-card hidden">
	        <img src="${CP}/resources/file/team3.png" alt="member">
	        <h3>팀원</h3>
	        <p>임두나</p>
	      </div>
	      <div class="team-card hidden">
	        <img src="${CP}/resources/file/team4.png" alt="member">
	        <h3>팀원</h3>
	        <p>이병헌</p>
	      </div>
	      <div class="team-card hidden">
	        <img src="${CP}/resources/file/team5.png" alt="member">
	        <h3>팀원</h3>
	        <p>정유성</p>
	      </div>
	      <div class="team-card hidden">
	        <img src="${CP}/resources/file/team6.png" alt="member">
	        <h3>팀원</h3>
	        <p>양승현</p>
	      </div>
	    </div>
	  </div>
	</section> 
      
    <!-- 맨 위로 버튼 -->
	<button id="backToTop" title="맨 위로">⬆</button>
      
    </main>
    <!--//main end-------------------->

 <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
   </div> 
   
<script>
  const toTop = document.getElementById('backToTop');

  // 스크롤 내려가면 표시 / 맨 위면 숨김
  window.addEventListener('scroll', () => {
    const y = window.scrollY || document.documentElement.scrollTop;
    toTop.classList.toggle('show', y > 200);   // 200px 내려가면 표시 (원하면 수치 조정)
  });

  // 클릭 시 맨 위로
  toTop.addEventListener('click', () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });
</script>
   
</body>
</html>