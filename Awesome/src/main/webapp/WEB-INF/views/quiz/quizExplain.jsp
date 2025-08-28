<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="CP" value="${pageContext.request.contextPath }" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${CP}/resources/css/pcwk_main.css">
<link rel="stylesheet" href="${CP}/resources/css/header.css">
<title>핫이슈 - 퀴즈 설명</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
    <body>
    <div id="container">
    
     <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
     <jsp:include page="/WEB-INF/views/include/sidebar.jsp"></jsp:include>
     <jsp:include page="/WEB-INF/views/include/leftsidebar.jsp"></jsp:include>
      <main id="main">
      <div class="main-container">

        <div class="quiz-explain-container" style="max-width: 768px; margin: 30px auto; padding: 0;">
            
            <h2 style="font-size: 1.8em; color: #333; margin: 0 0 20px 0; text-align: center;">퀴즈 결과 및 해설</h2>

            <c:forEach var="result" items="${quizResultList}" varStatus="status">
                <div class="result-card" style="margin-bottom: 20px; padding: 0; background-color: transparent;">
                    <h3 style="font-size: 1.1em; color: #333; font-weight: bold; margin: 0 0 8px 0;">문제 ${status.count}. ${result.question}
                        <c:choose><c:when test="${result.userAnswer == result.answer}">
                            <span style="font-weight: bold; color: #4CAF50;">정답!</span>
                        </c:when><c:otherwise>
                            <span style="font-weight: bold; color: #F44336;">오답</span>
                        </c:otherwise></c:choose>
                    </h3>
                    
                    <div class="answer-details" style="font-size: 1em; line-height: 1.6;">
                        <p style="margin: 4px 0;"><strong>정답</strong>: ${result.answer}</p>
                        <p style="margin: 4px 0;"><strong>나의 제출 답안</strong>: ${result.userAnswer}</p>
                    </div>

                    <div class="explanation-box" style="margin-top: 20px;">
                        <strong style="font-size: 1.1em; color: #673ab7; display: block; margin-bottom: 8px;">해설</strong>
                        <p>${result.explanation}</p>
                    </div>
                </div>
            </c:forEach>
            
            <div class="button-container" style="text-align: center; margin-top: 30px;">
                <button type="button" id="goToResultBtn" onclick="location.href='${CP}/quiz/result.do?correctCount=${correctCount}&totalCount=${totalCount}'" style="
                    background-color: #0047FF;
                    color: white;
                    font-size: 1.5em;
                    padding: 15px 50px;
                    border: none;
                    border-radius: 10px;
                    box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
                    cursor: pointer;
                    font-weight: bold;
                ">결과화면</button>
            </div>
        </div>
        
        <script>
            $(document).ready(function(){
                $('#goToResultBtn').on('click', function(){
                    alert("문제 설명을 잘 보셨나요? 내일도 문제 풀기 잊지마세요!");
                    // '확인'을 누르면 quizResult 화면으로 이동
                    window.location.href = "${CP}/quiz/result.do?correctCount=${correctCount}&totalCount=${totalCount}";
                });
            });
        </script>
        
      </div>
      </main>
      <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
    </div> 
</body>
</html>