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
</head>
<body>
	<div class="container">
		<!-- 카테고리 네비 -->
		<div class="nav">
			<a href="${pageContext.request.contextPath}/article/list.do"
				class="${empty category ? 'active' :' '}">전체</a> <a
				href="${pageContext.request.contextPath}/article/list.do?category=10"
				class="${category == 10 ?'active' :' '}">정치</a> <a
				href="${pageContext.request.contextPath}/article/list.do?category=20"
				class="${category == 20 ?'active' :' '}">경제</a> <a
				href="${pageContext.request.contextPath}/article/list.do?category=30"
				class="${category == 30 ?'active' :' '}">사회</a> <a
				href="${pageContext.request.contextPath}/article/list.do?category=40"
				class="${category == 40 ?'active' :' '}">연애</a> <a
				href="${pageContext.request.contextPath}/article/list.do?category=50"
				class="${category == 50 ?'active' :' '}">스포츠</a> <a
				href="${pageContext.request.contextPath}/article/list.do?category=60"
				class="${category == 60 ?'active' :' '}">IT/과학</a>
		</div>
		<!-- 검색 폼 -->
		<form method="get"
			action="${pageContext.request.contextPath}/article/list.do"
			class="search-box">
			<input type="hidden" name="category" value="${category }" /> <input
				type="hidden" name="pageNum" value="1" /> <input type="hidden"
				name="pageSize" value="${pageSize }" /> <select name="searchDiv">
				<option value="">검색구분</option>
				<option value="10" ${searchDiv == '10'? 'selected' : ''}>제목</option>
				<option value="20" ${searchDiv == '20'? 'selected' : ''}>내용</option>
				<option value="30" ${searchDiv == '30'? 'selected' : ''}>언론사</option>
				<option value="40" ${searchDiv == '40'? 'selected' : ''}>발행일</option>
			</select> <input type="text" name="searchWord" value="${searchWord}"
				placeholder="검색어를 입력하세요" />
			<button type="submit">검색</button>
		</form>
		<!-- 기사 리스트 -->
		<div class="news-list">
			<c:choose>
				<c:when test="${not empty list}">
					<!-- 날짜 비교 -->
					<c:set var="now" value="<%=new java.util.Date()%>" />
					<fmt:formatDate value="${now}" pattern="yyyy=MM-dd" var="nowYmd" />

					<c:forEach var="item" items="${list}">
						<div class="news-item">
							<div class="news-title">
								<a href="${item.url}" target="_blank">${item.title}</a>
							</div>

							<div class="summary">${item.summary}</div>

							<div class="meta">
								${item.press} |
								<fmt:formatDate value="${item.publicDt}" pattern="yyyy-MM-dd"
									var="pubYmd" />
								<c:choose>
									<c:when test="${pubYmd == nowYmd}">
										<fmt:formatDate value="${item.publicDt}" pattern="HH:mm" />
									</c:when>
									<c:otherwise>
										<fmt:formatDate value="${item.publicDt}" pattern="yyyy-MM-dd" />
									</c:otherwise>
								</c:choose>
								| 조회수: ${item.views}
							</div>
						</div>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<div class="no-data">
						<c:choose>
							<c:when test="${not empty searchWord}">
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
			<c:set var="prevPage" value="{pageNum-1}"></c:set>
			<c:set var="nextPage" value="{pageNum+1}"></c:set>

			<!-- 이전 페이지 -->
			<c:choose>
				<c:when test="${pageNum>1}">
					<a href="${pageContext.request.contextPath}/article/list.do?pageNum=${prevPage}&pageSize=${pageSize}&category=${category}&searchDiv=${searchDiv}&searchWord=${searchWord}">이전</a>
				</c:when>
				<c:otherwise>
					<!-- 1페이지 일때 비활성화 -->
					<span class="disabled">이전</span>
				</c:otherwise>
			</c:choose>

			<!-- 현재 페이지 -->
			<span>${pageNum}</span>

			<!-- 다음 페이지 -->

			<a href="${pageContext.request.contextPath}/article/list.do?pageNum=${nextPage}&pageSize=${pageSize}&category=${category}&searchDiv=${searchDiv}&searchWord=${searchWord}">다음</a>
		</div>
	</div>
</body>
</html>