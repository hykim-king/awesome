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
<title>핫이슈 소개</title>
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>

<style>
.intro-hero {
  position: relative;
  width: 100%;
  height: 500px;        /* 섹션 높이 */
  overflow: hidden;
  padding: 60px 40px;
}

.hero-container {
  display: flex;
  align-items: center;
  justify-content: space-between;
  max-width: 1200px;
  margin: 0 auto;
  gap: 40px;
}

.hero-bg img {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 100%;
  height: 100%;
  object-fit: cover;    /* 화면 꽉 채우기 */
  z-index: 1;
}

.hero-content {
  flex: 1;
  max-width: 500px;
  text-align: left;
}

.hero-content h1 {
  font-size: 42px;
  font-weight: 800;
  margin-bottom: 16px;
}

.hero-content p {
  font-size: 18px;
  color: #555;
  line-height: 1.6;
}

.hero-image {
  flex: 1;
  text-align: right;
}

.hero-image img {
    width: 1500px; 
  height: auto;
}

</style>
<body>
   <div id="container">
   
  <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/chatBot/chatBot.jsp"></jsp:include>
  
  
  <!-- main -->
  <main id="intro-main">

<!-- Hero Section -->
<section class="intro-hero">
  <div class="hero-container">
    <!-- 텍스트 -->
    <div class="hero-content">
      <h1>뉴스 빅데이터 플랫폼, HotIssue</h1>
      <p>핫이슈는 최신 뉴스와 데이터를 분석하고, 사용자에게 맞춤형 정보를 제공합니다.</p>
    </div>
    <!-- 이미지 -->
    <div class="hero-image">
      <img src="${CP}/resources/file/intro1.png" alt="HotIssue 소개 이미지">
    </div>
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
	  
	  
	<!-- intro section -->
	<section id="features">
	  <div class="features-container">
	    <h2 class="section-title">서비스 특징</h2>
	    <div class="features-grid">
	      <div class="feature-card hidden">
	        <div class="icon">📊</div>
	        <h3>정형화된 데이터</h3>
	        <p>비정형 텍스트를 분석 가능한 정형 데이터로 변환</p>
	      </div>
	      <div class="feature-card hidden">
	        <div class="icon">☁️</div>
	        <h3>빅데이터화</h3>
	        <p>1990년부터 현재까지 뉴스 콘텐츠 빅데이터화</p>
	      </div>
	      <div class="feature-card hidden">
	        <div class="icon">💡</div>
	        <h3>가치 있는 정보</h3>
	        <p>뉴스 콘텐츠를 축적해 분석 가능한 자료 제공</p>
	      </div>
	    </div>
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