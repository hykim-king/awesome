<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<%-- rows 또는 list 어느 쪽이 와도 테이블 바인딩되도록 --%>
<c:set var="rows" value="${empty rows ? list : rows}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>기사 관리</title>
  <link rel="stylesheet" href="<c:url value='/resources/css/admin.css'/>">
</head>
<body>
<div class="admin-wrap"><!-- 좌측 사이드바 + 우측 컨텐츠 -->
<style>

/* Pagination look & feel (scoped) */
.pager{
  display:flex; gap:8px; justify-content:center; align-items:center; margin:18px 0 6px;
}
.pager .page{
  display:inline-flex; align-items:center; justify-content:center;
  min-width:34px; height:28px; padding:0 10px;
  border-radius:8px; background:#f5f6fb; color:#1f2937; text-decoration:none;
  box-shadow:inset 0 1px 0 rgba(0,0,0,.04); font-size:13px;
}
.pager .page.active{ background:#6d4aff; color:#fff; }
.pager .page.disabled{ opacity:.45; pointer-events:none; }



</style>
  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="title">관리자 페이지</div>
    <ul class="nav">
      <li><a href="<c:url value='/admin/dashboard.do'/>">대시보드</a></li>
      <li><a href="<c:url value='/admin/members.do'/>">회원 관리</a></li>
      <li><a class="active" href="<c:url value='/admin/articles.do'/>">기사 관리</a></li>
      <li><a href="<c:url value='/admin/report.do'/>">신고 관리</a></li>
      <li><a href="<c:url value='/member/logout.do'/>">로그아웃</a></li>
    </ul>
  </aside>

  <!-- Content -->
  <section class="content">
    <div class="panel">

      <!-- 상단: 제목 + 검색/버튼 (회원관리와 동일한 레이아웃) -->
      <div class="head">
        <h1 class="h1">기사 관리</h1>

       <form method="get" action="<c:url value='/admin/articles.do'/>">
		  <select name="searchDiv" class="select">
		    <option value="">전체</option>
		    <option value="30" ${param.searchDiv=='30' ? 'selected' : ''}>언론사</option>
		    <option value="10" ${param.searchDiv=='10' ? 'selected' : ''}>기사제목</option>
		    <%-- <option value="20" ${param.searchDiv=='20' ? 'selected' : ''}>요약</option> --%>
		  </select>

          <%-- <input class="input" type="text" name="keyword" value="${keyword}" placeholder="검색어"> --%>
            <input class="input" type="text" name="searchWord" value="${param.searchWord}"placeholder="검색어">
		  <!-- 카테고리를 검색에 쓰려면 별도의 input을 name="category"로 -->
		  <!-- <input type="number" name="category" value="${param.category}"> -->
		
  
       <%--    <select name="dateFilter" class="select">
            <option value="">기간 전체</option>
            <option value="D1" <c:if test="${dateFilter=='D1'}">selected</c:if>>오늘</option>
            <option value="W1" <c:if test="${dateFilter=='W1'}">selected</c:if>>1주</option>
            <option value="M1" <c:if test="${dateFilter=='M1'}">selected</c:if>>1개월</option>
          </select>

          <select name="size" class="select">
            <option value="10" <c:if test="${size==10}">selected</c:if>>10</option>
            <option value="20" <c:if test="${size==20}">selected</c:if>>20</option>
            <option value="50" <c:if test="${size==50}">selected</c:if>>50</option>
          </select> --%>

          <button class="btn btn-primary" type="submit">검색</button>
          <!-- <button class="btn btn-warning" type="button" id="btnEdit">수정</button> -->
          <!-- <button class="btn btn-primary btn-ghost" type="button" id="btnNew">등록</button> -->
          <button class="btn btn-danger"  type="button" id="btnDelete">삭제</button>
        </form>
      </div>

      <!-- 테이블(회원관리 표 스타일을 그대로 사용) -->
      <table class="grid">
        <thead>
          <tr>
           <th class="chk"><input type="checkbox" id="chkAll"></th>
			<th class="nowrap">기사코드</th>
			<th class="nowrap">카테고리</th>
			<th class="nowrap">언론사</th>
			<th>제목</th> <!-- 제목은 줄바꿈 허용 -->
			<th class="nowrap">게시일</th>
			<th class="nowrap">조회수</th>
			<th class="nowrap">링크</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach var="a" items="${rows}">
          <tr data-id="${a.articleCode}">
            <td class="chk"><input type="checkbox" class="rowChk" value="${a.articleCode}"></td>
            <td style="text-align:center;">${a.articleCode}</td>
            <td style="text-align:center;">${a.category}</td>
            <td style="text-align:center;">${a.press}</td>
            <td>${a.title}</td>
            <td style="text-align:center;"><fmt:formatDate value="${a.publicDt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            <td style="text-align:center;"><fmt:formatNumber value="${a.views}"/></td>
            <td style="text-align:center;" class="url">
              <c:choose>
                <c:when test="${not empty a.url}">
                  <a href="${a.url}" target="_blank" rel="noopener">열기</a>
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty rows}">
          <tr><td colspan="8" style="text-align:center; padding:24px;">데이터가 없습니다.</td></tr>
        </c:if>
        </tbody>
      </table>

   

	     <!-- 페이지네이션 -->
	   <c:set var="cur"   value="${empty page ? pageNum : page}" />
	<c:set var="lastP" value="${empty last ? totalPage : last}" />
	
	<!-- 페이징 -->
	<c:set var="block" value="5"/>
	<c:set var="cur" value="${page != null ? page : pageNum}"/>
	<c:set var="lastPage" value="${last != null ? last : totalPage}"/>
	<c:set var="start" value="${(cur-1) - ((cur-1) % block) + 1}"/>
	<c:set var="end"   value="${start + block - 1}"/>
	<c:if test="${end > lastPage}"><c:set var="end" value="${lastPage}"/></c:if>
	
	<div class="pagination">
	  <!-- 이전 블록 -->
	  <c:choose>
	    <c:when test="${start > 1}">
	      <c:url var="prevUrl" value="/admin/articles.do">
	        <c:param name="pageNum" value="${start-1}"/>
	        <c:param name="pageSize" value="${pageSize}"/>
	        <c:if test="${not empty field}"><c:param name="field" value="${field}"/></c:if>
	        <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
	      </c:url>
	      <a class="page" href="${prevUrl}">&lsaquo;</a>
	    </c:when>
	    <c:otherwise><span class="page disabled">&lsaquo;</span></c:otherwise>
	  </c:choose>
	
	  <!-- 페이지 번호 -->
	  <c:forEach var="p" begin="${start}" end="${end}">
	    <c:url var="pUrl" value="/admin/articles.do">
	      <c:param name="pageNum" value="${p}"/>
	      <c:param name="pageSize" value="${pageSize}"/>
	      <c:if test="${not empty field}"><c:param name="field" value="${field}"/></c:if>
	      <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
	    </c:url>
	    <a class="page ${p==cur ? 'active' : ''}" href="${pUrl}">${p}</a>
	  </c:forEach>
	
	 <!-- 다음 블록 -->
	  <c:choose>
	    <c:when test="${end < lastPage}">
	      <c:url var="nextUrl" value="/admin/articles.do">
	        <c:param name="pageNum" value="${end+1}"/>
	        <c:param name="pageSize" value="${pageSize}"/>
	        <c:if test="${not empty field}"><c:param name="field" value="${field}"/></c:if>
	        <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
	      </c:url>
	      <a class="page" href="${nextUrl}">&rsaquo;</a>
	    </c:when>
	    <c:otherwise><span class="page disabled">&rsaquo;</span></c:otherwise>
	  </c:choose>
	</div>

      <!-- 삭제용 숨김 폼(단건) -->
      <form id="delForm" method="post" action="<c:url value='/article/delete.do'/>">
        <input type="hidden" name="articleCode">
      </form>

    </div>
  </section>
</div>

<script>
  const $  = s => document.querySelector(s);
  const $$ = s => Array.from(document.querySelectorAll(s));

  // 전체 선택
  $('#chkAll')?.addEventListener('change', e =>
    $$('.rowChk').forEach(c => c.checked = e.target.checked));

/*   // 삭제(단건)
  $('#btnDelete')?.addEventListener('click', () => {
    const ids = $$('.rowChk').filter(c=>c.checked).map(c=>c.value);
    if (!ids.length) return alert('삭제할 기사를 선택하세요.');
    if (ids.length > 1) return alert('삭제는 1건만 가능합니다.');
    if (!confirm('선택한 기사를 삭제하시겠습니까?')) return;
    const f = $('#delForm');
    f.articleCode.value = ids[0];
    f.submit();
  }); */

  // 선택 삭제
  $('#btnDelete')?.addEventListener('click', () => {
    const ids = $$('.rowChk').filter(c=>c.checked).map(c=>c.value);
    if (!ids.length) return alert('삭제할 기사를 선택하세요.');
    if (!confirm(ids.length + '건 삭제하시겠습니까?')) return;
    const f = $('#delForm'); f.innerHTML='';
    ids.forEach(id => { const i=document.createElement('input'); i.type='hidden'; i.name='ids'; i.value=id; f.appendChild(i); });
    f.submit();
  });
  
 /*  // 등록/수정은 라우팅만(필요 시 URL 연결)
  $('#btnNew')?.addEventListener('click', () => {
    alert('등록 화면은 별도 구현 대상입니다.');
  });
  $('#btnEdit')?.addEventListener('click', () => {
    const ids = $$('.rowChk').filter(c=>c.checked).map(c=>c.value);
    if (ids.length !== 1) return alert('수정은 1건만 선택하세요.');
    alert('수정 화면 라우팅이 필요합니다. (선택 코드: ' + ids[0] + ')');
  }); */
</script>
</body>
</html>
