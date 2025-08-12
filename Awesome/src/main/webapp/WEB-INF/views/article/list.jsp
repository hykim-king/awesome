<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>뉴스 기사 목록</title>
<style>
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
						
							<div class="news-title">
							 <a href="${item.url}" class="hit-open" data-article-code="${item.articleCode}"
							     data-hit-url="${hitUrl}" target="_blank" rel="noopener noreferrer"
							      onclick="return hitAndOpen(this,event)">
							     ${item.title}
							 </a>
							</div>

							<div class="summary">${item.summary}</div>

							<div class="meta">
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
	
</body>
</html>