<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>기사 관리</title>
  <link rel="stylesheet" href="<c:url value='/resources/css/admin.css'/>">
</head>

<style>

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













   
<body>
<div class="admin-wrap"><!-- 좌측 사이드바 + 우측 컨텐츠 -->

  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="title">관리자 페이지</div>
    <ul class="nav">
      <li><a href="<c:url value='/admin/dashboard.do'/>">대시보드</a></li>
      <li><a class="active" href="<c:url value='/admin/members.do'/>">회원 관리</a></li>
      <li><a href="<c:url value='/admin/articles.do'/>">기사 관리</a></li>
      <li><a href="<c:url value='/admin/report.do'/>">신고 관리</a></li>
      <li><a href="<c:url value='/member/logout.do'/>">로그아웃</a></li>
    </ul>
  </aside>

  <!-- Content -->
  <section class="content">
    <div class="panel">

      <!-- 상단: 제목 + 검색/버튼 -->
      <div class="head">
        <h1 class="h1">회원 관리</h1>
        <form method="get" action="<c:url value='/admin/members.do'/>" class="actions">
          <select name="type" class="select">
            <option value="id"   <c:if test="${type=='id'}">selected</c:if>>아이디</option>
            <option value="nick" <c:if test="${type=='nick'}">selected</c:if>>닉네임</option>
          </select>
          <input class="input" type="text" name="keyword" value="${keyword}" placeholder="검색어">
          <select name="grade" class="select">
            <option value="">등급 전체</option>
            <option value="0" <c:if test="${grade==0}">selected</c:if>>관리자</option>
            <option value="1" <c:if test="${grade==1}">selected</c:if>>사용자</option>
          </select>
          <button class="btn btn-primary" type="submit">검색</button>
          <button class="btn btn-warning" type="button" id="btnUpdate">수정</button>
          <button class="btn btn-danger"  type="button" id="btnDelete">삭제</button>
        </form>
      </div>

      <!-- 테이블 -->
      <table class="grid">
        <thead>
          <tr>
            <th class="chk"><input type="checkbox" id="chkAll"></th>
            <th>ID</th><th>이름</th><th>닉네임</th><th>이메일</th>
            <th class="grade">등급</th><th>가입일</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach var="m" items="${rows}">
          <tr data-id="${m.userId}">
            <td class="chk"><input type="checkbox" class="rowChk" value="${m.userId}"></td>
            <td style="text-align:center;">${m.userId}</td>
            <td style="text-align:center;">${m.userNm}</td>
            <td style="text-align:center;">${m.nickNm}</td>
            <td style="text-align:center;">${m.mailAddr}</td>
            <td>
              <select class="select gradeSel">
                <option value="0" <c:if test="${m.userGradeCd==0}">selected</c:if>>관리자</option>
                <option value="1" <c:if test="${m.userGradeCd==1}">selected</c:if>>회원</option>
              </select>
            </td>
            
            <td><fmt:formatDate value="${m.regDt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
          </tr>
        </c:forEach>
        <c:if test="${empty rows}">
          <tr><td colspan="8" style="text-align:center; padding:24px;">데이터가 없습니다.</td></tr>
        </c:if>
        </tbody>
      </table>

      <!-- 페이지네이션 -->
      <div class="pagination">
        <c:forEach var="p" begin="1" end="${last}">
          <c:url var="pUrl" value="/admin/members.do">
            <c:param name="page" value="${p}"/>
            <c:param name="size" value="${size}"/>
            <c:if test="${not empty type}">
              <c:param name="type" value="${type}"/>
            </c:if>
            <c:if test="${not empty keyword}">
              <c:param name="keyword" value="${keyword}"/>
            </c:if>
            <c:if test="${grade ne null}">
              <c:param name="grade" value="${grade}"/>
            </c:if>
          </c:url>
          <a class="page ${p==page ? 'active' : ''}" href="${pUrl}">${p}</a>
        </c:forEach>
      </div>

      <!-- 수정/삭제용 숨김 폼 -->
      <form id="gradeForm" method="post" action="<c:url value='/admin/member/grade.do'/>">
        <input type="hidden" name="userId"><input type="hidden" name="grade">
      </form>
      <form id="delForm" method="post" action="<c:url value='/admin/member/delete.do'/>"></form>

    </div>
  </section>
</div>

<script>
  const $  = s => document.querySelector(s);
  const $$ = s => Array.from(document.querySelectorAll(s));
  $('#chkAll')?.addEventListener('change', e =>
    $$('.rowChk').forEach(c => c.checked = e.target.checked));

  // 등급 수정(1건)
  $('#btnUpdate')?.addEventListener('click', () => {
    const checked = $$('.rowChk').filter(c=>c.checked);
    if (checked.length !== 1) { alert('수정은 1건만 선택하세요.'); return; }
    const tr = checked[0].closest('tr');
    const f = $('#gradeForm');
    f.userId.value = tr.dataset.id;
    f.grade.value  = tr.querySelector('.gradeSel').value;
    f.submit();
  });

  // 선택 삭제
  $('#btnDelete')?.addEventListener('click', () => {
    const ids = $$('.rowChk').filter(c=>c.checked).map(c=>c.value);
    if (!ids.length) return alert('삭제할 항목을 선택하세요.');
    if (!confirm(ids.length + '건 삭제하시겠습니까?')) return;
    const f = $('#delForm'); f.innerHTML='';
    ids.forEach(id => { const i=document.createElement('input'); i.type='hidden'; i.name='ids'; i.value=id; f.appendChild(i); });
    f.submit();
  });
</script>
</body>
</html>