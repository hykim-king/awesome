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
/* 전체 컨테이너 중앙 */
#container {
  display: block;
}

.intro-main {
  max-width: 1200px;
  margin: 0 auto;
  text-align: center;
  text-align: center;
}
.intro-hero h1 {
  font-size: 32px;
  margin-bottom: 10px;
    text-align: center;
  
}
.intro-hero p {
  font-size: 18px;
  text-align: center;  
  color: #555;
}
.intro-features {
  display: flex;
  justify-content: center;
  gap: 40px;
  margin-top: 40px;
}
.intro-features .feature {
  width: 250px;
  background: #fff;
  border: 1px solid #eee;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 4px 12px rgba(0,0,0,.05);
}

/* 공통 */
.section-title {
  text-align: center;
  font-size: 2rem;
  margin: 40px 0 20px;
}

/* 즁앙 정렬 */
.features-container, .team-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  text-align: center;
}
/* 카드들을 가운데 정렬 */
.features-grid, .team-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 30px;
  justify-items: center;
}
.feature-card, .team-card {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  text-align: center;
  box-shadow: 0 8px 20px rgba(0,0,0,.08);
  transform: translateY(50px);
  opacity: 0;
  transition: all 0.6s ease;
}
.feature-card.show, .team-card.show {
  transform: translateY(0);
  opacity: 1;
}
.team-card img {
  border-radius: 50%;
  margin-bottom: 10px;
}

/* 맨 위로 버튼 */
#backToTop {
  position: fixed;
  bottom: 80px;
  right: 25px;
  z-index: 999;
  display: none;
  background: #0b5ed7;
  color: white;
  border: none;
  border-radius: 50%;
  padding: 12px 15px;
  font-size: 18px;
  cursor: pointer;
  transition: all .3s ease;
}
#backToTop:hover { background: #084298; }

</style>

<body>
   <div id="container">
   
  <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/chatBot/chatBot.jsp"></jsp:include>
  
  
      <!--main-->
      <main id="intro-main">
  <section class="intro-hero">
    <h1>뉴스 빅데이터 플랫폼, HotIssue</h1>
    <p>핫이슈는 최신 뉴스와 데이터를 분석하고, 사용자에게 맞춤형 정보를 제공합니다.</p>
	  </section>
	
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