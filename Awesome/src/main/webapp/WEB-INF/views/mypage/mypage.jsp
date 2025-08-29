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

        <!-- 상단: 요약 + 차트/워드클라우드 -->
        <div id="summary" style="white-space:pre-line;margin-bottom:12px"></div>
        <div class="grid top">
          <div id="piechart_3d" style="height:240px;"></div>
          <div class="wordCloud" id="wordCloud"></div>
        </div>

        <!-- 중단: 좌(북마크) / 우(신고) -->
        <div class="grid middle">
          <!-- 북마크 패널 -->
          <section class="panel recommend" style="margin-top:24px">
            <div class="section-title"><span class="badge">북마크</span></div>
            <div id="bookmarkList"></div>
            <div id="bookmarkPagination" class="pagination" style="margin-top:8px"></div>
          </section>

          <!-- 신고 패널 -->
          <section class="panel recommend" style="margin-top:24px">
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

        <div class="userInfo-btn-wrap">
          <a href="${CP}/mypage/userInfo.do" class="userInfo-btn">회원정보</a>
        </div>
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
      const h = el.clientHeight || 300;

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
    })
    .catch(err => {
      console.error('[wordcloud]', err);
      el.innerHTML = '<div class="error">워드클라우드를 불러오지 못했습니다.</div>';
    });
});
</script>

<!-- 구글 차트 -->
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
    	    } console.log("pgHtml:",pgHtml);
    	    console.log("pageNo:",i);
            console.log("pageSize:",pageSize);
    	  }
    	  document.getElementById("bookmarkPagination").innerHTML = pgHtml;
    	}
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
   		    '<div class="item">' +
   		      '<div class="title">사유: ' + escapeHtml(item.reasonLabel) + '</div>' +
   		      '<div class="meta">' +
   		        '<span class="status">' + escapeHtml(item.statusLabel) + '</span>' +
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
