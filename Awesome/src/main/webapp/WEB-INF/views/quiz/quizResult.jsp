<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
<c:set var="CP" value="${pageContext.request.contextPath }" />    

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${CP}/resources/css/pcwk_main.css">
<link rel="stylesheet" href="${CP}/resources/css/header.css">
<title>최종 퀴즈 결과</title>
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<style>
    /* 최종 결과 페이지 전용 스타일 */
    .quiz-result-container {
        max-width: 600px;
        margin: 40px auto;
        padding: 20px;
        text-align: center;
    }
    .result-summary-card {
        background-color: #ffffff;
        border-radius: 12px;
        padding: 40px 30px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        border-top: 10px solid #ffc107; /* 상단에 강조 색상 */
    }
    .result-summary-card .icon {
        font-size: 4em;
        margin-bottom: 20px;
        color: #ffc107;
    }
    .result-summary-card h3 {
        font-size: 1.5em;
        color: #555;
        margin-bottom: 8px;
    }
    .result-summary-card h2 {
        font-size: 1.8em;
        color: #333;
        margin-bottom: 30px;
    }
    .result-summary-card h2 strong {
        color: #673ab7;
    }
    .result-details {
        text-align: left;
        display: inline-block; /* 가운데 정렬을 위해 */
        margin-top: 20px;
    }
    .result-details h1 {
        font-size: 1.2em;
        color: #333;
        margin: 15px 0;
        border-left: 4px solid #ddd;
        padding-left: 15px;
    }
    .score-display {
        font-size: 4em !important; /* 점수는 특별히 크게 */
        font-weight: bold;
        color: #673ab7;
        margin-top: 30px !important;
        padding: 0 !important;
        border: none !important;
    }
    .button-container {
        margin-top: 40px;
    }
    #goToMainBtn {
        background-color: #673ab7;
        color: white;
        font-size: 1.1em;
        padding: 12px 32px;
        text-decoration: none; /* a 태그의 밑줄 제거 */
        border-radius: 4px;
        transition: background-color 0.2s;
    }
    #goToMainBtn:hover {
        background-color: #5e35b1;
    }
</style>
</head>
<body>
   <div id="container">
    
     <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
     <jsp:include page="/WEB-INF/views/include/sidebar.jsp"></jsp:include>
     <jsp:include page="/WEB-INF/views/include/leftsidebar.jsp"></jsp:include>
      <main id="main">
      <div class="main-container">

      <div class="quiz-result-container">
        <div class="result-summary-card">
            <div class="icon">🏆</div>
            <h3>수고하셨습니다!</h3>
            <h2><strong>${sessionScope.loginUser.userId}</strong>님의 최종 점수입니다.</h2>
            
            <%-- 컨트롤러에서 전달받은 correctCount와 totalCount로 점수 계산 --%>
            <c:if test="${totalCount > 0}">
                <c:set var="score" value="${100 / totalCount * correctCount}" />
            </c:if>
            <c:if test="${totalCount == 0}">
                <c:set var="score" value="0" />
            </c:if>

            <h1 class="score-display">
                <fmt:formatNumber value="${score}" pattern="#,##0" />점
            </h1>
            
            <div class="result-details">
                <%-- 현재 날짜를 yyyy년 MM월 dd일 형식으로 표시 --%>
                <jsp:useBean id="now" class="java.util.Date" />
                <h1>퀴즈 풀이 날짜: <fmt:formatDate value="${now}" pattern="yyyy년 MM월 dd일" /></h1>
                <h1>총 맞힌 개수: ${correctCount} / ${totalCount}</h1>
            </div>
        </div>
        
        <div class="button-container">
            <a href="${CP}/mainPage/main.do" id="goToMainBtn" class="btn">메인으로 돌아가기</a>
        </div>
      </div>


        <c:choose>
     <c:when test="${empty sessionScope.loginUser}">
        <div style="display:flex; gap:12px;">
           <a class="btn" href="<c:url value='/member/login.do'/>">로그인</a>
           <a class="btn" href="<c:url value='/member/register.do'/>">회원가입</a>
        </div>
     </c:when>
    
     <c:otherwise>
        <div style="display:flex; gap:12px; align-items:center;">
           <span><strong>${sessionScope.loginUser.userId}</strong>님 환영합니다!</span>
           <a class="btn" href="<c:url value='/member/logout.do'/>">로그아웃</a>
        </div>
     </c:otherwise>
   </c:choose>

         


      </div>
      </main>
      <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
   </div> 
</body>
</html>