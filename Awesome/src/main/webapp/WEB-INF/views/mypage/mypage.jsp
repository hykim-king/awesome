<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- 구글 차트 -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/chart.js"></script>

<!-- 워드 클라우드 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/wordcloud2.js/1.1.2/wordcloud2.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/wordcloud.js"></script>
</head>
<body>
    <main id="main">
    <div class="main-container">
    
    <!-- 구글 차트 -->
    <div id="piechart_3d" style="width: 900px; height: 500px;"></div>
    <!-- 워드 클라우드 -->
    <div id="wordCloud" style="width:1000px; height:400px;"></div>
    <hr>

<div class="bookmark-list">
  <c:choose>
    <%-- 북마크가 있는 경우 --%>
    <c:when test="${not empty list}">
      <c:forEach var="item" items="${list}">
        <div class="bookmark-item">
          <h3 class="title">
            <a href="${item.link}" target="_blank">${item.title}</a>
          </h3>
          <p class="summary">${item.summary}</p>
          <div class="meta">
            <span class="press">${item.press}</span>
            <span class="date">
              <fmt:formatDate value="${item.regDt}" pattern="yyyy-MM-dd"/>
            </span>
          </div>
        </div>
        <hr/>
      </c:forEach>
    </c:when>

    <%-- 북마크가 없는 경우 --%>
    <c:otherwise>
      <div class="no-bookmark">
        ${noBookmarkMsg}
      </div>
    </c:otherwise>
  </c:choose>
</div>

<!-- 페이지네이션 -->
<c:if test="${totalCnt > 0}">
  <div class="pagination">
    <c:set var="totalPage" value="${(totalCnt / pageSize) + (totalCnt % pageSize > 0 ? 1 : 0)}"/>

    <c:forEach var="i" begin="1" end="${totalPage}">
      <c:choose>
        <c:when test="${i == pageNo}">
          <span class="current">${i}</span>
        </c:when>
        <c:otherwise>
          <a href="<c:url value='/doRetriveMy.do?pageNo=${i}&pageSize=${pageSize}'/>">${i}</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>
  </div>
</c:if>

    </div>
    </main>
</body>
</html>