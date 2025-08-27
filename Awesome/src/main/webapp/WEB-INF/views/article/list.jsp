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
  box-shadow:0 10px 30px rgba(0,0,0,.2);
}
</style>
<script>
/* 새로고침 시 검색 조건 초기화 (category만 유지) */
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

<body class="page-article-list" data-cat="${empty category ? param.category : category}">
<div id="container">
  <!-- 헤더(그리드: header) -->
  <jsp:include page="/WEB-INF/views/include/header.jsp" />

  <!-- 메인(그리드: main) -->
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
        <c:otherwise><span class="disabled">다음</span></c:otherwise>
      </c:choose>
    </div>
  </main>

  <!-- 사이드바(그리드: sidebar) — 포함만 함. 포함된 JSP의 루트가 <div id="sidebar"> 이어야 함 -->
  <c:set var="currentCategory" value="${empty category ? param.category : category}" />
  <c:choose>
    <c:when test="${empty currentCategory or fn:trim(currentCategory) eq 'ALL'}">
      <jsp:include page="/WEB-INF/views/include/sidebar.jsp" />
    </c:when>
    <c:otherwise>
      <jsp:include page="/WEB-INF/views/include/sidebar_category.jsp">
        <jsp:param name="category" value="${fn:trim(currentCategory)}" />
      </jsp:include>
    </c:otherwise>
  </c:choose>

  <!-- 푸터(그리드: footer) -->
  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
</div>

<!-- ===== 스크립트 ===== -->
<script>
/* 리스트 화면에서만 즉시 조회수 +1 (UI 반영용) */
(function(){
  function bumpOnce(anchor){
    if (anchor.dataset.bumped === '1') return;
    anchor.dataset.bumped = '1';

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

  document.addEventListener('click', function(e){
    var a = e.target.closest && e.target.closest('a[href*="/article/visit.do"]');
    if (!a || e.button !== 0) return;
    bumpOnce(a);
  }, true);

  document.addEventListener('auxclick', function(e){
    var a = e.target.closest && e.target.closest('a[href*="/article/visit.do"]');
    if (!a) return;
    if (e.button === 1) bumpOnce(a);
  }, true);

  document.addEventListener('keydown', function(e){
    if (e.key !== 'Enter') return;
    var a = e.target.closest && e.target.closest('a[href*="/article/visit.do"]');
    if (a) bumpOnce(a);
  }, true);
})();
</script>

<script>
/* 북마크 토글 (비로그인 모달 / 로컬 저장) */
(function () {
  function getUserId(){
    var uid = '${fn:escapeXml(sessionScope.userId)}';
    return (uid && uid.trim && uid.trim().length) ? uid : 'guest';
  }
  function storageKey(code){ return 'bm:' + getUserId() + ':' + String(code); }
  function applyBtnState(btn, on){
    btn.classList.toggle('on', on);
    btn.setAttribute('aria-pressed', on ? 'true' : 'false');
    var ic = btn.querySelector('.bm-icon');
    if (ic) ic.textContent = on ? '★' : '☆';
    btn.title = on ? '북마크 해제' : '북마크 추가';
  }

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

  function pickMsgId(data){
    if (!data) return null;
    return (data.messageId ?? data.msgId ?? data.code ?? data.flag ?? data.status ?? null);
  }

  document.addEventListener('click', function(e){
    var btn = e.target.closest && e.target.closest('.bm-btn');
    if(!btn) return;

    if(btn.classList.contains('guest')){
      e.preventDefault(); e.stopPropagation();
      showLoginModal();
      return;
    }

    e.preventDefault(); e.stopPropagation();
    if(btn._busy) return; btn._busy = true;

    var code = btn.getAttribute('data-article-code');
    var url = btn.getAttribute('data-toggle-url');
    if (!url) {
      var base = '${pageContext.request.contextPath}/bookmark/toggleBookmark.do';
      url = base + (code ? ('?articleCode=' + encodeURIComponent(code)) : '');
    }

    fetch(url, {
      method: 'POST',
      credentials: 'same-origin',
      headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(function(res){ if(!res.ok) throw res; return res.text(); })
    .then(function(txt){
      var data = null; try { data = JSON.parse(txt); } catch(_) {}
      var id = pickMsgId(data);

      if (id === -99){ showLoginModal(); return; }

      var nowOn  = btn.classList.contains('on');
      var nextOn = (typeof id === 'number') ? (id === 1) : !nowOn;

      applyBtnState(btn, nextOn);
      try { localStorage.setItem(storageKey(code), nextOn ? '1' : '0'); } catch(_){}

      if (data && data.message) console.log('bookmark:', data.message);
    })
    .catch(function(err){ console.error('북마크 토글 실패', err); })
    .finally(function(){ btn._busy = false; });
  }, false);

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