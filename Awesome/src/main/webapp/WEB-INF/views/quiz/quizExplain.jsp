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
<link rel="stylesheet" href="/ehr/resources/css/pcwk_main.css">
<link rel="stylesheet" href="/ehr/resources/css/header.css">
<title>핫이슈 - 퀴즈 결과</title>
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
 
 <style>
    body {
        background-color: #f0f2f5; /* 구글 폼 배경색과 유사하게 변경 */
    }
    .quiz-explain-container {
        max-width: 768px;
        margin: 30px auto;
    }
    .quiz-header {
        background-color: #ffffff;
        padding: 24px;
        margin-bottom: 15px;
        border-top: 10px solid #673ab7; /* 구글 폼의 대표적인 보라색 테마 */
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .quiz-header h2 {
        font-size: 1.8em;
        color: #333;
        margin: 0;
    }
    .result-card {
        background-color: #ffffff;
        border-radius: 8px;
        padding: 24px;
        margin-bottom: 15px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        border: 1px solid #ddd;
    }
    .result-card h3 {
        font-size: 1.1em;
        margin-bottom: 16px;
        color: #333;
        font-weight: 500;
    }
    .status-badge {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 16px;
        font-weight: bold;
        font-size: 0.9em;
        margin-bottom: 16px;
    }
    .status-badge.correct {
        background-color: #e6ffed;
        color: #006421;
    }
    .status-badge.incorrect {
        background-color: #ffebee;
        color: #c62828;
    }
    .answer-details {
        font-size: 1em;
        line-height: 1.6;
    }
    .answer-details p {
        margin: 4px 0;
    }
    .answer-details strong {
        display: inline-block;
        width: 110px;
        color: #5f6368;
    }
    .explanation-box {
        background-color: #f8f9fa;
        border-radius: 4px;
        padding: 16px;
        margin-top: 20px;
    }
    .explanation-box strong {
        font-size: 1.1em;
        color: #673ab7;
        display: block;
        margin-bottom: 8px;
    }
    .button-container {
        text-align: center;
        margin-top: 30px;
    }
    #goToResultBtn {
        background-color: #673ab7;
        color: white;
        font-size: 1em;
        padding: 12px 28px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.2s;
    }
    #goToResultBtn:hover {
        background-color: #5e35b1;
    }
 </style>
</head>
<body>
    <div id="container">
    
    <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/include/sidebar.jsp"></jsp:include>
      <main id="main">
      <div class="main-container">

        <div class="quiz-explain-container">
            
            <div class="quiz-header">
                <h2>퀴즈 결과 및 해설</h2>
            </div>

            <c:forEach var="result" items="${quizResultList}" varStatus="status">
                <div class="result-card">
                    <h3>문제 ${status.count}. ${result.question}</h3>
                    
                    <c:choose>
                        <c:when test="${result.userAnswer == result.correctAnswer}">
                            <span class="status-badge correct">정답! 👍</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge incorrect">오답 👎</span>
                        </c:otherwise>
                    </c:choose>

                    <div class="answer-details">
                        <p><strong>정답</strong>: ${result.correctAnswer}</p>
                        <p><strong>나의 제출 답안</strong>: ${result.userAnswer}</p>
                    </div>

                    <div class="explanation-box">
                        <strong>📖 해설</strong>
                        <p>${result.explanation}</p>
                    </div>
                </div>
            </c:forEach>
            
            <div class="button-container">
                <button type="button" id="goToResultBtn">>결과화면</button>
            </div>
        </div>
        
        <script>
            $(document).ready(function(){
                $('#goToResultBtn').on('click', function(){
                    alert("문제 설명을 잘 보셨나요? 내일도 문제 풀기 잊지마세요!");
                    // '확인'을 누르면 quizResult 화면으로 이동
                    window.location.href = "${CP}/quiz/quizResult.do";
                });
            });
        </script>
         <!-- 로그인/로그아웃 섹션은 가독성을 위해 잠시 생략합니다. 필요시 아래 코드를 여기에 붙여넣으세요.  -->
        
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