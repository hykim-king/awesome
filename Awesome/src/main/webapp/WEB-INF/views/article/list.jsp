<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>뉴스 기사 목록</title>
<!-- 공용 헤더/메인 스타일 -->
<c:url var="mainCss" value="/resources/css/pcwk_main.css"/>
<c:url var="headerCss" value="/resources/css/header.css">
  <c:param name="v" value="20250827"/> <!-- 캐시깨기 원하면 유지 -->
</c:url>
<link rel="stylesheet" href="${mainCss}">
<link rel="stylesheet" href="${headerCss}">

<style>
/* 페이지 전용 변수 */
.page-article-list{
  --al-blue:#0a45ff;
  --al-blue-weak:#e7efff;
  --al-text:#0f172a;
  --al-muted:#6b7280;
  --al-border:#e5e7eb;
  --al-card:#ffffff;
  --al-bg:#f8fafc;
}

/* 배경/글자색 */
body.page-article-list{ background:var(--al-bg); color:var(--al-text); }

/* ★ 핵심: .layout을 컨테이너 그리드 2행(메인/사이드바 줄) 전체로 보냄 */
.page-article-list #container > .layout{
  /* pcwk_main.css의 grid-template-areas:
     "header header header header"
     "main   main   main   sidebar"
     "footer footer footer footer" 기준
     → 2번째 행(콘텐츠 줄) 전체 폭을 차지 */
  grid-row: 2 / 3;
  grid-column: 1 / -1;

  /* 내부 2열 레이아웃 구성 */
  display:grid;
  grid-template-columns:minmax(0,1fr) 280px; /* 본문 | 우측 사이드 */
  gap:16px;
  width:100%;
  max-width:1480px;
  margin:24px auto;
  padding:0 40px;
}

.page-article-list .main{ min-width:0; }
.page-article-list .aside{
  position:sticky; top:16px; align-self:start;
  border:1px solid var(--al-border);
  background:var(--al-card);
  border-radius:12px; padding:12px;
}

/* 좌측 잔상/옛 레이아웃 흔적 제거 (이 페이지 한정) */
.page-article-list #content,
.page-article-list .container,
.page-article-list .main-container,
.page-article-list .content-wrap,
.page-article-list .board-wrap,
.page-article-list .board-area,
.page-article-list .al-layout,
.page-article-list .al-list-wrap{
  display:block !important; float:none !important; width:100% !important;
  max-width:none !important; margin-left:0 !important; padding-left:0 !important;
}
.page-article-list .sidebar-left,
.page-article-list .left-sidebar,
.page-article-list .snb,
.page-article-list .lnb,
.page-article-list .nav-left,
.page-article-list .side-left{ display:none !important; }

/* 모바일 1열 */
@media (max-width:900px){
  .page-article-list #container > .layout{ grid-template-columns:1fr; padding:0 16px; }
  .page-article-list .aside{ position:static; order:2; }
}

/* ===== 검색 박스 ===== */
.search-box{
  display:grid;
  grid-template-columns:120px 380px 160px 64px; /* 셀렉트 | 텍스트 | 날짜 | 버튼 */
  gap:8px; padding:10px; margin:12px 0;
  border:1px solid var(--al-border);
  border-radius:12px; background:var(--al-card);
}
.search-box select,
.search-box input[type="text"],
.search-box input[type="date"]{
  height:38px; border:1px solid var(--al-border);
  border-radius:8px; padding:0 10px; background:#fff;
}
.search-box button{
  height:38px; border:0; border-radius:10px;
  background:var(--al-blue); color:#fff; font-weight:700; cursor:pointer;
}
.search-box button:hover{ opacity:.92; }
@media (max-width:900px){
  .search-box{ grid-template-columns:1fr 1fr; grid-auto-rows:minmax(38px,auto); }
  .search-box button{ grid-column:1/-1; }
}

/* ===== 기사 리스트 카드 ===== */
.news-list{ display:flex; flex-direction:column; gap:10px; }
.news-item{
  display:grid; grid-template-columns:1fr auto; gap:6px 12px;
  background:var(--al-card); border:1px solid var(--al-border);
  border-radius:12px; padding:12px;
  transition: box-shadow .12s, transform .12s, border-color .12s;
}
.news-item:hover{
  transform:translateY(-1px);
  box-shadow:0 6px 16px rgba(0,0,0,.06);
  border-color:#d9dee5;
}

/* 카드 상단: 제목 + 북마크 */
.news-header{ display:flex; align-items:flex-start; gap:8px; grid-column:1/-1; }
.news-header .news-title{ flex:1; min-width:0; }
.news-title a{
  color:var(--al-blue); text-decoration:none; font-weight:700;
  font-size:18px; word-break:break-word;
}
.news-title a:hover{ text-decoration:underline; }

/* 카드 하단: 요약 + 메타 */
.news-body{
  display:flex; align-items:flex-start; justify-content:space-between;
  gap:12px; grid-column:1/-1;
}
.summary{
  flex:1; min-width:0; color:#374151; margin:2px 0 4px;
  display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden;
}
.meta-line{
  display:flex; gap:10px; white-space:nowrap; color:var(--al-muted); font-size:13px;
}

/* 북마크 버튼 */
.bm-btn{
  display:inline-flex; align-items:center; justify-content:center;
  width:28px; height:28px; border-radius:999px;
  border:1px solid var(--al-border); background:#fff; cursor:pointer;
}
.bm-btn.on{ border-color:#f59e0b; background:#fff7ed; }
.bm-btn .bm-icon{ font-size:14px; line-height:1; }

/* ===== 페이징 ===== */
.paging{
  display:flex; justify-content:center; gap:8px; margin:16px 0 24px;
}
.paging a, .paging span{
  min-width:36px; height:36px;
  display:inline-flex; align-items:center; justify-content:center;
  background:#fff; border:1px solid var(--al-border); border-radius:10px;
  text-decoration:none; color:var(--al-text);
}
.paging a:hover{ border-color:var(--al-blue); color:var(--al-blue); }
.paging .activePage{ background:var(--al-blue); border-color:var(--al-blue); color:#fff; }
.paging .disabled{ color:#9ca3af; background:#f3f4f6; }

/* ===== 데이터 없음 카드 ===== */
.no-data{
  padding:24px; text-align:center; color:#6b7280;
  background:#fff; border:1px solid var(--al-border); border-radius:12px;
}

/* ===== 로그인 모달 ===== */
.hidden{ display:none !important; }
.login-modal{ position:fixed; inset:0; z-index:1000; }
.login-modal_backdrop{ position:absolute; inset:0; background:rgba(0,0,0,.4); }
.login-modal_card{
  position:absolute; left:50%; top:50%; transform:translate(-50%,-50%);
  width:min(420px,90vw); background:#fff;
  border-radius:12px; padding:20px;
  box-shadow:0 10px 30px rgba(0,0,0,.2);
}
.page-article-list{
  --al-font: Inter, Pretendard, system-ui, -apple-system, "Segoe UI", Roboto,
             "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", sans-serif;
  --al-body-size: 14px;   /* 본문 기본 크기(카테고리 페이지와 동일 값으로) */
  --al-title-size: 18px;  /* 기사 제목 크기 */
  --al-meta-size: 13px;   /* 메타(언론사/날짜/조회수) 크기 */
  --al-line-height: 1.65;
  --al-letter-spacing: -0.2px;
}

/* 본문/사이드 전체에 기본 폰트·크기 적용 */
.page-article-list .main,
.page-article-list .aside{
  font-family: var(--al-font);
  font-size: var(--al-body-size);
  line-height: var(--al-line-height);
  letter-spacing: var(--al-letter-spacing);
}

/* 검색 폼 컨트롤도 본문 타이포 상속 */
.page-article-list .search-box,
.page-article-list .search-box select,
.page-article-list .search-box input,
.page-article-list .search-box button{
  font-family: var(--al-font);
  font-size: var(--al-body-size);
}

/* 기사 카드 내부 타이포 */
.page-article-list .news-title a{
  font-size: var(--al-title-size);
  font-weight: 700;
}
.page-article-list .summary{
  font-size: var(--al-body-size);
}
.page-article-list .meta-line{
  font-size: var(--al-meta-size);
}

/* 사이드바(용어사전/채팅창 등)도 본문과 동일 타이포 */
.page-article-list .aside h3,
.page-article-list .aside .title,
.page-article-list .aside .card-title{
  font-family: var(--al-font);
  font-size: 15px;      /* 필요시 조정 */
  font-weight: 700;
}
.page-article-list .aside,
.page-article-list .aside a,
.page-article-list .aside li,
.page-article-list .aside .item{
  font-family: var(--al-font);
  font-size: var(--al-body-size);
}
}
</style>
<script>
  // 새로고침 시 검색 조건 초기화 (category만 유지)
  (function (){
    try {
      var base = "${pageContext.request.contextPath}/article/list.do";
      var isListPath = location.pathname.indexOf("/article/list.do") !== -1;

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
        var hasOtherParams = (sp2.toString() !== "");

        var target = cat ? (base + "?category=" + encodeURIComponent(cat)) : base;
        var onlyCategory = (!hasOtherParams && (sp.has("category") || sp.toString() === ""));

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

<body class="page-article-list">
    <div id="container">
	<c:if 
	   test="${empty sessionScope.userId and not empty sessionScope.loginUser}">
		<c:set var="userId" value="${sessionScope.loginUser.userId}" scope="session" />
	</c:if>
	<!-- 헤더 -->
	<jsp:include page="/WEB-INF/views/include/header.jsp" />

	<!-- 레이아웃: 메인 + 사이드 -->
	<div class="layout">
		<!-- 메인 -->
		<main class="main">
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
                                <!-- 1줄: 제목(좌) + 북마크(우) -- 가민경 수정 -->
                                <div class="news-header">
                            <div class="news-title">
                                <c:url var="visitUrl" value="/article/visit.do">
								  <c:param name="articleCode" value="${item.articleCode}" />
								</c:url>
								
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

								<!-- 2줄: 요약(좌) + 메타(우: 언론사 | 날짜 | 조회수) -->
								<div class="news-body">
									<div class="summary">
										<c:choose>
											<c:when
												test="${not empty item.summary and fn:length(item.summary) > 50}">
		        ${fn:substring(item.summary,0,50)}...
		      </c:when>
											<c:otherwise>${item.summary}</c:otherwise>
										</c:choose>
									</div>

									<div class="meta-line">
										<span>${item.press}</span> <span><fmt:formatDate
												value="${item.publicDt}" pattern="yyyy-MM-dd" /></span> <span>조회수:
											<span id="views-${item.articleCode}">${item.views}</span>
										</span>
									</div>
								</div>
							</div>
						</c:forEach>
					</c:when>
					<c:otherwise>
					<!-- 데이터 없을 시 -->
							<c:choose>
								<c:when test="${not empty searchWord or not empty dateFilter}">검색한 값이 없습니다.</c:when>
								<c:otherwise>등록된 기사가 없습니다.</c:otherwise>
							</c:choose>
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
					<c:otherwise>
						<span class="disabled">이전</span>
					</c:otherwise>
				</c:choose>

				<!-- 이전 블록 -->
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

				<!-- 다음 블록 -->
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
					<c:otherwise>
						<span class="disabled">다음</span>
					</c:otherwise>
				</c:choose>
			</div>
		</main>

		<!-- 사이드바 -->
		<aside class="aside">
			<%-- category 값: request attribute 없으면 쿼리스트링 값 사용 --%>
			<c:set var="currentCategory"
				value="${empty category ? param.category : category}" />

			<%-- 전체 기사: 비었거나 'ALL'일 때 기본 사이드바 --%>
			<c:if
				test="${empty currentCategory or fn:trim(currentCategory) eq 'ALL'}">
				<jsp:include page="/WEB-INF/views/include/sidebar.jsp" />
			</c:if>

			<%-- 카테고리 기사: 값이 있고 'ALL'이 아닐 때 카테고리 사이드바 --%>
			<c:if
				test="${not empty currentCategory and fn:trim(currentCategory) ne 'ALL'}">
				<jsp:include page="/WEB-INF/views/include/sidebar_category.jsp">
					<jsp:param name="category" value="${fn:trim(currentCategory)}" />
				</jsp:include>
			</c:if>
		</aside>
	</div>

	<!-- 로그인 안내 모달 -->
	<div id="login-modal" class="login-modal hidden" aria-hidden="true"
		role="dialog" aria-modal="true">
		<div class="login-modal_backdrop"></div>
		<div class="login-modal_card">
			<div class="login-modal_title">로그인이 필요합니다.</div>
			<div class="login-modal_body">북마크 기능은 로그인 후 이용할 수 있습니다.</div>
			<div class="login-modal_actions">
				<button type="button" class="close-btn" data-action="close">확인</button>
			</div>
		</div>
	</div>

	<!-- 푸터 -->
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
	</div>

	<script>
(function(){
  // a[href*="/article/visit.do"] 클릭/휠클릭/Enter 시, 리스트 화면에서만 즉시 +1 표시
  function bumpOnce(anchor){
    if (anchor.dataset.bumped === '1') return; // 같은 링크에서 중복 +1 방지
    anchor.dataset.bumped = '1';

    // articleCode 가져오기 (data-속성 우선, 없으면 href에서 추출)
    var code = anchor.getAttribute('data-article-code');
    if (!code) {
      try {
        var u = new URL(anchor.href, location.origin);
        code = u.searchParams.get('articleCode');
      } catch(_) {}
    }
    if (!code) return;

    var span = document.getElementById('views-' + code);
    if (!span) return;

    var cur = parseInt((span.textContent || '').replace(/[^0-9]/g,''), 10) || 0;
    span.textContent = String(cur + 1);
  }

  // 좌클릭
  document.addEventListener('click', function(e){
    var a = e.target.closest && e.target.closest('a[href*="/article/visit.do"]');
    if (!a) return;
    if (e.button !== 0) return;
    bumpOnce(a); // 새 탭 열리기 직전에 UI만 +1
  }, true);

  // 휠클릭(중클릭)
  document.addEventListener('auxclick', function(e){
    var a = e.target.closest && e.target.closest('a[href*="/article/visit.do"]');
    if (!a) return;
    if (e.button === 1) bumpOnce(a);
  }, true);

  // 키보드 Enter로 링크 열 때도 +1
  document.addEventListener('keydown', function(e){
    if (e.key !== 'Enter') return;
    var a = e.target.closest && e.target.closest('a[href*="/article/visit.do"]');
    if (a) bumpOnce(a);
  }, true);
})();
</script>

<script>
(function () {

  /* === 북마크 상태 로컬 저장/복원 헬퍼 === */
  function getUserId(){
    // 세션의 userId가 있으면 그걸 키로 사용, 없으면 'guest'
    var uid = '${fn:escapeXml(sessionScope.userId)}';
    return (uid && uid.trim && uid.trim().length) ? uid : 'guest';
  }
  function storageKey(code){
    return 'bm:' + getUserId() + ':' + String(code);
  }
  function applyBtnState(btn, on){
    btn.classList.toggle('on', on);
    btn.setAttribute('aria-pressed', on ? 'true' : 'false');
    var ic = btn.querySelector('.bm-icon');
    if (ic) ic.textContent = on ? '★' : '☆';
    btn.title = on ? '북마크 해제' : '북마크 추가';
  }

  // 페이지 로드 시 저장된 상태 복원
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

  // 서버가 어떤 키로 내려줘도 잡히도록 보강
  function pickMsgId(data){
    if (!data) return null;
    return (data.messageId ?? data.msgId ?? data.code ?? data.flag ?? data.status ?? null);
  }

  document.addEventListener('click', function(e){
    var btn = e.target.closest && e.target.closest('.bm-btn');
    if(!btn) return;

    // 비로그인 버튼: 모달
    if(btn.classList.contains('guest')){
      e.preventDefault(); e.stopPropagation();
      showLoginModal();
      return;
    }

    // 로그인 사용자(클릭 스팸/연타 방지)
    e.preventDefault(); e.stopPropagation();
    if(btn._busy) return;
    btn._busy = true;

    var code = btn.getAttribute('data-article-code'); // ← 밖으로 빼서 아래에서도 사용
    var url = btn.getAttribute('data-toggle-url');
    if (!url) {
      var base = '${pageContext.request.contextPath}/bookmark/toggleBookmark.do';
      url = base + (code ? ('?articleCode=' + encodeURIComponent(code)) : '');
    }

    fetch(url, {
      method: 'POST',
      credentials: 'same-origin',              // 세션 쿠키 보장
      headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(function(res){ if(!res.ok) throw res; return res.text(); })
    .then(function(txt){
      var data = null; try { data = JSON.parse(txt); } catch(_) {}
      var id = pickMsgId(data);

      // 로그인 필요 신호
      if (id === -99){ showLoginModal(); return; }

      // 서버가 1(추가)/0(삭제)로 주면 그 값 우선, 없으면 현재상태 토글
      var nowOn  = btn.classList.contains('on');
      var nextOn = (typeof id === 'number')
                     ? (id === 1)
                     : !nowOn;

      // UI 반영
      applyBtnState(btn, nextOn);

      // ✅ 새로고침 유지: localStorage 저장
      try { localStorage.setItem(storageKey(code), nextOn ? '1' : '0'); } catch(_){}

      if (data && data.message) console.log('bookmark:', data.message);
    })
    .catch(function(err){ console.error('북마크 토글 실패', err); })
    .finally(function(){ btn._busy = false; });

  }, false);

  // 모달 닫기(확인 버튼/배경/Esc)
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
</body>
</html>