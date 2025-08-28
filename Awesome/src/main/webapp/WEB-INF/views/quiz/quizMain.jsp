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
    <jsp:include page="/WEB-INF/views/include/leftsidebar.jsp"></jsp:include>
      <main id="main">
      <div class="main-container">

      <div class="quiz-section" style="text-align:center; padding: 100px 0;"> <h3 style="
                font-family: 'Times New Roman', Times, serif; /* 폰트 변경 */
                font-size: 3.5em; /* 글자 크기 키움 */
                font-weight: bold; /* 굵게 */
                color: #333; /* 글자색 */
                margin-bottom: 60px; /* 아래 여백 */
            ">Today's QUIZ</h3>

            <h2 style="
                font-size: 2.2em; /* 글자 크기 키움 */
                font-weight: bold; /* 굵게 */
                color: #333; /* 글자색 */
                margin-bottom: 150px; /* 아래 여백 */
                text-decoration: none; /* 이전 밑줄 제거 */
            ">퀴즈풀이를 <br> 시작하시겠습니까?</h2>

            <button type="button" class="btn" id="quizStartBtn" style="
                margin-top:20px;
                font-size: 2em; /* 버튼 글자 크기 키움 */
                padding: 15px 40px; /* 버튼 패딩 키움 */
                border-radius: 10px; /* 모서리를 더 둥글게 */
                box-shadow: 0 6px 10px rgba(0, 0, 0, 0.2); /* 그림자 효과 강화 */
                background-color: #0047FF; /* 이미지와 유사한 파란색 */
                color: white; /* 흰색 글자 */
                border: none;
                font-weight: bold; /* 글자 굵게 */
                cursor: pointer; /* 마우스 오버 시 포인터 변경 */
                transition: background-color 0.3s ease, box-shadow 0.3s ease; /* 부드러운 전환 효과 */
            ">
            > 시작!
            </button>
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
                quizBtn.text(">시작");
                quizBtn.prop("disabled", false);
                // 활성화된 버튼 스타일
                quizBtn.css({"background-color": "#007bff", "color": "white", "box-shadow": "0 4px 6px rgba(0,0,0,0.1)"});
            } else {
                quizBtn.text("금일 정오에 열립니다");
                quizBtn.prop("disabled", true);
                // 비활성화된 버튼 스타일
                quizBtn.css({"background-color": "#cccccc", "color": "#666666", "box-shadow": "none"});
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
      </div>
      </main>
      <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
    </div> 
</body>
</html>