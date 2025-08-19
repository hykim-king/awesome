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
</head>
<body>
    <div id="container">
    
    <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/include/sidebar.jsp"></jsp:include>
      <main id="main">
      <div class="main-container">

      <div class="quiz-section" style="text-align:center; padding: 40px 0;">
          <h3>Today's Quiz</h3>
          <h2>퀴즈를 시작하시겠습니까?</h2>
          <button type="button" class="btn" id="quizStartBtn" style="margin-top:20px; font-size: 1.2em; padding: 10px 24px;">>시작</button>
      </div>

      <script>
        // jQuery의 $(document).ready() : HTML 문서가 모두 로드된 후 스크립트를 실행합니다.
        $(document).ready(function(){
            
            // 1. 현재 시간 정보 가져오기 (사용자 브라우저 기준)
            const now = new Date();
            const currentHour = now.getHours();    // 0~23
            const currentMinute = now.getMinutes(); // 0~59
            
            // 퀴즈 시작 가능 시간: 정오(12:00)
            const quizStartTime = 12;
            
            // 퀴즈 종료 시간: 23시 30분
            const quizEndHour = 23;
            const quizEndMinute = 30;

            // 2. 퀴즈 풀이 가능 시간인지 확인
            // (현재 시간이 12시 이상) 그리고 (현재 시간이 23시보다 작거나, 23시이면서 30분 이하)일 때 true
            const isQuizTime = (currentHour >= quizStartTime) && 
                               (currentHour < quizEndHour || (currentHour === quizEndHour && currentMinute <= quizEndMinute));

            const quizBtn = $("#quizStartBtn"); // 버튼 엘리먼트 변수화

            // 3. 시간 조건에 따라 버튼 상태 변경
            if(isQuizTime){
                // 퀴즈 풀이 가능 시간일 경우
                quizBtn.text(">시작");
                quizBtn.prop("disabled", false); // 버튼 활성화
            } else {
                // 퀴즈 풀이 가능 시간이 아닐 경우
                quizBtn.text("금일 정오에 열립니다");
                quizBtn.prop("disabled", true); // 버튼 비활성화
            }

            // 4. 버튼 클릭 이벤트 처리
            quizBtn.on("click", function(){
                // 퀴즈 주의사항 안내
                alert("퀴즈 주의사항:\n\n1. 퀴즈는 하루에 한 번만 참여 가능합니다.\n2. 모든 문제를 풀어야 제출이 완료됩니다.\n3. 제출 후에는 답을 수정할 수 없습니다.");
                
                // 확인 클릭 시 퀴즈 페이지로 이동
                window.location.href = "${CP}/quiz/quizPaging.do"; // quizPaging 화면으로 이동
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