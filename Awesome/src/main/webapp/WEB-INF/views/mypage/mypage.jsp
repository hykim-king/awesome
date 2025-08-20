<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<!-- 구글 차트 멘트 -->
<script>
fetch('${pageContext.request.contextPath}/mypage/api/mypage/summary')
  .then(res => res.text())
  .then(msg => {
    document.getElementById("summary").innerText = "안녕하세요 홍길동님.\n" + msg;
  });
</script>
<!-- 구글 차트 -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<!-- 구글 차트 -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<script>
google.charts.load("current", {packages:["corechart"]});
google.charts.setOnLoadCallback(drawChart);

function drawChart() {
  // JSP에서 바로 치환됨
  fetch('${pageContext.request.contextPath}/mypage/api/mypage/chart')
    .then(response => response.json())
    .then(data => {
    	 console.log("서버에서 받은 원본 데이터:", data); // 👈 응답 JSON 확인
      if (data.length === 0) {
        document.getElementById('piechart_3d').innerHTML =
          "이번주 읽은 기사가 없습니다.<br>핫이슈 '오늘의 토픽'을 살펴보세요!";
        return;
      }

      // 구글 차트 데이터 포맷으로 변환
      const chartData = [['카테고리', 'Frequency per Week']];
      data.forEach(item => {
    	  console.log("item:", item);   // 👈 각 아이템 확인
        chartData.push([item.category, item.clickCount]);
      });
      console.log("차트에 그릴 데이터:", chartData); // 👈 구글 차트 포맷 확인
      
      
      // 구글 차트 그리기
      const dataTable = google.visualization.arrayToDataTable(chartData);
      const options = {
        title: '한 주간 읽은 카테고리',
        is3D: true
      };

      const chart = new google.visualization.PieChart(
        document.getElementById('piechart_3d')
      );
      chart.draw(dataTable, options);
    })
    .catch(error => {
      console.error("차트 데이터를 불러오는 중 오류 발생:", error);
      document.getElementById('piechart_3d').innerText =
        "차트 데이터를 불러올 수 없습니다.";
    });
}
</script>

<!-- 워드 클라우드 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/wordcloud2.js/1.1.2/wordcloud2.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/wordcloud.js"></script>
</head>
<body>
    <main id="main">
    <div class="main-container">
    
    <div id="summary"></div>
    <!-- 구글 차트 -->
    <div id="piechart_3d" style="width: 900px; height: 500px;"></div>
    <!-- 워드 클라우드 -->
    <div id="wordCloud" style="width:1000px; height:400px;"></div>
    <hr>

<div class="bookmark-list">
    <h3>북마크</h3>
  <c:choose>
    <%-- 북마크가 있는 경우 --%>
    <c:when test="${not empty list}">
      <c:forEach var="item" items="${list}">
        <div class="bookmark-item">
          <h3 class="title">
            <a>${item.title}</a>
          </h3>
          <p class="summary">${item.summary}</p>
          <div class="meta">
            <span class="press">${item.press}</span>
            <span class="date">
              <fmt:formatDate value="${item.regDt}" pattern="yyyy-MM-dd"/>
            </span>
          </div>
        </div>
        <hr/>
      </c:forEach>
    </c:when>

    <%-- 북마크가 없는 경우 --%>
    <c:otherwise>
      <div class="no-bookmark">
        ${noBookmarkMsg}
      </div>
    </c:otherwise>
  </c:choose>
</div>

<!-- 페이지네이션 -->
<c:if test="${totalCnt > 0}">
  <div class="pagination">
    <c:set var="totalPage" value="${(totalCnt / pageSize) + (totalCnt % pageSize > 0 ? 1 : 0)}"/>

    <c:forEach var="i" begin="1" end="${totalPage}">
      <c:choose>
        <c:when test="${i == pageNo}">
          <span class="current">${i}</span>
        </c:when>
        <c:otherwise>
          <a href="<c:url value='/doRetriveMy.do?pageNo=${i}&pageSize=${pageSize}'/>">${i}</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>
  </div>
</c:if>

    </div>
    </main>
</body>
</html>