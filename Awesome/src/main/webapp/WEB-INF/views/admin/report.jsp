<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<%-- 프로젝트 contextPath를 CP 변수로 세팅 --%>
<c:set var="CP" value="${pageContext.request.contextPath}" />

<%-- 리스트/페이지 변수 호환 처리 --%>
<c:set var="rows"   value="${empty rows ? list : rows}" />
<c:set var="page"   value="${empty page ? pageNum : page}" />
<c:set var="last"   value="${empty last ? totalPage : last}" />
<c:set var="size"   value="${empty size ? pageSize : size}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>신고 관리</title>
  <link rel="stylesheet" href="<c:url value='/resources/css/admin.css'/>" />
  <style>
    .actions{ display:flex; gap:8px; align-items:center; }
    .select,.input{ height:36px; border:1px solid #e5e7eb; border-radius:8px; padding:0 10px; background:#fff; }
    .input{ width:260px; }
    .btn{ height:36px; padding:0 14px; border:0; border-radius:10px; cursor:pointer; font-weight:700; }
    .btn-primary{ background:#4aa3ff; color:#fff; }
    .btn-primary:hover{ background:#0a45ff; }
    .btn-warning{ background:#ffe08a; }
    .btn-danger{ background:#ff6b6b; color:#fff; }

    .head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; }
    .head .controls{ margin-left:auto; display:flex; align-items:center; gap:10px; }

    .grid { width:100%; border-collapse:collapse; }
    .grid th, .grid td { padding:12px 14px; vertical-align:middle; }
    .grid thead th { text-align:center; }
    .grid td { text-align:left; }
    .grid td.chk, .grid td.date, .grid td.center { text-align:center; }

    .pager{ display:flex; gap:8px; justify-content:center; align-items:center; margin:18px 0 6px; }
    .pager .page{ display:inline-flex; align-items:center; justify-content:center; width:34px; height:28px; border-radius:8px; background:#f5f6fb; color:#1f2937; text-decoration:none; box-shadow:inset 0 1px 0 rgba(0,0,0,.04); font-size:13px; }
    .pager .page.active{ background:#6d4aff; color:#fff; }
    .pager .page.disabled{ opacity:.45; pointer-events:none; }
  </style>
</head>
<body>
<div class="admin-wrap">
  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="title">관리자 페이지</div>
    <ul class="nav">
      <li><a href="<c:url value='/admin/dashboard.do'/>">대시보드</a></li>
      <li><a href="<c:url value='/admin/members.do'/>">회원 관리</a></li>
      <li><a href="<c:url value='/admin/articles.do'/>">기사 관리</a></li>
      <li><a class="active" href="<c:url value='/admin/report.do'/>">신고 관리</a></li>
      <li><a href="<c:url value='/member/logout.do'/>">로그아웃</a></li>
    </ul>
  </aside>

  <!-- Content -->
  <section class="content">
    <div class="panel">
      <div class="head">
        <h1 class="h1">신고 관리</h1>

        <div class="controls">
          <form method="get" action="<c:url value='/admin/report.do'/>" class="actions">

            <select name="field" class="select">
              <option value=""           ${empty field ? 'selected' : ''}>전체</option>
              <option value="reporterId" ${field == 'reporterId' ? 'selected' : ''}>신고자ID</option>
              <option value="targetId"   ${field == 'targetId'   ? 'selected' : ''}>대상ID</option>
            </select>
            <input type="text" name="keyword" value="${keyword}" placeholder="검색어" class="input"/>
            <button type="submit" class="btn btn-primary">검색</button>
          </form>

          <button class="btn btn-warning" type="button" id="btnUpdate">수정</button>
          <button class="btn btn-danger"  type="button" id="btnDelete">삭제</button>
        </div>
      </div>

      <!-- 표 -->
      <table class="grid">
        <thead>
          <tr>
            <th class="chk"><input type="checkbox" id="chkAll"></th>
            <th>신고 코드</th>
            <th>신고 내용</th>
            <th>신고자 ID</th>
            <th>신고 사유</th>
            <th>신고대상 ID</th>
            <th>신고일</th>
            <th>조치상태</th>
            <th>조치날짜</th>
          </tr>
        </thead>
        <tbody>
  <c:forEach var="r" items="${rows}">
    <tr data-id="${r.reportCode}">
      <td class="chk"><input type="checkbox" class="rowChk" value="${r.reportCode}"></td>

      <td class="center">${r.reportCode}</td>
      <td>${chatContent[r.reportCode]}</td>
      <td style="text-align:center;">${r.userId}</td>
      <td>${r.reason}</td>
      <td style="text-align:center;">${r.ctId}</td>
      <td class="date"><fmt:formatDate value="${r.regDt}" pattern="yyyy-MM-dd HH:mm"/></td>

      <!-- 조치상태 -->
      <td style="text-align:center;">
      <form id="statusForm" method="post" action="<c:url value='/admin/report/status.do'/>">
		  <input type="hidden" name="reportCode">
		  <input type="hidden" name="status">
		  <input type="hidden" name="page" value="${page}">
		  <input type="hidden" name="size" value="${size}">
		</form>
          
         <select name="status" class="statusSel">
		  <option value="RECEIVED" ${r.status=='RECEIVED' ? 'selected' : ''}>검토중</option>
		  <option value="RESOLVED" ${r.status=='RESOLVED' ? 'selected' : ''}>조치완료</option>
		</select>
		</td>
		
		<!-- 조치날짜 -->
		<td class="date" style="text-align:center;">
		  <c:choose>
		    <c:when test="${r.status eq 'RESOLVED'}">
		      <fmt:formatDate value="${r.modDt}" pattern="yyyy-MM-dd HH:mm"/>
		    </c:when>
		    <c:otherwise>-</c:otherwise>
		  </c:choose>
		</td>
   
    </tr>
  </c:forEach>

  <c:if test="${empty rows}">
    <tr><td colspan="9" style="text-align:center; padding:24px;">데이터가 없습니다.</td></tr>
  </c:if>
</tbody>
</table>


      <!-- 페이징 -->
      <c:set var="block" value="4"/>
      <c:set var="start" value="${(page-1) - ((page-1) % block) + 1}"/>
      <c:set var="end"   value="${start + block - 1}"/>
      <c:if test="${end > last}"><c:set var="end" value="${last}"/></c:if>

      <div class="pager">
        <c:choose>
          <c:when test="${start > 1}">
            <c:url var="prevUrl" value="/admin/report.do">
              <c:param name="page" value="${start-1}"/>
              <c:param name="size" value="${size}"/>
              <c:if test="${not empty field}"><c:param name="field" value="${field}"/></c:if>
              <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
            </c:url>
            <a class="page" href="${prevUrl}">&lsaquo;</a>
          </c:when>
          <c:otherwise><span class="page disabled">&lsaquo;</span></c:otherwise>
        </c:choose>

        <c:forEach var="p" begin="${start}" end="${end}">
          <c:url var="pUrl" value="/admin/report.do">
            <c:param name="page" value="${p}"/>
            <c:param name="size" value="${size}"/>
            <c:if test="${not empty field}"><c:param name="field" value="${field}"/></c:if>
            <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
          </c:url>
          <a class="page ${p==page ? 'active' : ''}" href="${pUrl}">${p}</a>
        </c:forEach>

        <c:choose>
          <c:when test="${end < last}">
            <c:url var="nextUrl" value="/admin/report.do">
              <c:param name="page" value="${end+1}"/>
              <c:param name="size" value="${size}"/>
              <c:if test="${not empty field}"><c:param name="field" value="${field}"/></c:if>
              <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
            </c:url>
            <a class="page" href="${nextUrl}">&rsaquo;</a>
          </c:when>
          <c:otherwise><span class="page disabled">&rsaquo;</span></c:otherwise>
        </c:choose>
      </div>

      <!-- 액션 폼 -->
     <form id="statusForm" method="post" action="<c:url value='/admin/report/status.do'/>">
		  
		  <input type="hidden" name="status">
		
		</form>

	
      <form id="delForm" method="post" action="<c:url value='/admin/report/delete.do'/>"></form>

    </div>
  </section>
</div>

<script>
  const $  = s => document.querySelector(s);
  const $$ = s => Array.from(document.querySelectorAll(s));

  // 전체 선택
  $('#chkAll')?.addEventListener('change', e =>
    $$('.rowChk').forEach(c => c.checked = e.target.checked));

  // 상태 수정(1건)
  $('#btnUpdate')?.addEventListener('click', () => {
    const checked = $$('.rowChk').filter(c => c.checked);
    if (checked.length !== 1) { alert('수정은 1건만 선택하세요.'); return; }
    const tr = checked[0].closest('tr');
    const status = tr.querySelector('.statusSel').value;
    const f = $('#statusForm');
    f.reportCode.value = tr.dataset.id;
    f.status.value = status;
    f.submit();
  });

  // 선택 삭제(여러 건)
  $('#btnDelete')?.addEventListener('click', () => {
    const ids = $$('.rowChk').filter(c => c.checked).map(c => c.value);
    if (!ids.length) return alert('삭제할 신고를 선택하세요.');
    if (!confirm(ids.length + '건 삭제하시겠습니까?')) return;
    const f = $('#delForm'); f.innerHTML = '';
    ids.forEach(id => {
      const i = document.createElement('input');
      i.type = 'hidden'; i.name = 'ids'; i.value = id;
      f.appendChild(i);
    });
    f.submit();
  });
</script>
</body>
</html>
