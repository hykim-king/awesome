<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="CP" value="${pageContext.request.contextPath }" />

<%-- '결과 확인 모드'인지 판별하기 위한 변수 설정 (컨트롤러에서 resultList를 넘겨주면 true) --%>
<c:set var="isReviewMode" value="${not empty resultList}" />
<%-- '퀴즈 풀이 모드'일 경우 quizList를, '결과 확인 모드'일 경우 resultList를 사용 --%>
<c:set var="displayList" value="${isReviewMode ? resultList : quizList}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${CP}/resources/css/pcwk_main.css">
<link rel="stylesheet" href="${CP}/resources/css/header.css">
<title>${isReviewMode ? '퀴즈 해설' : '오늘의 퀴즈'}</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<style>
    /* 요청하신 스타일은 그대로 유지합니다. */
    .quiz-form-container { max-width: 768px; margin: 20px auto; padding: 20px; background-color: #f0f2f5; border-radius: 8px; }
    .quiz-info-box { background-color: #ffffff; padding: 15px; margin-bottom: 20px; border-top: 10px solid #673ab7; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); text-align: center; font-size: 0.9em; color: #555; }
    .quiz-card { background-color: #ffffff; border-radius: 8px; padding: 24px; margin-bottom: 15px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
    .quiz-card h3 { font-size: 1.1em; margin-bottom: 16px; color: #333; }
    .quiz-options { display: flex; flex-direction: column; gap: 12px; }
    .quiz-options label { display: flex; align-items: center; cursor: pointer; padding: 10px; border: 1px solid #ddd; border-radius: 4px; transition: background-color 0.2s; }
    .quiz-options label:hover { background-color: #f5f5f5; }
    .quiz-options input[type="radio"] { margin-right: 12px; }
    .submit-button-container { text-align: right; margin-top: 20px; }
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
        <main id="main">
            <div class="main-container">

                <div class="quiz-form-container">
                    <div class="quiz-info-box">
                        <c:choose>
                            <c:when test="${isReviewMode}">
                                <h2>퀴즈 결과 및 해설</h2>
                                <p>각 문제의 정답과 해설을 확인해 보세요.</p>
                            </c:when>
                            <c:otherwise>
                                <h2>오늘의 퀴즈</h2>
                                <p>총 ${displayList.size()}문제입니다. 모든 문제에 답해주세요.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <form action="${CP}/quiz/${isReviewMode ? 'result.do' : 'submit.do'}" method="post" id="quizForm">
                        <c:forEach var="item" items="${displayList}" varStatus="status">
                            <c:set var="isCorrect" value="${isReviewMode && (item.userAnswer == item.answer)}" />
                            
                            <div class="quiz-card ${isReviewMode ? 'result-card' : ''} ${isCorrect ? 'correct-border' : 'incorrect-border'}">
                                <h3>문제 ${status.count}. ${item.question}</h3>
                                
                                <%-- 퀴즈 풀이/결과 모드에 따라 다른 옵션 표시 --%>
                                <div class="quiz-options">
                                    <c:choose>
                                        <%-- 1. 퀴즈 풀이 모드 --%>
                                        <c:when test="${not isReviewMode}">
                                            <label>
                                                <input type="radio" name="userAnswers[${status.index}]" value="O" required> O
                                            </label>
                                            <label>
                                                <input type="radio" name="userAnswers[${status.index}]" value="X" required> X
                                            </label>
                                            <input type="hidden" name="questionNos[${status.index}]" value="${item.questionNo}">
                                        </c:when>
                                        
                                        <%-- 2. 결과 확인 모드 --%>
                                        <c:otherwise>
                                            <label>
                                                <input type="radio" name="answer_${item.questionNo}" value="O" disabled ${item.userAnswer == 'O' ? 'checked' : ''}> O
                                            </label>
                                            <label>
                                                <input type="radio" name="answer_${item.questionNo}" value="X" disabled ${item.userAnswer == 'X' ? 'checked' : ''}> X
                                            </label>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <%-- 결과 확인 모드에서만 해설 블록 표시 --%>
                                <c:if test="${isReviewMode}">
                                    <c:choose>
                                        <c:when test="${isCorrect}">
                                            <div class="status-badge correct">정답! 👍</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="status-badge incorrect">오답 👎</div>
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="answer-details">
                                        <p><strong>정답</strong>: ${item.answer}</p>
                                        <p><strong>나의 제출 답안</strong>: ${item.userAnswer}</p>
                                    </div>

                                    <div class="explanation-box">
                                        <strong>📖 해설</strong>
                                        <p>${item.explanation}</p>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                        
                        <%-- 모드에 따라 다른 버튼 표시 --%>
                        <div class="submit-button-container">
                             <c:choose>
                                <c:when test="${isReviewMode}">
                                    <%-- 최종 결과 페이지로 이동 시 필요한 데이터(맞힌/전체 개수)를 hidden으로 전달 --%>
                                    <input type="hidden" name="correctCount" value="${correctCount}">
                                    <input type="hidden" name="totalCount" value="${totalCount}">
                                    <button type="submit" class="btn">최종 점수 보기</button>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" id="submitQuizBtn" class="btn" disabled>정답 제출</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </form>
                </div>

                <script>
                    $(document).ready(function() {
                        // 이 스크립트는 '퀴즈 풀이 모드'에서만 동작합니다.
                        if (!${isReviewMode}) {
                            const totalQuestions = $('.quiz-card').length;
                            const quizForm = $('#quizForm');
                            const submitBtn = $('#submitQuizBtn');

                            function checkAllAnswered() {
                                let answeredCount = $('input[type="radio"]:checked').length;
                                if (answeredCount === totalQuestions) {
                                    submitBtn.prop('disabled', false);
                                } else {
                                    submitBtn.prop('disabled', true);
                                }
                            }

                            quizForm.on('change', 'input[type="radio"]', checkAllAnswered);

                            quizForm.on('submit', function(e) {
                                if (!confirm("정말로 제출하시겠습니까? 이후 문제의 답을 수정하실 수 없습니다.")) {
                                    e.preventDefault();
                                }
                            });
                        }
                    });
                </script>

                <c:choose>
                    <%-- 요청하신 로그인/로그아웃 섹션은 그대로 유지합니다. --%>
                    <c:when test="${empty sessionScope.loginUser}">
                        <%-- ... 로그인 버튼 ... --%>
                    </c:when>
                    <c:otherwise>
                        <%-- ... 로그아웃 버튼 ... --%>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
        <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
    </div>
</body>
</html>