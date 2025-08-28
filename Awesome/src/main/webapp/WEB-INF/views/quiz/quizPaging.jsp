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
    /*스타일은 그대로 유지 */
    .quiz-form-container { max-width: 768px; margin: 20px auto; padding: 20px; background-color: #f0f2f5; border-radius: 8px; }
    .quiz-info-box { background-color: #ffffff; padding: 15px; margin-bottom: 20px; border-top: 10px solid #673ab7; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); text-align: center; font-size: 0.9em; color: #555; }
    .quiz-card { background-color: #ffffff; border-radius: 8px; padding: 24px; margin-bottom: 0 !important; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
    .quiz-card h3 { font-size: 1.1em; margin-bottom: 16px; color: #333; }
    .quiz-options { display: flex; flex-direction: column; gap: 12px; }
    .quiz-options label { display: flex; align-items: center; cursor: pointer; padding: 10px; border: 1px solid #ddd; border-radius: 4px; transition: background-color 0.2s; }
    .quiz-options label:hover { background-color: #f5f5f5; }
    .quiz-options input[type="radio"] { margin-right: 12px; }
    .submit-button-container { text-align: center; margin-top: 20px; }
    #submitQuizBtn:disabled { background-color: #cccccc; cursor: not-allowed; }

    /* --- 결과 확인 모드 전용 스타일 --- */
    .result-card { border-left: 5px solid #ddd; }
    .result-card.correct-border { border-left-color: #4CAF50; }
    .result-card.incorrect-border { border-left-color: #F44336; }
    .status-badge { display: inline-block; padding: 4px 12px; border-radius: 16px; font-weight: bold; font-size: 0.9em; margin-top: 16px; }
    .status-badge.correct { background-color: #e6ffed; color: #006421; }
    .status-badge.incorrect { background-color: #ffebee; color: #c62828; }
    .explanation-box { background-color: #f8f9fa; border-radius: 4px; padding: 16px; margin-top: 20px; }
    .explanation-box strong { font-size: 1.1em; color: #673ab7; display: block; margin-bottom: 8px; }
    .answer-details { font-size: 1em; line-height: 1.6; margin-top: 8px;}
    .answer-details p { margin: 4px 0; }
    .answer-details strong { display: inline-block; width: 110px; color: #5f6368; }
</style>
</head>
<body>
    <div id="container">
    
     <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
     <jsp:include page="/WEB-INF/views/include/sidebar.jsp"></jsp:include>
     <jsp:include page="/WEB-INF/views/include/leftsidebar.jsp"></jsp:include>
      <main id="main">
      <div class="main-container">

        <div class="quiz-form-container">
            <div class="quiz-info-box">
                <p>퀴즈는 금일 조회수 상위 10위 안에서 랜덤으로 산출되었습니다.</p>
            </div>
            
            <form action="${CP}/quiz/submit.do" method="post" id="quizForm">
                <c:forEach var="quiz" items="${quizList}" varStatus="status">
                    <div class="quiz-card" style="padding-bottom: 24px;">
                        <h3 style="margin-bottom: 12px;">문제 ${status.count}. ${quiz.question}</h3>
                        <div class="quiz-options">
                            <label>
                                <input type="radio" name="answer_${quiz.qqCode}" value="O" required> O
                            </label>
                            <label>
                                <input type="radio" name="answer_${quiz.qqCode}" value="X" required> X
                            </label>
                        </div>
                    </div>
                </c:forEach>
                
                <div class="submit-button-container">
                    <button type="submit" id="submitQuizBtn" class="btn" disabled style="
							    background-color: #0047FF !important; /* !important 추가 */
							    color: white !important; /* !important 추가 */
							    font-size: 1.5em !important; /* !important 추가 */
							    padding: 15px 50px !important; /* !important 추가 */
							    border-radius: 10px !important; /* !important 추가 */
							    font-weight: bold !important; /* !important 추가 */
							    border: none !important; /* !important 추가 */
							    box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2) !important; /* !important 추가 */
							    cursor: pointer !important; /* !important 추가 */
							    transition: background-color 0.3s ease, box-shadow 0.3s ease !important; /* !important 추가 */
							">정답 제출</button>
                </div>
            </form>
        </div>

        <script>
            $(document).ready(function() {
                const totalQuestions = $('.quiz-card').length;
                const quizForm = $('#quizForm');
                const submitBtn = $('#submitQuizBtn');

                function checkAllAnswered() {
                    let answeredCount = $('input[name^="answer_"]:checked').length;

                    if (answeredCount === totalQuestions) {
                        submitBtn.prop('disabled', false);
                        submitBtn.css({
	                            "background-color": "#0047FF !important",
	                            "color": "white !important",
	                            "box-shadow": "0 5px 10px rgba(0, 0, 0, 0.2) !important",
	                            "cursor": "pointer !important"
	                        });
                    } else {
                         submitBtn.prop('disabled', true);
                         submitBtn.css({
	                            "background-color": "#cccccc !important",
	                            "color": "#666666 !important",
	                            "box-shadow": "none !important",
	                            "cursor": "not-allowed !important"
	                        });
                    }
                }

                quizForm.on('change', 'input[type="radio"]', function() {
                    checkAllAnswered();
                });

                quizForm.on('submit', function(event) {
                    event.preventDefault(); 
                    
                    const isConfirmed = confirm("정말로 제출하시겠습니까? 이후 문제의 답을 수정하실 수 없습니다.");
                    
                    if (isConfirmed) {
                        this.submit();
                    }
                });
            });
        </script>
        

      </div>
      </main>
      <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
    </div> 
</body>
</html>