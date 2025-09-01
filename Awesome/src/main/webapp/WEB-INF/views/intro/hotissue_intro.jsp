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

<title>핫이슈 소개</title>
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>


<body>
  <div id="container">

    <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/chatBot/chatBot.jsp"></jsp:include>

    <!-- main -->
    <main id="intro-main">

      <!-- Hero Section -->
      <section class="intro-hero">
        <!-- 왼쪽 텍스트 -->
        <div class="hero-content">
    <h1>뉴스 빅데이터 플랫폼,<br>HotIssue</h1>
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
	        <img src="https://via.placeholder.com/120" alt="member">
	        <h3>팀원 1</h3>
	        <p>설명</p>
	      </div>
	      <div class="team-card hidden">
	        <img src="https://via.placeholder.com/120" alt="member">
	        <h3>팀원 2</h3>
	        <p>설명</p>
	      </div>
	      <div class="team-card hidden">
	        <img src="https://via.placeholder.com/120" alt="member">
	        <h3>팀원 3</h3>
	        <p>설명</p>
	      </div>
	      <div class="team-card hidden">
	        <img src="https://via.placeholder.com/120" alt="member">
	        <h3>팀원 4</h3>
	        <p>설명</p>
	      </div>
	      <div class="team-card hidden">
	        <img src="https://via.placeholder.com/120" alt="member">
	        <h3>팀원 5</h3>
	        <p>설명</p>
	      </div>
	      <div class="team-card hidden">
	        <img src="https://via.placeholder.com/120" alt="member">
	        <h3>팀원 6</h3>
	        <p>설명</p>
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
// 스크롤 애니메이션
   const hiddenEls = document.querySelectorAll('.hidden');
   const observer = new IntersectionObserver((entries)=>{
     entries.forEach(entry=>{
       if(entry.isIntersecting){
         entry.target.classList.add('show');
         observer.unobserve(entry.target);
       }
     });
   }, {threshold: 0.2});
   hiddenEls.forEach(el=>observer.observe(el));

   // 맨 위로 버튼
   const backToTop = document.getElementById("backToTop");
   window.addEventListener("scroll", ()=>{
     if(document.documentElement.scrollTop > 200){
       backToTop.style.display = "block";
     } else {
       backToTop.style.display = "none";
     }
   });
   backToTop.addEventListener("click", ()=>{
     window.scrollTo({ top: 0, behavior: 'smooth' });
   });

   </script>
   
</body>
</html>