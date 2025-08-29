<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<c:set var="CP" value="${pageContext.request.contextPath}" />

<c:set var="rows" value="${empty rows ? list : rows}" />
<c:set var="page" value="${empty page ? pageNum : page}" />
<c:set var="last" value="${empty last ? totalPage : last}" />
<c:set var="size" value="${empty size ? pageSize : size}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>신고 관리</title>
  <link rel="stylesheet" href="<c:url value='/resources/css/admin.css'/>" />
  <style>
    /* 공통 */
    .grid th, .grid td { padding:12px 16px; vertical-align: middle; }
    .grid thead th { text-align:center; }
    .grid tbody td { text-align:left; }
    .grid td.chk,
    .grid td:nth-child(1),
    .grid td:nth-child(6),
    .grid td:nth-child(7),
    .grid td:nth-child(8) { text-align:center; }
    .gradeSel{ min-width:70px; text-align-last:center; -moz-text-align-last:center; }
  </style>
</head>

<body>
<div class="admin-wrap">
  <!-- 좌측 사이드바 -->
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

  <!-- 본문 -->
  <section class="content">
    <div class="panel">

      <!-- 상단: 제목 + 검색/버튼 -->
      <div class="head">
        <h1 class="h1">신고 관리</h1>
        <div class="controls">
          <form method="get" action="<c:url value='/admin/report.do'/>" class="actions">
            <select name="field" class="select">
              <option value="reporterId" ${field == 'reporterId' ? 'selected' : ''}>신고자ID</option>
              <option value="targetId"   ${field == 'targetId'   ? 'selected' : ''}>신고대상ID</option>
            </select>
            <input class="input" type="text" name="keyword" value="${keyword}" placeholder="검색어">
            <button type="submit" class="btn btn-primary">검색</button>
            <button class="btn btn-warning" type="button" id="btnUpdate">수정</button>
            <button class="btn btn-danger"  type="button" id="btnDelete">삭제</button>
          </form>
        </div>
      </div>

      <!-- 테이블 -->
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
            <td><c:out value="${r.reasonLabel}"/></td>
            <td style="text-align:center;">${r.ctId}</td>
            <td class="date"><fmt:formatDate value="${r.regDt}" pattern="yyyy-MM-dd HH:mm"/></td>
            <td style="text-align:center;">
              <!-- name 제거(혼동 방지). 값은 JS로만 전송 -->
              <select class="statusSel">
                <option value="RECEIVED" ${r.status=='RECEIVED' ? 'selected' : ''}>검토중</option>
                <option value="RESOLVED" ${r.status=='RESOLVED' ? 'selected' : ''}>조치완료</option>
              </select>
            </td>
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

      <div class="pagination">
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

      <!-- 배치 상태 변경용 폼 -->
      <form id="statusForm" method="post" action="<c:url value='/admin/reports/batchUpdate.do'/>">
		  <!-- page/size/CSRF hidden들 -->
		<input type="hidden" name="page" value="${page}"/>
        <input type="hidden" name="size" value="${size}"/>
        <c:if test="${not empty _csrf}">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </c:if>
      </form>

      <!-- 삭제용 폼 -->
      <form id="delForm" method="post" action="<c:url value='/admin/report/delete.do'/>">
        <input type="hidden" name="page" value="${page}"/>
        <input type="hidden" name="size" value="${size}"/>
        <c:if test="${not empty _csrf}">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </c:if>
      </form>

    </div>
  </section>
</div>

<script>
  const $  = s => document.querySelector(s);
  const $$ = s => Array.from(document.querySelectorAll(s));
  const CP = '${pageContext.request.contextPath}';

  // 전체 선택
  $('#chkAll')?.addEventListener('change', e =>
    $$('.rowChk').forEach(c => c.checked = e.target.checked)
  );

  // 다건 상태 수정 (핵심: updates[0].reportCode / updates[0].status 형태로만 전송)
 $('#btnUpdate')?.addEventListener('click', () => {
  const rows = $$('.rowChk:checked').map(c => c.closest('tr'));
  if (rows.length === 0) { alert('수정할 항목을 선택하세요.'); return; }

  const f = document.getElementById('statusForm');

  // 기존 updates.* 히든 제거
  Array.from(f.querySelectorAll('input[name^="updates"]')).forEach(el => el.remove());

  // 새 히든 구성
  rows.forEach((tr, i) => {
    const rc = tr.dataset.id;
    const st = tr.querySelector('.statusSel').value;

    const h1 = document.createElement('input');
    h1.type = 'hidden';
    h1.name = `updates[${i}].reportCode`;
    h1.value = rc;
    f.appendChild(h1);

    const h2 = document.createElement('input');
    h2.type = 'hidden';
    h2.name = `updates[${i}].status`;
    h2.value = st;
    f.appendChild(h2);
  });

  // 디버그(원하면 주석 해제)
  // console.log('POST →', f.action);
  // const fd = new FormData(f); for (const [k,v] of fd.entries()) console.log(k, v);

  f.submit();
});


  // 선택 삭제
  $('#btnDelete')?.addEventListener('click', () => {
    const ids = $$('.rowChk').filter(c => c.checked).map(c => c.value);
    if (!ids.length) return alert('삭제할 신고를 선택하세요.');
    if (!confirm(ids.length + '건 삭제하시겠습니까?')) return;

    const f = $('#delForm');
    // 이전 동적 hidden 제거
    Array.from(f.querySelectorAll('input[name="ids"]')).forEach(el => el.remove());

    ids.forEach(id => {
      const i = document.createElement('input');
      i.type = 'hidden'; i.name = 'ids'; i.value = id;
      f.appendChild(i);
    });

    f.submit();
  });

  
  
  document.addEventListener('DOMContentLoaded', function () {
    var $  = function (s) { return document.querySelector(s); };
    var $$ = function (s) { return Array.prototype.slice.call(document.querySelectorAll(s)); };

    // 전체 선택
    var chkAll = document.getElementById('chkAll');
    if (chkAll) {
      chkAll.addEventListener('change', function (e) {
        $$('.rowChk').forEach(function (c) { c.checked = e.target.checked; });
      });
    }

    // ───────────── 다건 상태 수정 ─────────────
    var btnUpdate = document.getElementById('btnUpdate');
    if (btnUpdate) {
      btnUpdate.addEventListener('click', function (e) {
        e.preventDefault();
        e.stopPropagation();

        var rows = $$('.rowChk').filter(function (c) { return c.checked; })
                                .map(function (c) { return c.closest('tr'); });
        if (rows.length === 0) { alert('수정할 항목을 선택하세요.'); return; }

        var f = document.getElementById('statusForm');
        if (!f) { alert('statusForm을 찾을 수 없습니다.'); return; }

        // 기존 updates.* hidden 제거
        Array.prototype.slice.call(f.querySelectorAll('input[name^="updates"]'))
          .forEach(function (el) { el.parentNode.removeChild(el); });

        // 선택행으로 hidden 재구성
        rows.forEach(function (tr, i) {
          var rc = tr.getAttribute('data-id');
          var st = tr.querySelector('.statusSel').value;

          var h1 = document.createElement('input');
          h1.type  = 'hidden';
          h1.name  = 'updates[' + i + '].reportCode';
          h1.value = rc;
          f.appendChild(h1);

          var h2 = document.createElement('input');
          h2.type  = 'hidden';
          h2.name  = 'updates[' + i + '].status';
          h2.value = st;
          f.appendChild(h2);
        });

        // 디버그용(원하면 살려서 확인)
        // console.log('[POST]', f.action);
        // var fd = new FormData(f); fd.forEach((v,k)=>console.log(k,v));

        f.submit();
      });
    }

    // ───────────── 선택 삭제 ─────────────
    var btnDelete = document.getElementById('btnDelete');
    if (btnDelete) {
      btnDelete.addEventListener('click', function (e) {
        e.preventDefault();
        e.stopPropagation();

        var ids = $$('.rowChk').filter(function (c) { return c.checked; })
                               .map(function (c) { return c.value; });
        if (!ids.length) { alert('삭제할 신고를 선택하세요.'); return; }
        if (!confirm(ids.length + '건 삭제하시겠습니까?')) return;

        var f = document.getElementById('delForm');
        Array.prototype.slice.call(f.querySelectorAll('input[name="ids"]'))
          .forEach(function (el) { el.parentNode.removeChild(el); });

        ids.forEach(function (id) {
          var i = document.createElement('input');
          i.type = 'hidden';
          i.name = 'ids';
          i.value = id;
          f.appendChild(i);
        });

        f.submit();
      });
    }
  });
 

  </script>
</body>
</html>
