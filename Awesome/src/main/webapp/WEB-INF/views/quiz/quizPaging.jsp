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
<title>핫이슈</title>
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
 
 <style>
    .quiz-form-container {
        max-width: 768px;
        margin: 20px auto;
        padding: 20px;
        background-color: #f0f2f5;
        border-radius: 8px;
    }
    .quiz-info-box {
        background-color: #ffffff;
        padding: 15px;
        margin-bottom: 20px;
        border-top: 10px solid #673ab7;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        text-align: center;
        font-size: 0.9em;
        color: #555;
    }
    .quiz-card {
        background-color: #ffffff;
        border-radius: 8px;
        padding: 24px;
        margin-bottom: 15px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .quiz-card h3 {
        font-size: 1.1em;
        margin-bottom: 16px;
        color: #333;
    }
    .quiz-options {
        display: flex;
        flex-direction: column;
        gap: 12px;
    }
    .quiz-options label {
        display: flex;
        align-items: center;
        cursor: pointer;
        padding: 10px;
        border-radius: 4px;
        transition: background-color 0.2s;
    }
    .quiz-options label:hover {
        background-color: #f5f5f5;
    }
    .quiz-options input[type="radio"] {
        margin-right: 12px;
    }
    .submit-button-container {
        text-align: right;
        margin-top: 20px;
    }
    #submitQuizBtn:disabled {
        background-color: #cccccc;
        cursor: not-allowed;
    }
 </style>
</head>
<body>
    <div id="container">
    
    <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/include/sidebar.jsp"></jsp:include>
      <main id="main">
      <div class="main-container">

        <div class="quiz-form-container">
            <div class="quiz-info-box">
                <p>퀴즈는 금일 조회수 상위 10위 안에서 랜덤으로 산출되었습니다.</p>
            </div>
            
            <form action="${CP}/quiz/quizExplain.do" method="post" id="quizForm">
                <c:forEach var="quiz" items="${quizList}" varStatus="status">
                    <div class="quiz-card">
                        <h3>문제 ${status.count}. ${quiz.quizContent}</h3>
                        <div class="quiz-options">
                            <label>
                                <input type="radio" name="answer_${quiz.quizNo}" value="O"> O
                            </label>
                            <label>
                                <input type="radio" name="answer_${quiz.quizNo}" value="X"> X
                            </label>
                        </div>
                    </div>
                </c:forEach>
                
                <div class="submit-button-container">
                    <button type="submit" id="submitQuizBtn" class="btn" disabled>>정답 제출</button>
                </div>
            </form>
        </div>

        <script>
            $(document).ready(function() {
                // 전체 퀴즈 문항의 수
                const totalQuestions = $('.quiz-card').length;
                const quizForm = $('#quizForm');
                const submitBtn = $('#submitQuizBtn');

                // 1. 모든 문항에 답했는지 체크하는 함수
                function checkAllAnswered() {
                    // name 속성이 'answer_'로 시작하는 라디오 버튼 그룹의 수를 센다
                    let answeredCount = 0;
                    // JSTL로 생성된 각 퀴즈 번호에 대해 체크된 항목이 있는지 확인
                    <c:forEach var="quiz" items="${quizList}">
                        if ($('input[name="answer_${quiz.quizNo}"]:checked').length > 0) {
                            answeredCount++;
                        }
                    </c:forEach>

                    // 모든 문항에 답했다면 버튼 활성화, 아니면 비활성화
                    if (answeredCount === totalQuestions) {
                        submitBtn.prop('disabled', false);
                    } else {
                        submitBtn.prop('disabled', true);
                    }
                }

                // 2. 라디오 버튼의 선택이 변경될 때마다 함수 호출
                quizForm.on('change', 'input[type="radio"]', function() {
                    checkAllAnswered();
                });

                // 3. 폼 제출 시 confirm 창 띄우기
                quizForm.on('submit', function(event) {
                    // form의 기본 제출 동작을 일단 막음
                    event.preventDefault(); 
                    
                    const isConfirmed = confirm("정말로 제출하시겠습니까? 이후 문제의 답을 수정하실 수 없습니다.");
                    
                    if (isConfirmed) {
                        // 사용자가 '확인'을 누르면 form을 실제로 제출
                        this.submit();
                    }
                });
            });
        </script>
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