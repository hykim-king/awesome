<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="CP" value="${pageContext.request.contextPath }" /> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${CP}/resources/css/pcwk_main.css">
<link rel="stylesheet" href="${CP}/resources/css/header.css">
<link rel="stylesheet" href="${CP}/resources/css/mypage.css">
<title>마이페이지</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<!-- 구글 차트 요약 -->
<script>
fetch('${CP}/mypage/api/mypage/summary')
  .then(res => res.text())
  .then(msg => {
    document.getElementById("summary").innerText = msg;
  });
</script>

<!-- 구글 차트 -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script>
google.charts.load("current", {packages:["corechart"]});
google.charts.setOnLoadCallback(drawChart);

function drawChart() {
  fetch('${CP}/mypage/api/mypage/chart')
    .then(response => response.json())
    .then(data => {
      if (data.length === 0) {
        document.getElementById('piechart_3d').innerHTML =
          "이번주 읽은 기사가 없습니다.<br>핫이슈 '오늘의 토픽'을 살펴보세요!";
        return;
      }
      const chartData = [['카테고리', 'Frequency per Week']];
      data.forEach(item => chartData.push([item.category, item.clickCount]));
      const dataTable = google.visualization.arrayToDataTable(chartData);
      const options = {
        title: '한 주간 읽은 카테고리',
        is3D: true,
        backgroundColor: 'transparent'
      };
      const chart = new google.visualization.PieChart(
        document.getElementById('piechart_3d')
      );
      chart.draw(dataTable, options);
    })
    .catch(() => {
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
    <jsp:include page="/WEB-INF/views/include/leftsidebar.jsp" />
    
      <!--main-->
      <main id="main">
      <div class="main-container">
		<div class="wrap">
    
		  <!-- 상단: 요약 + 차트/워드클라우드 -->
		  <div id="summary" style="white-space:pre-line;margin-bottom:12px"></div>
		  <div class="grid top">
		    <div id="piechart_3d" style="height:240px;"></div>
		    <div class="wordCloud" id="wordCloud"  style="height:240px;"></div>
		  </div>

		<!-- 중단: 좌(북마크) / 우(신고) -->
		  <div class="grid middle">
		    <!-- 북마크 패널 (현재 컨트롤러와 100% 호환: list/totalCnt/pageNo/pageSize) -->
		    <section class="panel recommend" style="margin-top:24px">
		      <div class="section-title"><span class="badge">북마크</span></div>
		      <c:choose>
		        <c:when test="${not empty list}">
		          <c:forEach var="item" items="${list}">
		            <div class="item" data-article-code="${item.articleCode}">
		              <div class="title"><a><c:out value="${item.title}"/></a></div>
		              <div class="summary"><c:out value="${item.summary}"/></div>
		              <div class="meta">
		                <span class="press"><c:out value="${item.press}"/></span>
		                <span class="date"><fmt:formatDate value="${item.regDt}" pattern="yyyy-MM-dd"/></span>
		              </div>
		              
		              <!-- 북마크 버튼 -->
		              <button type="button"
		                      class="bookmark-btn"
		                      onclick="toggleBookmark('${item.articleCode}', this)">★</button>
		            </div>
		          </c:forEach>
		        </c:when>
		        <c:otherwise>
		          <div class="item empty"><c:out value="${noBookmarkMsg}"/></div>
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
		    <section class="panel recommend" style="margin-top:24px">
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
		          <div class="item empty">
		            <c:out value="${noReportMsg != null ? noReportMsg : '신고 내역이 없습니다.'}"/>
		          </div>
		        </c:otherwise>
		      </c:choose>
		    </section>
		  </div>
		
		  <!-- 하단: 추천 기사 (페이징 없음) -->
		  <section class="panel recommend" style="margin-top:24px">
		    <h3 style="text-align:center;margin-bottom:12px">추천 기사</h3>
		    <c:choose>
		      <c:when test="${not empty recommendList}">
		        <c:forEach var="item" items="${recommendList}">
		          <div class="item" data-article-code="${item.articleCode}">
		            <div class="title"><a><c:out value="${item.title}"/></a></div>
		            <div class="summary"><c:out value="${item.summary}"/></div>
		            <div class="meta">
		              <span class="press"><c:out value="${item.press}"/></span>
		              <span class="date"><fmt:formatDate value="${item.regDt}" pattern="yyyy-MM-dd"/></span>
		            </div>
		            
		            <!-- 추천 기사용 북마크 버튼 -->
		            <button type="button"
		                    class="bookmark-btn"
		                    onclick="toggleBookmark('${item.articleCode}', this)">★</button>
		          </div>
		        </c:forEach>
		      </c:when>
		      <c:otherwise>
		        <div class="item empty">
		          <c:out value="${noRecommendMsg != null ? noRecommendMsg : '추천 기사가 없습니다.'}"/>
		        </div>
		      </c:otherwise>
		    </c:choose>
		  </section>
		   <div class="userInfo-btn-wrap">
		    <a href="${CP}/mypage/userInfo.do" class="userInfo-btn">회원정보</a>
		   </div>
		</div>



  <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</div>

<!-- JS: 북마크/신고 AJAX 로딩 -->
<script>
function formatDate(ms) {
	  const timestamp = typeof ms === 'string' ? Number(ms) : ms;
	  const date = new Date(timestamp);
	  if (isNaN(date.getTime())) return "--"; // invalid date 처리
	  const year = date.getFullYear();
	  const month = String(date.getMonth() + 1).padStart(2, '0');
	  const day = String(date.getDate()).padStart(2, '0');
	  return `${year}-${month}-${day}`;
	}

function escapeHtml(text) {
	  return String(text || "")
	    .replace(/&/g, "&amp;")
	    .replace(/</g, "&lt;")
	    .replace(/>/g, "&gt;")
	    .replace(/"/g, "&quot;")
	    .replace(/'/g, "&#039;");
	}
	
function loadBookmarks(pageNo, pageSize) {
	  pageNo = pageNo || 1;
	  pageSize = pageSize || 5;


 const url =
    `/ehr/mypage/bookmarks` +
    `?pageNo=${pageNo}` +              // 혹시 커스텀 컨트롤러가 쓰는 경우 대비
    `&page=${pageNo - 1}` +            // Spring Data JPA Pageable (0-based)
    `&size=${pageSize}` +              // Spring Data JPA Pageable
    `&pageSize=${pageSize}` +          // 커스텀 대비
    `&_=${Date.now()}`;                // 캐시 방지

  console.log("📌 fetch URL:", url);

  fetch(url, { headers: { 'Accept':'application/json' }, cache: 'no-store' })
    .then(res => res.json())
    .then(data => {
      const list = data?.list || []; //배열 꺼내기
      const totalCnt = data?.totalCnt || 0; //총 건수 꺼내기
      let html = "";
      if (list.length === 0) {
        html = "<div class='item empty'>북마크가 없습니다.</div>";
      } else {
        list.forEach(item => {
        	console.log("📌 item:", item);
       	    console.log("📌 item.title:", item.title);
       	    console.log("📌 item.summary:", item.summary);
       	    console.log("📌 item.press:", item.press);
       	 console.log("📌 item.regDt:", item.regDt, typeof item.regDt);
       	console.log("📌 parsed date:", new Date(Number(item.regDt)));
          html += 
            '<div class="item">' +
              '<div class="title">' + escapeHtml(item.title) + '</div>' +
              '<div class="summary">' + escapeHtml(item.summary) + '</div>' +
        	  '<div class="meta">' +
                 '<span class="press">' + escapeHtml(item.press) + '</span>' +
                 '<span class="date">' + formatDate(Number(item.regDt)) + '</span>' +
            '</div>' +
            '<button type="button" class="bookmark-btn" onclick="toggleBookmark(' + item.articleCode + ', this)">★</button>' +
          '</div>';
        });
      } 
      const target = document.getElementById("bookmarkList");
      console.log("📌 target:", target);
      target.innerHTML = html;
      console.log("📌 after set:", target.innerHTML);
      // 페이지네이션
      // (가급적 숫자로 강제 변환)
	  pageNo = Number(pageNo || 1);
	  pageSize = Number(pageSize || 5);
      const totalPage = Math.ceil(totalCnt / pageSize);
      if (totalPage >= 1) {
    	  let pgHtml = "";
    	  for (let i = 1; i <= totalPage; i++) {
    	    if (i === pageNo) {
    	      pgHtml += '<span class="current">' + i + '</span>';
    	    } else {
    	      pgHtml += '<a href="#" onclick="loadBookmarks(' + i + ', ' + pageSize + ')">' + i + '</a>';
    	    }
    	  }
    	  document.getElementById("bookmarkPagination").innerHTML = pgHtml;
    	}
    }); 
}

function loadReports(pageNo, pageSize) {
	  pageNo = pageNo || 1;
	  pageSize = pageSize || 5;
	  console.log("📌 pageNo:", pageNo, "pageSize:", pageSize);
  fetch(`/ehr/mypage/reports?pageNo=${pageNo}&pageSize=${pageSize}`)
    .then(res => res.json())
    .then(data => {
      console.log("📌 신고 응답:", data);   // 👉 서버에서 온 데이터 확인
      const list = data?.list;
      const totalCnt = data?.totalCnt;
      let html = "";
      if (!list || list.length === 0) {
        html = "<div class='item empty'>신고 내역이 없습니다.</div>";
      } else {
        list.forEach(item => {
      	  html += 
   		    '<div class="item">' +
   		      '<div class="title">코드: ' + escapeHtml(item.reportCode) + '</div>' +
   		      '<div class="summary">사유: ' + escapeHtml(item.reason) + '</div>' +
   		      '<div class="meta">' +
   		        '<span class="status">' + escapeHtml(item.status) + '</span>' +
   		        '<span class="date">' + escapeHtml(item.regDt) + '</span>' +
   		      '</div>' +
   		    '</div>';
        });
      }
      document.getElementById("reportList").innerHTML = html;

      // 페이지네이션
      const totalPage = Math.ceil(totalCnt / pageSize);
      let pgHtml = "";
      for (let i = 1; i <= totalPage; i++) {
        if (i === pageNo) {
          pgHtml += '<span class="current">' + i + '</span>';
        } else {
          pgHtml += '<a href="#" onclick="loadReports(' + i + ', ' + pageSize + ')">' + i + '</a>';
        }
      }
      document.getElementById("reportPagination").innerHTML = pgHtml;
    });
}

// 페이지 로드 시 자동 호출
document.addEventListener("DOMContentLoaded", function() {
  loadBookmarks();
  loadReports();
});
</script>

<!-- 기존 추천 기사 색칠 스크립트 유지 -->
<script>
(function(){
   const toggleUrl   = '<c:url value="/mypage/toggleBookmark.do"/>';
   const checkOneUrl = '<c:url value="/mypage/checkOne"/>';

   // 추천 기사 초기 색칠
   document.addEventListener('DOMContentLoaded', function () {
     const recItems = document.querySelectorAll('.recommend .item[data-article-code]');
     recItems.forEach(function(el){
       const code = el.getAttribute('data-article-code');
       const btn  = el.querySelector('.bookmark-btn');
       if (!btn || !code) return;

       fetch(checkOneUrl + '?articleCode=' + encodeURIComponent(code), {
         method: 'GET',
         headers: { 'Accept': 'application/json' }
       })
       .then(r => r.json())
       .then(res => {
         if (res && res.loggedIn && res.bookmarked) btn.classList.add('active');
       });
     });
   });

   // 토글 API 호출 (버튼 클릭 시)
   window.toggleBookmark = function(articleCode, btn){
     fetch(toggleUrl, {
       method: 'POST',
       headers: {
         'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
         'Accept': 'application/json'
       },
       body: new URLSearchParams({ articleCode })
     })
     .then(r => r.json())
     .then(res => {
       if (!res) return;
       if (res.flag === -99 || res.messageId === -99) { 
           alert(res.message || '로그인이 필요합니다.'); 
           return; 
       }
       location.reload();
       btn.classList.toggle('active', !!res.bookmarked);
     })
     .catch(() => alert('요청 중 오류가 발생했습니다.'));
   };
 })();
</script>
</body>
</html>
