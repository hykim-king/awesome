<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="CP" value="${pageContext.request.contextPath }" /> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="/ehr/resources/css/pcwk_main.css">
<link rel="stylesheet" href="/ehr/resources/css/header.css">
<style>
  .wrap{max-width:1200px;margin:0 auto;padding:24px}
  .grid{display:grid;gap:24px}
  .top{grid-template-columns:1fr 1fr}
  .middle{grid-template-columns:1fr 1fr}
  .panel{border-top:1px solid #ddd;padding-top:16px}
  .section-title{display:flex;align-items:center;gap:8px;margin-bottom:8px}
  .badge{font-size:12px;color:#555;border:1px solid #ddd;border-radius:999px;padding:2px 8px}
  .item{padding:12px 0;border-bottom:1px solid #eee}
  .title{font-weight:700;margin:0 0 6px}
  .meta{font-size:12px;color:#777;display:flex;gap:8px}
  .pagination a,.pagination span{margin:0 4px}
  .current{font-weight:bold;text-decoration:underline}
</style>
<title>Insert title here</title>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

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
<script src="${CP}/resources/js/wordcloud.js"></script>
</head>
<body>
 <div id="container">
   
    <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/include/sidebar.jsp"></jsp:include>
      <!--main-->
      <main id="main">
      <div class="main-container">
		<div class="wrap">
    
		  <!-- 상단: 요약 + 차트/워드클라우드 -->
		  <div id="summary" style="white-space:pre-line;margin-bottom:12px"></div>
		  <div class="grid top">
		    <div id="piechart_3d" style="height:360px;"></div>
		    <div id="wordCloud"  style="height:360px;"></div>
		  </div>

		<!-- 중단: 좌(북마크) / 우(신고) -->
		  <div class="grid middle">
		    <!-- 북마크 패널 (현재 컨트롤러와 100% 호환: list/totalCnt/pageNo/pageSize) -->
		    <section class="panel">
		      <div class="section-title"><span class="badge">북마크</span></div>
		      <c:choose>
		        <c:when test="${not empty list}">
		          <c:forEach var="item" items="${list}">
		            <div class="item">
		              <div class="title"><a><c:out value="${item.title}"/></a></div>
		              <div class="summary"><c:out value="${item.summary}"/></div>
		              <div class="meta">
		                <span class="press"><c:out value="${item.press}"/></span>
		                <span class="date"><fmt:formatDate value="${item.regDt}" pattern="yyyy-MM-dd"/></span>
		              </div>
		            </div>
		          </c:forEach>
		        </c:when>
		        <c:otherwise>
		          <div class="item"><c:out value="${noBookmarkMsg}"/></div>
		        </c:otherwise>
		      </c:choose>
		
		      <!-- 북마크 페이징 -->
		      <c:if test="${totalCnt > 0}">
		        <c:set var="totalPage" value="${(totalCnt / pageSize) + (totalCnt % pageSize > 0 ? 1 : 0)}"/>
		        <div class="pagination" style="margin-top:8px">
		          <c:forEach var="i" begin="1" end="${totalPage}">
		            <c:choose>
		              <c:when test="${i == pageNo}"><span class="current">${i}</span></c:when>
		              <c:otherwise><a href="<c:url value='/mypage?pageNo=${i}&pageSize=${pageSize}'/>">${i}</a></c:otherwise>
		            </c:choose>
		          </c:forEach>
		        </div>
		      </c:if>
		    </section>
		
		    <!-- 신고 패널 (아직 컨트롤러 없으면 안내만 노출) -->
		    <section class="panel">
		      <div class="section-title"><span class="badge">신고사항</span></div>
		      <c:choose>
		        <c:when test="${not empty reportList}">
		          <c:forEach var="item" items="${reportList}">
		            <div class="item">
		              <div class="title">코드: <c:out value="${item.reportCode}"/></div>
		              <div class="summary">사유: <c:out value="${item.reason}"/></div>
		              <div class="meta">
		                <span class="status"><c:out value="${item.status}"/></span>
		                <span class="date"><fmt:formatDate value="${item.regDt}" pattern="yyyy-MM-dd"/></span>
		              </div>
		            </div>
		          </c:forEach>
		        </c:when>
		        <c:otherwise>
		          <div class="item">
		            <c:out value="${noReportMsg != null ? noReportMsg : '신고 내역이 없습니다.'}"/>
		          </div>
		        </c:otherwise>
		      </c:choose>
		    </section>
		  </div>
		
		  <!-- 하단: 추천 기사 (페이징 없음) -->
		  <section class="panel" style="margin-top:24px">
		    <h3 style="text-align:center;margin-bottom:12px">추천 기사</h3>
		    <c:choose>
		      <c:when test="${not empty recommendList}">
		        <c:forEach var="item" items="${recommendList}">
		          <div class="item">
		            <div class="title"><a><c:out value="${item.title}"/></a></div>
		            <div class="summary"><c:out value="${item.summary}"/></div>
		            <div class="meta">
		              <span class="press"><c:out value="${item.press}"/></span>
		              <span class="date"><fmt:formatDate value="${item.regDt}" pattern="yyyy-MM-dd"/></span>
		            </div>
		          </div>
		        </c:forEach>
		      </c:when>
		      <c:otherwise>
		        <div class="item">
		          <c:out value="${noRecommendMsg != null ? noRecommendMsg : '추천 기사가 없습니다.'}"/>
		        </div>
		      </c:otherwise>
		    </c:choose>
		  </section>
		
		</div>

    </div>
    </main>
    
     <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
   </div> 
</body>
</html>