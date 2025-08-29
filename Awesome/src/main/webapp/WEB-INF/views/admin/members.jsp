<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="CP" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>회원 관리</title>
  <link rel="stylesheet" href="<c:url value='/resources/css/admin.css'/>" />
  <style>
    <style>
.grid th, .grid td {
    padding: 12px 16px;
    vertical-align: middle;
}

.grid thead th {
    text-align: center;
}

.grid tbody td {
    text-align: left;
}

.grid td.chk, .grid td:nth-child(1), .grid td:nth-child(6), .grid td:nth-child(7)
    {
    text-align: center;
}

.gradeSel {
    min-width: 80px;
    text-align-last: center;
    -moz-text-align-last: center;
}

.head {
    display: flex;
    align-items: center;
    gap: 10px;
    justify-content: space-between;
    margin-bottom: 12px;
}

.actions {
    display: flex;
    gap: 8px;
    align-items: center;
}

.message {
    margin: 10px 0;
    padding: 10px 12px;
    border-radius: 6px;
    background: #fff0f0;
    color: #a80000;
}

.pagination {
    display: flex;
    gap: 6px;
    justify-content: center;
    margin-top: 14px;
}

.pagination .page {
    padding: 6px 10px;
    border-radius: 6px;
    border: 1px solid #e5e7eb;
    text-decoration: none;
}

.pagination .page.active {
    background: #0a45ff;
    color: #fff;
    border-color: #0a45ff;
}
</style>
  </style>
</head>
<body>
<div class="admin-wrap">
  <!-- Sidebar -->
        <aside class="sidebar">
            <div class="title">관리자 페이지</div>
            <ul class="nav">
                <li><a href="<c:url value='/admin/dashboard.do'/>">대시보드</a></li>
                <li><a class="active" href="<c:url value='/admin/members.do'/>">회원
                        관리</a></li>
                <li><a href="<c:url value='/admin/articles.do'/>">기사 관리</a></li>
                <li><a href="<c:url value='/admin/report.do'/>">신고 관리</a></li>
                <li><a href="<c:url value='/member/logout.do'/>">로그아웃</a></li>
            </ul>
        </aside>

  <section class="content">
    <div class="panel">

      <!-- 상단 검색 + 버튼 (기존 그대로, 단 버튼 type="button") -->
      <div class="head">
        <h1 class="h1">회원 관리</h1>
        <form method="get" action="<c:url value='/admin/members.do'/>" class="actions" id="searchForm">
          <select name="type" class="select">
            <option value="id"   <c:if test="${type=='id'}">selected</c:if>>아이디</option>
            <option value="nick" <c:if test="${type=='nick'}">selected</c:if>>닉네임</option>
          </select>
          <input class="input" type="text" name="keyword" value="${keyword}" placeholder="검색어">
          <select name="grade" class="select">
            <option value="">등급 전체</option>
            <option value="0" <c:if test="${grade==0}">selected</c:if>>관리자</option>
            <option value="1" <c:if test="${grade==1}">selected</c:if>>회원</option>
          </select>
          <button class="btn btn-primary" type="submit">검색</button>

          <button class="btn btn-warning" type="button" id="btnUpdate">수정</button>
          <button class="btn btn-danger"  type="button" id="btnDelete">삭제</button>
        </form>
      </div>

      <!-- 메시지 -->
      <c:if test="${not empty message}">
        <div class="message" style="background:#f0f7ff;color:#0b3d91;">${message}</div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="message">${error}</div>
      </c:if>

      <!-- 테이블 -->
      <table class="grid" id="memberTable">
        <thead>
          <tr>
            <th class="center"><input type="checkbox" id="chkAll"></th>
            <th>아이디</th>
            <th>이름</th>
            <th>닉네임</th>
            <th>이메일</th>
            <th>생년월일</th>
            <th>등급</th>
            <th>이메일인증</th>
            <th>가입일</th>
            <th>수정일</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach var="m" items="${rows}">
          <tr data-id="${m.userId}">
            <td class="center"><input type="checkbox" class="rowChk" value="${m.userId}"></td>
            <td>${m.userId}</td>
            <td>${m.userNm}</td>
            <td>${m.nickNm}</td>
            <td>${m.mailAddr}</td>
            <td>${m.birthDt}</td>
            <td class="center">
              <select class="select gradeSel">
                <option value="0" <c:if test="${m.userGradeCd==0}">selected</c:if>>관리자</option>
                <option value="1" <c:if test="${m.userGradeCd==1}">selected</c:if>>회원</option>
              </select>
            </td>
            <td class="center">${m.emailAuthYn}</td>
            <td><fmt:formatDate value="${m.regDt}" pattern="yyyy-MM-dd HH:mm"/></td>
            <td><fmt:formatDate value="${m.modDt}" pattern="yyyy-MM-dd HH:mm"/></td>
          </tr>
        </c:forEach>

        <c:if test="${empty rows}">
          <tr><td colspan="10" class="center" style="padding:24px;">데이터가 없습니다.</td></tr>
        </c:if>
        </tbody>
      </table>

      <!-- 페이지네이션 (기존 그대로) -->

      <!-- 배치 등급수정 / 삭제용 빈 폼 -->
      <form id="gradeForm" method="post" action="${CP}/admin/members/gradeBatch.do"></form>
      <form id="delForm"   method="post" action=""></form>

    </div>
  </section>
</div>

<script>
  const $$ = s => Array.from(document.querySelectorAll(s));
  const CP = '${CP}';

  // 전체 체크
  document.getElementById('chkAll')?.addEventListener('change', e => {
    $$('.rowChk').forEach(c => c.checked = e.target.checked);
  });

  // 삭제
  function onDeleteSelected(){
    const ids = $$('.rowChk:checked').map(c => c.value);
    if (!ids.length) { alert('삭제할 회원을 선택하세요.'); return; }

    const f = document.getElementById('delForm');
    f.innerHTML = '';
    ids.forEach(id => {
      const i = document.createElement('input');
      i.type='hidden'; i.name='ids'; i.value=id;
      f.appendChild(i);
    });

    f.action = CP + '/admin/member/delete.do';
    f.method = 'post';
    f.submit();
  }
  document.getElementById('btnDelete')?.addEventListener('click', onDeleteSelected);

  // 등급 배치 수정 (배열 파라미터 방식)
  function onBatchGradeUpdate(){
    const rows = $$('.rowChk:checked').map(c => c.closest('tr'));
    if (!rows.length) { alert('변경할 회원을 선택하세요.'); return; }

    const f = document.getElementById('gradeForm');
    f.innerHTML = '';

    // page/size 유지(리다이렉트용)
    const url = new URL(window.location.href);
    const curPage = url.searchParams.get('page') || '1';
    const curSize = url.searchParams.get('size') || '10';

    const hp = (name, value) => {
      const i = document.createElement('input');
      i.type = 'hidden'; i.name = name; i.value = value;
      f.appendChild(i);
    };

    // 배열 파라미터: userIds & grades
    rows.forEach(tr => {
      const userId = tr.dataset.id;
      const grade  = tr.querySelector('.gradeSel').value;
      hp('userIds', userId);
      hp('grades',  grade);
    });

    hp('page', curPage);
    hp('size', curSize);

    // console.log(new URLSearchParams(new FormData(f)).toString()); // 디버그

    f.action = CP + '/admin/members/gradeBatch.do';
    f.method = 'post';
    f.submit();
  }

  document.getElementById('btnUpdate')?.addEventListener('click', onBatchGradeUpdate);
</script>
</body>
</html>
