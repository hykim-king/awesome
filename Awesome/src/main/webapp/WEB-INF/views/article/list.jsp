<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>뉴스 기사 목록</title>
<style>
:root {
  --blue:#0d47a1; --blue-weak:#e7efff;
  --text:#111827; --muted:#6b7280; --border:#e5e7eb; --card:#ffffff; --bg:#f8fafc;
}
*{box-sizing:border-box}
body{background:var(--bg); color:var(--text); font-family:system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif}

/* ----- Layout: 메인/사이드 ----- */
.layout{display:grid;grid-template-columns:1fr 280px;gap:16px;max-width:1100px;margin:16px auto;padding:0 16px;}
.main{min-width:0}
.aside{position:sticky; top:16px; align-self:start; border:1px solid var(--border); background:var(--card); border-radius:12px; padding:12px}

/* ----- 카테고리 탭 (파란 바) ----- */
.nav{background:var(--blue); border-radius:10px; padding:8px; display:flex; flex-wrap:wrap; gap:6px; margin-bottom:14px}
.nav a{
  color:#cfe3ff; text-decoration:none; padding:8px 12px; border-radius:8px; transition:.15s;
}
.nav a:hover{background:rgba(255,255,255,.12); color:#fff}
.nav a.active{background:#fff; color:var(--blue); font-weight:700}

/* ----- 검색 바 ----- */
.search-box{
  display:grid; grid-template-columns:120px 1fr 160px auto; gap:8px;
  padding:10px; border:1px solid var(--border); border-radius:12px; background:var(--card); margin-bottom:12px;
}
.search-box select, .search-box input[type="text"], .search-box input[type="date"]{
  height:38px; border:1px solid var(--border); border-radius:8px; padding:0 10px; background:#fff
}
.search-box button{
  height:38px; border:none; border-radius:10px; background:var(--blue); color:#fff; font-weight:600; cursor:pointer
}
.search-box button:hover{opacity:.92}
@media (max-width:900px){
  .layout{grid-template-columns:1fr}
  .aside{position:static; order:-1}
  .search-box{grid-template-columns:1fr 1fr; grid-auto-rows:minmax(38px,auto)}
  .search-box button{grid-column:1/-1}
}

/* ----- 뉴스 리스트 (행 카드 스타일) ----- */
.news-list{display:flex; flex-direction:column; gap:10px}
.news-item{
  display:grid; grid-template-columns: 1fr auto; gap:6px 12px;
  background:var(--card); border:1px solid var(--border); border-radius:12px; padding:12px;
  transition:box-shadow .12s, transform .12s, border-color .12s;
}
.news-item:hover{transform:translateY(-1px); box-shadow:0 6px 16px rgba(0,0,0,.06); border-color:#d9dee5}

/* 제목/요약/메타 */
.news-title{grid-column:1/-1; line-height:1.35}
.news-title a{color:var(--blue); text-decoration:none; font-weight:700; font-size:18px; word-break:break-word}
.news-title a:hover{text-decoration:underline}
.summary{
  color:#374151; margin:2px 0 4px;
  display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden;
}
.meta{color:var(--muted); font-size:13px; display:flex; gap:10px; align-items:center}

/* ----- 조회수 뱃지(오른쪽) ----- */
.news-item .meta + * {display:none} /* 기존 그리드 정리용(없으면 무시) */
.meta .views-badge{
  background:var(--blue-weak); color:var(--blue); border-radius:999px; padding:2px 8px; font-weight:700; font-size:12px
}

/* ----- 페이징 ----- */
.paging{display:flex; justify-content:center; gap:8px; margin:16px 0 24px}
.paging a, .paging span{
  min-width:36px; height:36px; display:inline-flex; align-items:center; justify-content:center;
  background:#fff; border:1px solid var(--border); border-radius:10px; text-decoration:none; color:var(--text)
}
.paging a:hover{border-color:var(--blue); color:var(--blue)}
.paging .activePage{background:var(--blue); border-color:var(--blue); color:#fff}
.paging .disabled{color:#9ca3af; background:#f3f4f6}

/* ----- 랭킹(사이드) ----- */
.rank-title{font-weight:800; margin:4px 0 8px}
.rank-list{list-style:none; margin:0; padding:0; display:flex; flex-direction:column; gap:8px}
.rank-list li{display:flex; align-items:center; gap:10px}
.rank-num{
  width:22px; height:22px; border-radius:6px; background:var(--blue); color:#fff;
  display:inline-flex; align-items:center; justify-content:center; font-size:12px; font-weight:700;
}
.rank-link{color:#111827; text-decoration:none}
.rank-link:hover{color:var(--blue); text-decoration:underline}

.hidden{ display:none !important; }
.login-modal{position:fixed; inset:0; z-index:1000;}
.login-modal_backdrop{position:absolute; inset:0; background:rgba(0,0,0,.4);}
.login-modal_card{
  position:absolute; left:50%; top:50%; transform:translate(-50%,-50%);
  width:min(420px,90vw); background:#fff; border-radius:12px; padding:20px;
  box-shadow:0 10px 30px rgba(0,0,0,.2);
}
</style>
<script>
	//새로 고침 시 검색 조건 초기화
	if (performance
			&& performance.navigation
			&& performance.navigation.type === performance.navigation.TYPE_RELOAD) {
		location.replace("${pageContext.request.contextPath}/article/list.do");
	}
	if (performance && performance.getEntriesByType) {
		var nav = performance.getEntriesByType("navigation")[0];
		if (nav && nav.type === "reload") {
			location
					.replace("${pageContext.request.contextPath}/article/list.do")
		}
	}
</script>
</head>
<body>
	<div class="container">
		<!-- 카테고리 네비 -->
		<div class="nav">
			<c:url var="allUrl" value="/article/list.do" />
			<a href="${allUrl}" class="${empty category ? 'active' : ''}">전체</a>

			<c:url var="cate10" value="/article/list.do">
				<c:param name="category" value="10" />
			</c:url>
			<a href="${cate10}" class="${category == 10 ? 'active' : ''}">정치</a>

			<c:url var="cate20" value="/article/list.do">
				<c:param name="category" value="20" />
			</c:url>
			<a href="${cate20}" class="${category == 20 ? 'active' : ''}">경제</a>

			<c:url var="cate30" value="/article/list.do">
				<c:param name="category" value="30" />
			</c:url>
			<a href="${cate30}" class="${category == 30 ? 'active' : ''}">사회</a>

			<c:url var="cate40" value="/article/list.do">
				<c:param name="category" value="40" />
			</c:url>
			<a href="${cate40}" class="${category == 40 ? 'active' : ''}">스포츠</a>

			<c:url var="cate50" value="/article/list.do">
				<c:param name="category" value="50" />
			</c:url>
			<a href="${cate50}" class="${category == 50 ? 'active' : ''}">연예</a>

			<c:url var="cate60" value="/article/list.do">
				<c:param name="category" value="60" />
			</c:url>
			<a href="${cate60}" class="${category == 60 ? 'active' : ''}">IT/과학</a>
		</div>

		<!-- 검색 폼 -->
		<c:url var="searchAction" value="/article/list.do" />
		<form method="get" action="${searchAction}" class="search-box">
			<input type="hidden" name="category" value="${category}" /> <input
				type="hidden" name="pageNum" value="1" /> <input type="hidden"
				name="pageSize" value="${pageSize}" /> <select name="searchDiv">
				<option value="">검색구분</option>
				<option value="10" ${searchDiv == '10' ? 'selected' : ''}>제목</option>
				<option value="20" ${searchDiv == '20' ? 'selected' : ''}>내용</option>
				<option value="30" ${searchDiv == '30' ? 'selected' : ''}>언론사</option>
			</select> <input type="text" name="searchWord" value="${searchWord}"
				placeholder="검색어를 입력하세요" />

			<!-- 날짜 선택 (발행일 선택 용도) -->
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
						
						<c:url var="visitUrl" value="/article/visit.do">
						  <c:param name="articleCode" value="${item.articleCode}"/>
						</c:url>
						
						<c:url var="hitUrl" value="/article/hit.do">
						  <c:param name="articleCode" value="${item.articleCode}"></c:param>
						</c:url>
						
						<c:url var="bmToggleUrl" value="/bookmark/toggleBookmark.do">
						  <c:param name="articleCode" value="${item.articleCode}"></c:param>
						</c:url>
						
							<div class="news-title">
							 <a href="${item.url}" class="hit-open" data-article-code="${item.articleCode}"
							     data-hit-url="${hitUrl}" target="_blank" rel="noopener noreferrer"
							      onclick="return hitAndOpen(this,event)">
							     ${item.title}
							 </a>
							</div>
                            <!-- 요약 80자 넘을시 ... 표시 -->
							<div class="summary">
							 <c:choose>
							     <c:when test="${not empty item.summary and fn:length(item.summary) > 60}">
							         ${fn:substring(item.summary,0,60)}...
							     </c:when>
							     <c:otherwise>
							         ${item.summary}
							     </c:otherwise>
							 </c:choose>
							</div>

							<div class="meta">
							<!--북마크 -->
							<c:choose>
							 <c:when test="${not empty sessionScope.userId}">
							     <button type="button" class="bm-btn ${item.bookmarked ? 'on' : ''}"
							      data-toggle-url="${bmToggleUrl}" data-article-code="${item.articleCode}"
							      aria-pressed="${item.bookmarked ? 'true':'false'}"
							      title="${item.bookmarked ? '북마크 해제' : '북마크 추가'}">
							         <span class="bm-icon">${item.bookmarked? '★' : '☆'}</span>
							     </button>
							 </c:when>
							 <c:otherwise>
							     <button type="button" class="bm-btn guest" title="로그인이 필요합니다.">
							         <span class="bm-icon">☆</span>
							     </button>
							 </c:otherwise>
							</c:choose>
								${item.press} |
								<fmt:formatDate value="${item.publicDt}" pattern="yyyy-MM-dd" />
								| 조회수: <span id="views-${item.articleCode}">${item.views}</span>
							</div>
						</div>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<div class="no-data">
						<c:choose>
							<c:when test="${not empty searchWord or not empty dateFilter}">
                                검색한 값이 없습니다.
                            </c:when>
							<c:otherwise>
                                등록된 기사가 없습니다.
                            </c:otherwise>
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
	</div>
	
	<!-- 로그인 안내 -->
	<div id="login-modal" class="login-modal hidden" aria-hidden="true" role="dialog" aria-modal="true">
	   <div class="login-modal_backdrop"></div>
	   <div class="login-modal_card">
	       <div class="login-modal_title">로그인이 필요합니다.</div>
	       <div class="login-modal_body">북마크 기능은 로그인 후 이용할 수 있습니다.</div>
	       <div class="login-modal_actions">
	           <button type="button" class="close-btn" data-action="close">확인</button>
	       </div>
	   </div>
	</div>
	
	<script>
	(function(){
		  // 클릭 시 조회수만 +1, 링크 열기는 브라우저 기본 동작(새 탭)으로 처리
		  window.hitAndOpen = function(a, ev){
		    // 기본 동작/전파 막지 않음 → 새 탭 즉시 기사로 열림
		    // ev && ev.preventDefault();  // ← 삭제
		    // stopPropagation류도 불필요

		    // (가벼운 중복 클릭 방지)
		    if (a.__hitting) return true;
		    a.__hitting = true;
		    setTimeout(function(){ a.__hitting = false; }, 300);

		    var code = a.getAttribute('data-article-code');
		    var hitUrl = a.getAttribute('data-hit-url');

		    fetch(hitUrl, {
		      method: 'POST'
		      // credentials: 'same-origin', // 세션/쿠키 쓰면 주석 해제
		      // headers: { 'X-CSRF-TOKEN': '...' } // CSRF 쓰면 추가
		    })
		    .then(function(res){ if(!res.ok) throw res; return res.json().catch(function(){ return null; }); })
		    .then(function(data){
		      if (data && typeof data.views === 'number') {
		        var span = document.getElementById('views-' + code);
		        if (span) span.textContent = String(data.views);
		      }
		    })
		    .catch(function(err){ console.error('조회수 증가 실패', err); });

		    return true; // ★ 기본 동작 허용 → target="_blank"로 새 탭 즉시 이동
		  };
		})();
	    </script>
	    
	    <script>
	    (function(){
	    	function pickMsgId(data){
	    		if(data == null){
	    			return null;
	    		}
	    		if('msgId' in data){
	    			return data.msgId;
	    		}
	    		if('code' in data){
	    			return data.code;
	    		}
	    		if('flag' in data){
	    			return data.flag;
	    		}
	    		if('status' in data){
	    			return data.status;
	    		}
	    		return null;
	    	}
	    	
	    	document.addEventListener('click', function(e){
	    	      var btn = e.target.closest && e.target.closest('.bm-btn');
	    	      if(!btn || btn.classList.contains('guest')) return; /* ★ FIX: closest 오타 수정 */

	    	      e.preventDefault();
	    	      e.stopPropagation();
	    	      if(btn._busy) return; /* ★ FIX: 변수명 btn */
	    	      btn._busy = true;

	    	      var url = btn.getAttribute('data-toggle-url');

	    	      fetch(url, {method:'POST'})
	    	        .then(function(res){
	    	          if(!res.ok) throw res; /* ★ FIX: throw (not throws) */
	    	          return res.text();
	    	        })
	    	        .then(function(txt){
	    	          var data = null;
	    	          try { data = JSON.parse(txt); } catch(_){}
	    	          var id = pickMsgId(data);

	    	          if(id === -99){ // 세션 만료/비로그인 응답
	    	            var modal = document.getElementById('login-modal'); /* ★ FIX: getElementById */
	    	            if(modal){
	    	              modal.classList.remove('hidden');       /* ★ FIX: show */
	    	              modal.setAttribute('aria-hidden','false');
	    	            }
	    	            return;
	    	          }

	    	          // flag==1 추가, 나머지 삭제
	    	          var on = (id === 1);
	    	          btn.classList.toggle('on', on);
	    	          btn.setAttribute('aria-pressed', on ? 'true' : 'false'); /* ★ FIX: true/false */
	    	          var ic = btn.querySelector('.bm-icon');
	    	          if (ic) ic.textContent = on ? '★' : '☆'; /* ★ FIX: textContent */
	    	          btn.title = on ? '북마크 해제' : '북마크 추가';
	    	        })
	    	        .catch(function(err){ console.error('북마크 토글 실패', err); })
	    	        .then(function(){ btn._busy = false; });
	    	    }, false);

	    	    // ★ NEW: 비로그인 버튼 → 모달만 띄움
	    	    document.addEventListener('click', function(e){
	    	      var btn = e.target.closest && e.target.closest('.bm-btn.guest'); /* ★ FIX: closest */
	    	      if(!btn) return;

	    	      e.preventDefault();
	    	      e.stopPropagation();

	    	      var modal = document.getElementById('login-modal');
	    	      if(!modal){
	    	        alert('로그인이 필요합니다.');
	    	        return;
	    	      }
	    	      modal.classList.remove('hidden');               /* ★ FIX: show */
	    	      modal.setAttribute('aria-hidden','false');

	    	      var close = function(){
	    	        modal.classList.add('hidden');                /* ★ FIX: hide */
	    	        modal.setAttribute('aria-hidden','true');
	    	      };
	    	      var closeBtn = modal.querySelector('[data-action="close"]');
	    	      var backdrop = modal.querySelector('.login-modal_backdrop'); /* ★ FIX: 클래스명 */

	    	      if (closeBtn) closeBtn.onclick = close;
	    	      if (backdrop) backdrop.onclick = close;
	    	    }, false);
	    	  })();
	    </script>
	
</body>
</html>