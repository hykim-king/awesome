<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>뉴스 기사 목록</title>

<!-- 공용 레이아웃/헤더 CSS (pcwk_main.css에는 #container 그리드, header.css에는 상단바/서브메뉴) -->
<c:url var="mainCss" value="/resources/css/pcwk_main.css"/>
<c:url var="headerCss" value="/resources/css/header.css">
  <c:param name="v" value="20250828"/>
</c:url>
<link rel="stylesheet" href="${mainCss}">
<link rel="stylesheet" href="${headerCss}">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sidebar_category.css?v=1" />
<c:url var="bannerImg" value="/resources/file/banner.png"/>
<style>
/* 보이기/숨기기 */
.hidden{ display:none !important; }

/* 모달 전체 레이어 */
.login-modal{ position:fixed; inset:0; z-index:1000; }

/* 반투명 배경 */
.login-modal_backdrop{ position:absolute; inset:0; background:rgba(0,0,0,.4); }

/* 모달 카드 */
.login-modal_card{
  position:absolute; left:50%; top:50%; transform:translate(-50%,-50%);
  width:min(420px,90vw); background:#fff; border-radius:12px; padding:20px;
  box-shadow:0 10px 30px rgba(0,0,0,.2);}
/* 배너 행을 그리드에 추가(이 페이지에서만 적용) */
.page-article-list #container{
  grid-template-areas:
    "header header header header"
    "banner banner banner banner"   /* ← 헤더 아래 배너 */
    "leftsidebar main   main   sidebar"
    "footer footer footer footer";
  grid-template-rows: auto auto minmax(650px,auto) 100px;
}
/* 배너 한 세트(가운데 정렬 + 전체폭 + 배경 이미지) */
.page-article-list #container > .category-hero{

  grid-area: banner;
  grid-column: 1 / -1;

  /* 레이아웃/크기 */
  width: 100%;
  max-width: none;
  margin: 0 0 12px;
  border-radius: 0;      

  /* 배경(오버레이 + 이미지) */
  background:
    linear-gradient(to right, rgba(0,0,0,.30), rgba(0,0,0,.15)),
    url('${bannerImg}') center/cover no-repeat;
  color: #fff;
  min-height: 100px;      

  /* 텍스트 중앙 정렬 */
  display: grid;
  place-items: center;    
  padding: 0 20px;  
}

/* 배너 타이틀 스타일 */
.page-article-list .category-hero h1{
  margin: 0;
  font-size: 28px;        
  font-weight: 800;
  letter-spacing: .2px;
  text-shadow: 0 2px 8px rgba(0,0,0,.35); 
}
/* 헤더와 배너 사이 그리드 간격만 0으로 */
.page-article-list #container { row-gap: 0 !important; }

/* 헤더 여백/테두리는 건드리지 않음(초기화 코드가 있다면 제거) */

/* 배너만 살짝 내리기 — 숫자만 조절해서 미세 튜닝 */
.page-article-list #container > .category-hero{
  margin-top: 0px !important;
}

/*이하 컬러 수정_가민경*/
/* 검색 버튼 색 */
.page-article-list #main .search-box button[type="submit"]{
  background:#28396E; 
  border-color:#28396E;
  color:#fff;
}
.page-article-list #main .search-box button[type="submit"]:hover{
  background:#1f2c54;    /* hover 시 조금 어둡게 */
  border-color:#1f2c54;
}

/* 페이지네이션 - 현재 페이지 색 */
.page-article-list .paging .activePage{
  background:#28396E;   
  border-color:#28396E;
  color:#fff;
}

/* 페이지번호 hover 색 */
.page-article-list .paging a:hover{
  background:#b8c3e3;   
  border-color:#b8c3e3;
  color:#28396E;
}

/*기사 제목*/
.page-article-list .news-title a{
  color:#3d3312; 
}
.page-article-list .news-title a:visited{
 color:#a8903b;
} 

</style>
<script>
/* 새로고침 시 검색 조건 초기화 (category만 유지) */
(function (){
  try {
    var base = "${pageContext.request.contextPath}/article/list.do";
    // isListPath : 현재 경로가 기사 목록 페이지 인지 확인
    var isListPath = location.pathname.indexOf("/article/list.do") !== -1;
    // 최신 스펙과 구 스펙 모두 대응(최신 스펙과 구 스펙에서 쓰는 용어가 다름)
    var nav = (performance && performance.getEntriesByType)
      ? performance.getEntriesByType("navigation")[0] : null;

    var isReload = false;
    if (nav && typeof nav.type === "string") {
      isReload = (nav.type === "reload");
    } else if (performance && performance.navigation) {
      isReload = (performance.navigation.type === performance.navigation.TYPE_RELOAD);
    }

    if (isReload && isListPath) {
      var url = new URL(location.href);
      var sp = url.searchParams;

      var cat = sp.get("category");
      var sp2 = new URLSearchParams(sp.toString());
      sp2.delete("category");
      //hasOtherParams : 카테고리 제외하고 다른 파라미터가 남아있는지 확인
      var hasOtherParams = (sp2.toString() !== "");
      //리다이렉트 목표, 카테고리가 있으면 카테고리 값 없으면 그냥 base
      var target = cat ? (base + "?category=" + encodeURIComponent(cat)) : base;
      //onlyCategory: 쿼리가 아예 없거나 카테고리만 있는 상태
      var onlyCategory = (!hasOtherParams && (sp.has("category") || sp.toString() === ""));
      //카테고리만 가지고 있는 상태가 아니라면 기록을 남기지 않고 교체
      if (!onlyCategory) {
        location.replace(target);
      }
    }
  } catch (e) {
    console.error(e);
  }
})();
</script>
</head>

<body class="page-article-list" data-cat="${empty category ? param.category : category}">
<div id="container">
  <!-- 헤더 -->
  <jsp:include page="/WEB-INF/views/include/header.jsp" />

  <%-- category 값 가져오기 (모델/파라미터 중 우선) --%>
  <c:set var="curCat" value="${empty category ? param['category'] : category}" />

  <%-- 문자열로 정규화: 공백 제거, 비어있으면 ALL로 --%>
  <c:set var="catStr" value="${curCat}" />
  <c:if test="${not empty catStr}">
    <c:set var="catStr" value="${fn:trim(catStr)}" />
  </c:if>
  <c:if test="${empty catStr}">
    <c:set var="catStr" value="ALL" />
  </c:if>

  <%-- 표시 이름 매핑 --%>
  <c:choose>
    <c:when test="${catStr eq '10'}"><c:set var="catName" value="정치"/></c:when>
    <c:when test="${catStr eq '20'}"><c:set var="catName" value="경제"/></c:when>
    <c:when test="${catStr eq '30'}"><c:set var="catName" value="사회"/></c:when>
    <c:when test="${catStr eq '40'}"><c:set var="catName" value="스포츠"/></c:when>
    <c:when test="${catStr eq '50'}"><c:set var="catName" value="연예"/></c:when>
    <c:when test="${catStr eq '60'}"><c:set var="catName" value="IT/과학"/></c:when>
    <c:otherwise><c:set var="catName" value="전체"/></c:otherwise>
  </c:choose>

  <div class="category-hero" role="banner" aria-label="${catName} 기사">
    <h1>${catName} 기사</h1>
  </div>

  <!-- 메인 -->
  <main id="main">
    <!-- 검색 폼 -->
    <c:url var="searchAction" value="/article/list.do" />
    <form method="get" action="${searchAction}" class="search-box">
      <input type="hidden" name="category" value="${category}" />
      <input type="hidden" name="pageNum" value="1" />
      <input type="hidden" name="pageSize" value="${pageSize}" />
      <select name="searchDiv">
        <option value="10" ${searchDiv == '10' ? 'selected' : ''}>제목</option>
        <option value="20" ${searchDiv == '20' ? 'selected' : ''}>내용</option>
        <option value="30" ${searchDiv == '30' ? 'selected' : ''}>언론사</option>
      </select>
      <input type="text" name="searchWord" value="${searchWord}" placeholder="검색어를 입력하세요" />
      <input type="date" name="dateFilter" value="${dateFilter}" />
      <button type="submit">검색</button>
    </form>

    <!-- 기사 리스트 -->
    <div class="news-list">
      <c:choose>
        <c:when test="${not empty list}">
          <c:set var="now" value="<%=new java.util.Date()%>" />
          <fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="nowYmd" />
          <c:forEach var="item" items="${list}">
            <div class="news-item">
              <c:url var="hitUrl" value="/article/hit.do">
                <c:param name="articleCode" value="${item.articleCode}" />
              </c:url>
              <c:url var="bmToggleUrl" value="/bookmark/toggleBookmark.do">
                <c:param name="articleCode" value="${item.articleCode}" />
              </c:url>

              <!-- 제목 + 북마크 -->
              <div class="news-header">
                <div class="news-title">
                  <c:url var="visitUrl" value="/article/visit.do">
                    <c:param name="articleCode" value="${item.articleCode}" />
                  </c:url>
                  <!-- noopener noreferrer: 보안, 프라이버시  옵션 -->
                  <a href="${visitUrl}"
                     target="_blank"
                     rel="noopener noreferrer"
                     data-article-code="${item.articleCode}">
                    ${item.title}
                  </a>
                </div>

                <c:choose>
                  <c:when test="${not empty sessionScope.loginUser}">
                    <button type="button" class="bm-btn"
                            data-toggle-url="${bmToggleUrl}"
                            data-article-code="${item.articleCode}" aria-pressed="false"
                            title="북마크 추가">
                      <span class="bm-icon">☆</span>
                    </button>
                  </c:when>
                  <c:otherwise>
                    <button type="button" class="bm-btn guest"
                            data-toggle-url="${bmToggleUrl}"
                            data-article-code="${item.articleCode}" title="로그인이 필요합니다.">
                      <span class="bm-icon">☆</span>
                    </button>
                  </c:otherwise>
                </c:choose>
              </div>

              <!-- 요약 + 메타 -->
              <div class="news-body">
                <div class="summary">
                  <c:choose>
                    <c:when test="${not empty item.summary and fn:length(item.summary) > 50}">
                      ${fn:substring(item.summary,0,50)}...
                    </c:when>
                    <c:otherwise>${item.summary}</c:otherwise>
                  </c:choose>
                </div>

                <div class="meta-line">
                  <span>${item.press}</span>
                  <span><fmt:formatDate value="${item.publicDt}" pattern="yyyy-MM-dd" /></span>
                  <span>조회수: <span id="views-${item.articleCode}">${item.views}</span></span>
                </div>
              </div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="no-data">
            <c:choose>
              <c:when test="${not empty searchWord or not empty dateFilter}">검색한 값이 없습니다.</c:when>
              <c:otherwise>등록된 기사가 없습니다.</c:otherwise>
            </c:choose>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- 페이징 -->
    <div class="paging">
      <!-- 이전 페이지 -->
      <c:choose>
        <c:when test="${pageNum > 1}">
          <c:url var="prevUrl" value="/article/list.do">
            <c:param name="pageNum" value="${pageNum - 1}" />
            <c:param name="pageSize" value="${pageSize}" />
            <c:param name="category" value="${category}" />
            <c:param name="searchDiv" value="${searchDiv}" />
            <c:param name="searchWord" value="${searchWord}" />
            <c:param name="dateFilter" value="${dateFilter}" />
          </c:url>
          <a href="${prevUrl}">이전</a>
        </c:when>
        <c:otherwise><span class="disabled">이전</span></c:otherwise>
      </c:choose>

      <!-- 이전 블록(블록 1개 = 10)-->
      <c:if test="${startPage > 1}">
        <c:url var="prevBlkUrl" value="/article/list.do">
          <c:param name="pageNum" value="${startPage - 1}" />
          <c:param name="pageSize" value="${pageSize}" />
          <c:param name="category" value="${category}" />
          <c:param name="searchDiv" value="${searchDiv}" />
          <c:param name="searchWord" value="${searchWord}" />
          <c:param name="dateFilter" value="${dateFilter}" />
        </c:url>
        <a href="${prevBlkUrl}">«</a>
      </c:if>

      <!-- 숫자 페이지 -->
      <c:forEach var="p" begin="${startPage}" end="${endPage}">
        <c:choose>
          <c:when test="${p == pageNum}">
            <span class="activePage">${p}</span>
          </c:when>
          <c:otherwise>
            <c:url var="pageUrl" value="/article/list.do">
              <c:param name="pageNum" value="${p}" />
              <c:param name="pageSize" value="${pageSize}" />
              <c:param name="category" value="${category}" />
              <c:param name="searchDiv" value="${searchDiv}" />
              <c:param name="searchWord" value="${searchWord}" />
              <c:param name="dateFilter" value="${dateFilter}" />
            </c:url>
            <a href="${pageUrl}">${p}</a>
          </c:otherwise>
        </c:choose>
      </c:forEach>

      <!-- 다음 블록(블록 1개:10) -->
      <c:if test="${endPage < totalPage}">
        <c:url var="nextBlkUrl" value="/article/list.do">
          <c:param name="pageNum" value="${endPage + 1}" />
          <c:param name="pageSize" value="${pageSize}" />
          <c:param name="category" value="${category}" />
          <c:param name="searchDiv" value="${searchDiv}" />
          <c:param name="searchWord" value="${searchWord}" />
          <c:param name="dateFilter" value="${dateFilter}" />
        </c:url>
        <a href="${nextBlkUrl}">»</a>
      </c:if>

      <!-- 다음 페이지 -->
      <c:choose>
        <c:when test="${pageNum < totalPage}">
          <c:url var="nextUrl" value="/article/list.do">
            <c:param name="pageNum" value="${pageNum + 1}" />
            <c:param name="pageSize" value="${pageSize}" />
            <c:param name="category" value="${category}" />
            <c:param name="searchDiv" value="${searchDiv}" />
            <c:param name="searchWord" value="${searchWord}" />
            <c:param name="dateFilter" value="${dateFilter}" />
          </c:url>
          <a href="${nextUrl}">다음</a>
        </c:when>
        <c:otherwise><span class="disabled">다음</span></c:otherwise>
      </c:choose>
    </div>
  </main>

  <!-- 사이드바 -->
  <c:set var="currentCategory" value="${empty category ? param.category : category}" />
  <c:choose>
    <c:when test="${empty currentCategory or fn:trim(currentCategory) eq 'ALL'}">
      <jsp:include page="/WEB-INF/views/include/leftsidebar.jsp" />  
      <jsp:include page="/WEB-INF/views/include/sidebar.jsp" />
    </c:when>
    <c:otherwise>
      <jsp:include page="/WEB-INF/views/include/leftsidebar.jsp" />
      <jsp:include page="/WEB-INF/views/include/sidebar_category.jsp">
        <jsp:param name="category" value="${fn:trim(currentCategory)}" />
      </jsp:include>
    </c:otherwise>
  </c:choose>

  <!-- footer -->
  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
</div>


<script>
/* 리스트 화면에서만 즉시 조회수 +1 (UI 반영용) */
(function(){
  function bumpOnce(anchor){
	//중복 방지 플래그, 같은 액션에 한 번만 실행(예: 클릭, Enter 키)
    if (anchor.dataset.bumped === '1') return;
    anchor.dataset.bumped = '1';
    //기사 코드(articleCode) 추출
    var code = anchor.getAttribute('data-article-code');
    if (!code) {
      try {
        var u = new URL(anchor.href, location.origin);
        code = u.searchParams.get('articleCode');
      } catch(_) {}
    }
    if (!code) return;
    // 카운터 요소 찾기, DOM에 조회수 이벤트가 있어야 UI 업데이트 가능
    var span = document.getElementById('views-' + code);
    if (!span) return;
    // 숫자 파싱 후 +1, 텍스트에서 숫자만 추출(',' , 한글, 공백 제거), 정수 변환 실패시 0으로 간주
    var cur = parseInt((span.textContent || '').replace(/[^0-9]/g,''), 10) || 0;
    //+1한 값을 그대로 문자열로 덮어쓰기
    span.textContent = String(cur + 1);
  }
  document.addEventListener('click', function(e){
	// 부모 체인에서 대상 앵커를 탐색
    var a = e.target.closest && e.target.closest('a[href*="/article/visit.do"]');
	// 좌클릭만 처리
    if (!a || e.button !== 0) return;
    bumpOnce(a);
  }, true);
  // 가운데 클릭(새 탭) 이벤트, auxclick: 보조 버튼(가운데/오른쪽 등)
  document.addEventListener('auxclick', function(e){
    var a = e.target.closest && e.target.closest('a[href*="/article/visit.do"]');
    if (!a) return;
    //가운데 버튼이 1일 때만 증가 -> 휠 클릭으로 새 탭 떠도 즉시 +1
    if (e.button === 1) bumpOnce(a);
  }, true);
  //키보드 Enter키 이벤트
  document.addEventListener('keydown', function(e){
	//Enter로 열 때 +1
    if (e.key !== 'Enter') return;
    var a = e.target.closest && e.target.closest('a[href*="/article/visit.do"]');
    if (a) bumpOnce(a);
  }, true);
})();
</script>

<script>
/* 북마크 토글 (비로그인 모달 / 로컬 저장) */
(function () {
  //사용자 식별 & 로컬스토리지 키
  function getUserId(){
	//세션에 userId 키를 주입 비어있을 시 'guest', escapeXml: XSS 안전하게 출력
    var uid = '${fn:escapeXml(sessionScope.userId)}';
    return (uid && uid.trim && uid.trim().length) ? uid : 'guest';
  }
  //로컬스토리지 키를 사용자 단위로 분리 -> 로그인 사용자마다 독립된 북마크 상태 저장
  function storageKey(code){ return 'bm:' + getUserId() + ':' + String(code); }
  //버튼 상태 반영(토글 UI)
  function applyBtnState(btn, on){
    btn.classList.toggle('on', on);
    btn.setAttribute('aria-pressed', on ? 'true' : 'false');
    var ic = btn.querySelector('.bm-icon');
    if (ic) ic.textContent = on ? '★' : '☆';
    btn.title = on ? '북마크 해제' : '북마크 추가';
  }
  //초기 복원
  document.addEventListener('DOMContentLoaded', function(){
    var btns = document.querySelectorAll('.bm-btn');
    for (var i=0; i<btns.length; i++){
      var btn = btns[i];
      var code = btn.getAttribute('data-article-code');
      if (!code) continue;
      var v = null; try { v = localStorage.getItem(storageKey(code)); } catch(_){}
      if (v === '1') applyBtnState(btn, true);
      else if (v === '0') applyBtnState(btn, false);
    }
  });
  //로그인 모달 열기/닫기
  function showLoginModal(){
    var m = document.getElementById('login-modal');
    if (!m) { alert('로그인이 필요합니다.'); return; }
    m.classList.remove('hidden');
    m.setAttribute('aria-hidden','false');
  }
  function hideLoginModal(){
    var m = document.getElementById('login-modal');
    if (!m) return;
    m.classList.add('hidden');
    m.setAttribute('aria-hidden','true');
  }
  //서버 응답 ID 추출 유틸
  function pickMsgId(data){
    if (!data) return null;
    //병합 연산자 ??로 첫 번째 존재 값을 선택
    return (data.messageId ?? data.msgId ?? data.code ?? data.flag ?? data.status ?? null);
  }
  //북마크 토글 클릭 핸들러
  document.addEventListener('click', function(e){
	//이벤트 위임
    var btn = e.target.closest && e.target.closest('.bm-btn');
    if(!btn) return;
    //게스트 처리: guest 일 때 서버 요청 없이 모달만 띄우기
    if(btn.classList.contains('guest')){
      e.preventDefault(); e.stopPropagation();
      showLoginModal();
      return;
    }

    e.preventDefault(); e.stopPropagation();
    //더블/중복 클릭 차단
    if(btn._busy) return; btn._busy = true;

    var code = btn.getAttribute('data-article-code');
    var url = btn.getAttribute('data-toggle-url');
    //요청 URL, 없으면 기본 URL 사용
    if (!url) {
      var base = '${pageContext.request.contextPath}/bookmark/toggleBookmark.do';
      url = base + (code ? ('?articleCode=' + encodeURIComponent(code)) : '');
    }
    // 세션 쿠키 포함, 서버에서 AJAX 요청 구분 가능
    fetch(url, {
      method: 'POST',
      credentials: 'same-origin',
      headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(function(res){ if(!res.ok) throw res; return res.text(); })
    //응답 처리: 텍스트로 받고 파싱 시도
    .then(function(txt){
      var data = null; try { data = JSON.parse(txt); } catch(_) {}
      var id = pickMsgId(data);
      //-99: 인증 필요 -> 로그인 모달 띄우기
      if (id === -99){ showLoginModal(); return; }

      var nowOn  = btn.classList.contains('on');
      // 1: 북마크 추가
      var nextOn = (typeof id === 'number') ? (id === 1) : !nowOn;
      //상태 반영: UI 갱신 + 로컬스토리지
      applyBtnState(btn, nextOn);
      try { localStorage.setItem(storageKey(code), nextOn ? '1' : '0'); } catch(_){}

      if (data && data.message) console.log('bookmark:', data.message);
    })
    .catch(function(err){ console.error('북마크 토글 실패', err); })
    .finally(function(){ btn._busy = false; });
  }, false);
  //모달 닫기 핸들러
  document.addEventListener('click', function(e){
    if (e.target.closest('[data-action="close"]') ||
        e.target.classList.contains('login-modal_backdrop')) {
      hideLoginModal();
    }
  }, false);
  document.addEventListener('keydown', function(e){
    if (e.key === 'Escape') hideLoginModal();
  }, false);
})();
</script>

<!-- 로그인 안내 모달 -->
<div id="login-modal"
     class="login-modal hidden"
     aria-hidden="true"
     role="dialog"
     aria-modal="true">
  <div class="login-modal_backdrop"></div>
  <div class="login-modal_card">
    <div class="login-modal_title">로그인이 필요합니다.</div>
    <div class="login-modal_body">북마크 기능은 로그인 후 이용할 수 있습니다.</div>
    <div class="login-modal_actions">
      <button type="button" class="close-btn" data-action="close">확인</button>
    </div>
  </div>
</div>

</body>
</html>