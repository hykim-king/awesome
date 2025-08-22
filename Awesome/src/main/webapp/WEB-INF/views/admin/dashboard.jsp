<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>관리자 대시보드</title>
  <link rel="stylesheet" href="<c:url value='/resources/css/admin.css'/>">
</head>
<body>
<div class="admin-wrap"><!-- 좌측 사이드바 + 우측 컨텐츠 -->


  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="title">관리자 페이지</div>
    <ul class="nav">
      <li><a class="active" href="<c:url value='/admin/dashboard.do'/>">대시보드</a></li>
      <li><a href="<c:url value='/admin/members.do'/>">회원 관리</a></li>
      <li><a href="<c:url value='/admin/articles.do'/>">기사 관리</a></li>
      <li><a href="<c:url value='/admin/reports.do'/>">신고 관리</a></li>
      <a class="btn btn-outline" href="<c:url value='/member/logout.do'/>">로그아웃</a>
      
    </ul>
  </aside>

  <!-- Content -->
  <section class="content">
  <div class="panel">
    <div class="head">
      <h1 class="h1">관리자 대시보드</h1>
    </div>
    <p>좌측 메뉴에서 회원/기사/신고 관리로 이동하세요.</p>
    <!-- 필요 시 요약 통계 카드 등을 배치 -->
  </div>
</section>

</div>
</body>
</html>
