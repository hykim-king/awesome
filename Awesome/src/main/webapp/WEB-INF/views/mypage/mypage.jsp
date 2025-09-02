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
<!-- 구글 차트 -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<!-- 워드 클라우드 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/wordcloud2.js/1.1.2/wordcloud2.min.js"></script>


</head>
<body>
<div id="container">
  <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
  <jsp:include page="/WEB-INF/views/include/sidebar.jsp"></jsp:include>
  <jsp:include page="/WEB-INF/views/include/leftsidebar.jsp"></jsp:include>

  <main id="main">
    <div class="main-container">
      <div class="wrap">

        <!-- 상단: 요약 -->
        <section class="panel summary-section">
		  <div class="chart-summary" id="summary" style="white-space:pre-line;margin-bottom:12px"></div>
		</section>
        <div class="grid top">
	        <div class="categoryChart-wrapper">
	          <div id="categoryChart" style="height:240px;"></div>
	          <div class="categoryChart-title">한 주간 읽은 카테고리</div>
	        </div>
	        <div class="trendChart-wrapper">
	          <div id="trendChart" style="height:240px;"></div>
	          <div class="trendChart-title">요일별 기사 추이</div>
	        </div>
        </div>
        
        <!-- 차트 확대용 모달 -->
        <div id="chartModal" class="modal" style="display:none;">
          <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <div id="expandedChart" style="width:90%; height:500px; margin:auto; display:none;"></div>
            <div id="expandedWordCloud" style="width:90%; height:500px; margin:auto; display:none;"></div>
          </div>
        </div>

          <!-- 북마크 패널 -->
          <section class="panel recommend">
            <div class="section-title"><span class="badge">북마크</span></div>
            <div id="bookmarkList"></div>
            <div id="bookmarkPagination" class="pagination" style="margin-top:8px"></div>
          </section>

        <!-- 중단: 좌(워드클라우드) / 우(신고) -->
        <div class="grid middle">
            <!-- 워드클라우드 (중간 배너 느낌) -->
			<section class="panel wordcloud-section">
			  <div class="wordCloud" id="wordCloud"></div>
			</section>
	          <!-- 신고 패널 -->
	         <section class="panel report">
	           <div class="section-title"><span class="badge">신고사항</span></div>
	           <div id="reportList"></div>
	           <div id="reportPagination" class="pagination" style="margin-top:8px"></div>
	         </section>
	     </div>

        <!-- 하단: 추천 기사 (기존 JSTL 그대로 유지) -->
        <section class="panel recommend" style="margin-top:24px">
          <div class="section-title"><span class="badge">추천기사</span></div>
          <div id="recommendList"></div>
        </section>

      </div>
    </div>
  </main>

  <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</div>

<!-- 구글 차트 요약 -->
<script>
fetch('${CP}/mypage/api/mypage/summary')
  .then(res => res.text())
  .then(msg => {
    document.getElementById("summary").innerText = msg;
  });
</script>

<script>
// -------------------------------
// 공통 모달 제어
// -------------------------------
function openChartModal(dataTable, options, type) {
  const modal = document.getElementById("chartModal");
  modal.style.display = "block";

  // Chart 영역 보이기 / WordCloud 영역 숨기기
  document.getElementById("expandedChart").style.display = "block";
  document.getElementById("expandedWordCloud").style.display = "none";

  // 차트 그리기
  let chart;
  if (type === 'BarChart') {
    chart = new google.visualization.BarChart(document.getElementById("expandedChart"));
  } else {
    chart = new google.visualization.ColumnChart(document.getElementById("expandedChart"));
  }
  chart.draw(dataTable, { ...options, chartArea: { width: '90%', height: '80%' } });
}

function openWordCloudModal(list) {
  const modal = document.getElementById("chartModal");
  modal.style.display = "block";

  // WordCloud 영역 보이기 / Chart 영역 숨기기
  document.getElementById("expandedChart").style.display = "none";
  const el = document.getElementById("expandedWordCloud");
  el.style.display = "block";

  // 모달이 실제 크기를 잡은 후 렌더링 (약간 딜레이)
  setTimeout(() => {
    WordCloud(el, {
      list,
      gridSize: 8,
      weightFactor: 30,
      fontFamily: 'Arial',
      color: 'random-dark',
      rotateRatio: 0,
      backgroundColor: '#fff',
      clearCanvas: true
    });
  }, 100);
}

function closeModal() {
  const modal = document.getElementById("chartModal");
  modal.style.display = "none";

  // 모달 닫을 때 모든 영역 숨김
  document.getElementById("expandedChart").style.display = "none";
  document.getElementById("expandedWordCloud").style.display = "none";
}
</script>

<!-- 워드 클라우드 -->
<script>
document.addEventListener('DOMContentLoaded', function () {
  const el = document.getElementById('wordCloud');
  if (!el) return;

  // 너무 작게 그려지는 것 방지
  if (!el.style.minHeight) el.style.minHeight = '260px';

  fetch('${CP}/mypage/api/mypage/wordcloud')
    .then(response => {
      if (!response.ok) throw new Error('HTTP ' + response.status);
      return response.json();
    })
    .then(data => {
      if (!Array.isArray(data) || data.length === 0) {
        el.innerHTML = '<div class="empty">오늘의 토픽을 살펴보세요!</div>';
        return;
      }

      const list = data.map(item => [item.keyword, item.count]);

      // 컨테이너 크기 기준으로 스케일
      const w = el.clientWidth  || 600;
      const h = el.clientHeight || 500;

      // count 범위
      const counts = data.map(d => d.count);
      const minC = Math.min(...counts);
      const maxC = Math.max(...counts);

      // 글자 크기(원하면 값만 조절)
      const MIN_PX = 18;
      const MAX_PX = Math.floor(Math.min(w, h) * 0.36);

      // 단어 1개면 큼직, 여러 개면 선형 매핑
      const wf = (size) => {
        if (list.length <= 1) return MAX_PX;
        const denom = (maxC - minC) || 1;
        const ratio = (size - minC) / denom;
        return Math.round(MIN_PX + ratio * (MAX_PX - MIN_PX));
      };

      const gridSize = Math.max(4, Math.round(8 * w / 800));

      WordCloud(el, {
        list,
        gridSize,
        weightFactor: wf,
        fontFamily: 'Arial',
        color: 'random-dark',
        rotateRatio: 0,
        backgroundColor: '#fff',
        clearCanvas: true
        
      });
      // ✅ 클릭 시 모달 열기
      el.addEventListener('click', function () {
        openWordCloudModal(list);
      });
    })
    .catch(err => {
      console.error('[wordcloud]', err);
      el.innerHTML = '<div class="error">워드클라우드를 불러오지 못했습니다.</div>';
    });
});

</script>

<!-- 구글 차트 -->
<script>
google.charts.load("current", { packages: ["corechart"] });
google.charts.setOnLoadCallback(drawCharts);

function drawCharts() {
  // 1. 카테고리별 (BarChart)
  fetch('${CP}/mypage/api/mypage/chart')
    .then(response => response.json())
    .then(data => {
      if (!data.length) {
        document.getElementById('categoryChart').innerHTML =
          "이번주 읽은 기사가 없습니다.";
        return;
      }

      const chartData = [['카테고리', '클릭수']];
      data.forEach(item => chartData.push([item.category, item.clickCount]));

      const dataTable = google.visualization.arrayToDataTable(chartData);
      const options = {
    		  chartArea: { width: '80%', height: '70%' },
    		  bars: 'horizontal',
    		  colors: ['#3b82f6'],
    		  animation: {
    			    startup: true,          // 처음 로드할 때 실행
    			    duration: 1000,         // 애니메이션 시간 (ms)
    			    easing: 'out'           // 'linear', 'in', 'out', 'inAndOut' 가능
    			  }
    			};

      const chart = new google.visualization.BarChart(
        document.getElementById('categoryChart')
      );
      chart.draw(dataTable, options);
  
	  // ✅ 클릭 이벤트 추가 (차트 전체 클릭 시 확대)
      google.visualization.events.addListener(chart, 'select', function() {
    	  openChartModal(dataTable, options, 'BarChart');
    	});
	});

  // 2. 날짜별 추이 (ColumnChart)
  fetch('${CP}/mypage/api/mypage/trend')
    .then(response => response.json())
    .then(data => {
      if (!data.length) {
        document.getElementById('trendChart').innerHTML =
          "날짜별 추이 데이터가 없습니다.";
        return;
      }

      const chartData = [['요일', '클릭수']];
      data.forEach(item => chartData.push([item.dayOfWeek, item.clickCount]));

      const dataTable = google.visualization.arrayToDataTable(chartData);
      const options = {
        chartArea: { width: '80%', height: '70%' },
        colors: ['#10b981'],
        legend: { position: 'none' },
        animation: {
            startup: true,          // 처음 로드할 때 실행
            duration: 1000,         // 애니메이션 시간 (ms)
            easing: 'out'           // 'linear', 'in', 'out', 'inAndOut' 가능
          }
        };

      const chart = new google.visualization.ColumnChart(
        document.getElementById('trendChart')
      );
      chart.draw(dataTable, options);

      // ✅ ColumnChart도 확대 이벤트 추가
      google.visualization.events.addListener(chart, 'select', function() {
    	  openChartModal(dataTable, options, 'ColumnChart');
    	});
    });
}

</script>

<script>
	//===============================
	//공통 페이지네이션 (ellipsis 지원) - ES5 문자열 연결
	//===============================
	function renderPagination(containerId, pageNo, pageSize, totalCnt, callback) {
	pageNo   = Number(pageNo)   || 1;
	pageSize = Number(pageSize) || 5;
	totalCnt = Number(totalCnt) || 0;
	
	var totalPage = Math.ceil(totalCnt / pageSize);
	var maxPagesToShow = 5;
	var pgHtml = '';
	
	if (totalPage <= 1) {
	 document.getElementById(containerId).innerHTML = '';
	 return;
	}
	
	// 콜백 이름 추출 (문자열 또는 함수객체 지원)
	var cbName = (typeof callback === 'string') 
	             ? callback 
	             : (callback && callback.name ? callback.name : null);
	if (!cbName) {
	 console.warn('renderPagination: callback name missing');
	 document.getElementById(containerId).innerHTML = '';
	 return;
	}
	
	// 이전 버튼
	if (pageNo > 1) {
	 pgHtml += '<a href="#" onclick="' + cbName + '(' + (pageNo - 1) + ', ' + pageSize + '); return false;">&lt;</a>';
	}
	
	var startPage = Math.max(1, pageNo - Math.floor(maxPagesToShow / 2));
	var endPage   = startPage + maxPagesToShow - 1;
	if (endPage > totalPage) {
	 endPage = totalPage;
	 startPage = Math.max(1, endPage - maxPagesToShow + 1);
	}
	
	// 처음 + ...
	if (startPage > 1) {
	 pgHtml += '<a href="#" onclick="' + cbName + '(1, ' + pageSize + '); return false;">1</a>';
	 if (startPage > 2) pgHtml += '<span class="ellipsis">...</span>';
	}
	
	// 현재 구간
	for (var i = startPage; i <= endPage; i++) {
	 if (i === pageNo) {
	   pgHtml += '<span class="current">' + i + '</span>';
	 } else {
	   pgHtml += '<a href="#" onclick="' + cbName + '(' + i + ', ' + pageSize + '); return false;">' + i + '</a>';
	 }
	}
	
	// ... + 마지막
	if (endPage < totalPage) {
	 if (endPage < totalPage - 1) pgHtml += '<span class="ellipsis">...</span>';
	 pgHtml += '<a href="#" onclick="' + cbName + '(' + totalPage + ', ' + pageSize + '); return false;">' + totalPage + '</a>';
	}
	
	// 다음 버튼
	if (pageNo < totalPage) {
	 pgHtml += '<a href="#" onclick="' + cbName + '(' + (pageNo + 1) + ', ' + pageSize + '); return false;">&gt;</a>';
	}
	
	document.getElementById(containerId).innerHTML = pgHtml;
	}

</script>

<!-- JS: 북마크/신고 AJAX 로딩 -->
<script>
function escapeHtml(text) {
	  return String(text || "")
	    .replace(/&/g, "&amp;")
	    .replace(/</g, "&lt;")
	    .replace(/>/g, "&gt;")
	    .replace(/"/g, "&quot;")
	    .replace(/'/g, "&#039;");
	}
	
//북마크
function loadBookmarks(pageNo, pageSize) {
	pageNo = Number(pageNo); 
	pageSize = Number(pageSize);

	 // NaN 방지
	  if (isNaN(pageNo)) pageNo = 1;
	  if (isNaN(pageSize)) pageSize = 5;

  const url =
	  "/ehr/mypage/bookmarks" +
	  "?pageNo=" + pageNo +
	  "&pageSize=" + pageSize +
	  "&_=" + Date.now();       // 캐시 방지
    
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
          
          html += 
       	  '<article class="item" data-article-code="' + item.articleCode + '">' +
       	    '<h4 class="title">' +
       	      '<a class="title-link" href="' + escapeHtml(item.url) + '" target="_blank" rel="noopener">' +
       	        escapeHtml(item.title) +
       	      '</a>' +
       	    '</h4>' +
       	    '<p class="summary">' + escapeHtml(item.summary) + '</p>' +
        	  '<div class="meta">' +
                 '<span class="press">' + escapeHtml(item.press) + '</span>' +
                 '<span class="date">' + escapeHtml(item.regDt) + '</span>' +
            '</div>' +
            '<button type="button" class="bookmark-btn" onclick="toggleBookmark(' + item.articleCode + ', this)">★</button>' +
          '</div>';
        });
      } 
      const target = document.getElementById("bookmarkList");
      target.innerHTML = html;
      
      // 2차 처리: 북마크된 항목은 별을 색칠해줌 (checkOne 호출)
      list.forEach(item => {
        const code = item.articleCode;
        const btn = document.querySelector(`.item[data-article-code="${code}"] .bookmark-btn`);

        if (!btn) return;

        fetch(checkOneUrl + '?articleCode=' + encodeURIComponent(code), {
          method: 'GET',
          headers: { 'Accept': 'application/json' }
        })
        .then(r => r.json())
        .then(res => {
          if (res && res.loggedIn && res.bookmarked) {
            btn.classList.add('active');  // 북마크 별 색칠
          }
        });
      });
      
   	  // 페이지네이션 (공통 함수 사용)
   	  renderPagination("bookmarkPagination", pageNo, pageSize, totalCnt, loadBookmarks);
   	  
      window.markBookmarksIn('#bookmarkList');
    }); 
}

//신고사항
function loadReports(pageNo, pageSize) {
	  pageNo = pageNo || 1;
	  pageSize = pageSize || 5;
  fetch("/ehr/mypage/reports" + "?pageNo=" + pageNo + "&pageSize=" + pageSize)
    .then(res => res.json())
    .then(data => {
      const list = data?.list;
      const totalCnt = data?.totalCnt;
      let html = "";
      if (!list || list.length === 0) {
        html = "<div class='item empty'>신고 내역이 없습니다.</div>";
      } else {
        list.forEach(item => {
      	  html += 
   		    '<div class="report-item">' +
   		      '<div class="report-title">사유: ' + escapeHtml(item.reasonLabel) + '</div>' +
   		      '<div class="report-meta">' +
   		        '<span class="status">' + escapeHtml(item.statusLabel) + '</span>' +
   		        '<span class="date">' + escapeHtml(item.regDt) + '</span>' +
   		      '</div>' +
   		    '</div>';
        });
      }
      document.getElementById("reportList").innerHTML = html;

      // 페이지네이션 (공통 함수 사용)
      renderPagination("reportPagination", pageNo, pageSize, totalCnt, loadReports);
    });
}

//추천기사
function loadRecommend() {

 fetch(`/ehr/mypage/recommend`)
  .then(res => res.json())
  .then(data => {
    const list = data || []; //배열 꺼내기
    let html = "";
    if (list.length === 0) {
      html = "<div class='item empty'>추천 기사가 없습니다.</div>";
    } else {
      list.forEach(item => {
        html += 
       	  '<article class="item" data-article-code="' + item.articleCode + '">' +
       	    '<h4 class="title">' +
       	      '<a class="title-link" href="' + escapeHtml(item.url) + '" target="_blank" rel="noopener">' +
       	        escapeHtml(item.title) +
       	      '</a>' +
       	    '</h4>' +
       	    '<p class="summary">' + escapeHtml(item.summary) + '</p>' +
            '<div class="meta">' +
               '<span class="press">' + escapeHtml(item.press) + '</span>' +
               '<span class="date">' + escapeHtml(item.regDt) + '</span>' +
          '</div>' +
          '<button type="button" class="bookmark-btn" onclick="toggleBookmark(' + item.articleCode + ', this)">★</button>' +
        '</div>';
      });
    } 
    const target = document.getElementById("recommendList");
    target.innerHTML = html;
    // 🔥 북마크 색칠 로직은 렌더링 이후 실행해야 함
    window.markBookmarksIn('#recommendList');
  });
}

// 페이지 로드 시 자동 호출
document.addEventListener("DOMContentLoaded", function() {
  loadBookmarks();
  loadReports();
  loadRecommend();
});
</script>

<!-- 기존 추천 기사 색칠 스크립트 유지 -->
<script>
const toggleUrl   = '<c:url value="/mypage/toggleBookmark.do"/>';
const checkOneUrl = '<c:url value="/mypage/checkOne"/>';

(function(){

	// 컨테이너 내부의 .item[data-article-code]만 색칠 (스코프 안전)
	window.markBookmarksIn = function (containerSelector) {
	  const container = document.querySelector(containerSelector);
	  if (!container) return;

	  const items = container.querySelectorAll('.item[data-article-code]');
	  items.forEach(function (el) {
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
	};

	// 기존 요구: 추천 패널 색칠
	window.markRecommendBookmarks = function () {
	  window.markBookmarksIn('.recommend');  // 추천/신고 섹션들이 .recommend
	};

	document.addEventListener('DOMContentLoaded', function () {
	  window.markRecommendBookmarks(); // 서버 렌더된 추천이 있으면 초기 한 번
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
