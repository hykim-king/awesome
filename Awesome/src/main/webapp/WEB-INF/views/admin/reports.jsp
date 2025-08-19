<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="<c:url value='/resources/css/admin.css'/>">

 
  <title>관리자 대시보드</title>
</head>
<body>
  <jsp:include page="/WEB-INF/views/include/header.jsp"/>

  <main style="padding:16px">
    <h1>관리자 대시보드</h1>
    <ul>
      <li><a href="<c:url value='/admin/members.do'/>">회원 관리</a></li>
      <li><a href="<c:url value='/admin/articles.do'/>">기사 관리</a></li>
      <li><a href="<c:url value='/admin/reports.do'/>">신고 관리</a></li>
    </ul>
  </main>

  <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</body>
</html>
