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
<title>핫이슈 - 퀴즈 결과</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<style>
    body {
        background-color: #f0f2f5 !important;
    }
    .quiz-explain-container { 
        max-width: 768px; 
        margin: 30px auto; 
    }
    .quiz-explain-card {
        background-color: #ffffff;
        border-radius: 8px;
        padding: 24px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .quiz-explain-card h2 {
        font-size: 1.5em;
        color: #333;
        margin-bottom: 20px;
        text-align: left;
        border-bottom: 1px solid #eee;
        padding-bottom: 15px;
    }
    .quiz-explain-item {
        margin-bottom: 20px;
        padding-bottom: 20px;
        border-bottom: 1px dashed #e0e0e0;
    }
    .quiz-explain-item:last-child {
        border-bottom: none;
        margin-bottom: 0;
    }
    .quiz-explain-item h3 {
        font-size: 1.1em;
        margin-bottom: 10px;
        color: #333;
        font-weight: bold;
    }
    .status-badge {
        font-weight: bold;
        margin-left: 8px;
    }
    .status-badge.correct {
        color: #4CAF50;
    }
    .status-badge.incorrect {
        color: #F44336;
    }
    .answer-details {
        font-size: 0.9em;
        line-height: 1.5;
        margin-left: 10px;
    }
    .answer-details strong {
        display: inline-block;
        width: 100px;
        color: #555;
    }
    .explanation-box {
        background-color: #f8f9fa;
        border-radius: 4px;
        padding: 15px;
        margin-top: 15px;
    }
    .explanation-box strong {
        font-size: 1em;
        color: #673ab7;
        display: block;
        margin-bottom: 8px;
    }
    .button-container {
        text-align: center;
        margin-top: 30px;
    }
    #goToResultBtn {
        background-color: #0047FF;
        color: white;
        font-size: 1.5em;
        padding: 15px 50px;
        border: none;
        border-radius: 10px;
        box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        cursor: pointer;
        font-weight: bold;
        transition: background-color 0.2s;
    }
    #goToResultBtn:hover {
        background-color: #0039cc;
    }
</style>
</head>
<body style="background-color: #f0f2f5;">
    <div id="container">
    
      <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
      <jsp:include page="/WEB-INF/views/include/sidebar.jsp"></jsp:include>
      <jsp:include page="/WEB-INF/views/include/leftsidebar.jsp"></jsp:include>
      <main id="main">
      <div class="main-container">

        <div class="quiz-explain-container">
            <div class="quiz-explain-card">
                <h2>퀴즈 결과 및 해설</h2>
                <c:forEach var="result" items="${quizResultList}" varStatus="status">
                    <div class="quiz-explain-item">
                        <h3> 문제 ${status.count}. ${result.question}</h3>
                        <div class="answer-details">
                            <p><strong>문제 정답</strong>: ${result.answer}</p>
                            <p><strong>나의 제출 답안</strong>: ${result.userAnswer}</p>
                        </div>
                        <div class="explanation-box">
                            <strong>해설</strong>
                            <p>${result.explanation}</p>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <div class="button-container">
                <button type="button" id="goToResultBtn">결과화면</button>
            </div>
        </div>
        
        <script>
            $(document).ready(function(){
                $('#goToResultBtn').on('click', function(){
                    alert("문제 설명을 잘 보셨나요? 내일도 문제 풀기 잊지마세요!");
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