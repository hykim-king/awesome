<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>뉴스 기사 목록</title>
<style>
body { font-family: 'Noto Sans KR', Arial, sans-serif; background: #f4f6f8; margin: 0; }
.container { width:900px; margin:30px auto; background:#fff; border-radius:10px; box-shadow:0 2px 8px #ccc; padding:40px;}
.nav { margin-bottom: 20px;}
.nav a { margin-right: 18px; text-decoration:none; color:#1a1a1a; font-weight:bold;}
.nav a.active { color:#1976d2; border-bottom:2px solid #1976d2; }
.search-box { margin-bottom: 25px; }
.search-box select, .search-box input[type=text] { padding:6px 10px; border-radius:5px; border:1px solid #bbb; }
.search-box button { padding:6px 20px; background:#1976d2; color:#fff; border:none; border-radius:5px; margin-left:10px;}
.news-list { margin-top:15px; }
.news-item { background:#fafbfc; border-radius:7px; box-shadow:0 1px 3px #eee; margin-bottom:18px; padding:18px 20px;}
.news-title { font-size:1.15rem; margin:0 0 8px 0; font-weight:bold;}
.meta { color:#555; font-size:0.92rem; margin-bottom:6px;}
.summary { color:#222; margin-bottom:4px;}
.no-data { text-align:center; color:#888; padding: 40px 0;}
.paging { margin:32px 0 10px; text-align:center; }
.paging a, .paging span { margin:0 3px; padding:5px 12px; border-radius:5px; color:#1976d2; text-decoration:none; border:1px solid #e0e0e0; }
.paging .active { background:#1976d2; color:#fff; }
</style>
</head>
<body>
<div class="container">
    <!-- 카테고리 네비 -->
    <div class="nav">
        <a href="/article/list.do" class="${empty category ? 'active' : ''}">전체</a>
        <a href="/article/list.do?category=1" class="${category == 1 ? 'active' : ''}">정치</a>
        <a href="/article/list.do?category=2" class="${category == 2 ? 'active' : ''}">경제</a>
        <a href="/article/list.do?category=3" class="${category == 3 ? 'active' : ''}">사회</a>
        <a href="/article/list.do?category=4" class="${category == 4 ? 'active' : ''}">연예</a>
        <a href="/article/list.do?category=5" class="${category == 5 ? 'active' : ''}">스포츠</a>
        <a href="/article/list.do?category=6" class="${category == 6 ? 'active' : ''}">IT/과학</a>
    </div>

    <!-- 검색 폼 -->
    <form method="get" action="/article/list.do" class="search-box">
        <input type="hidden" name="category" value="${category}" />
        <select name="searchDiv">
            <option value="">검색구분</option>
            <option value="10" ${searchDiv == '10' ? 'selected' : ''}>제목</option>
            <option value="20" ${searchDiv == '20' ? 'selected' : ''}>요약</option>
            <option value="30" ${searchDiv == '30' ? 'selected' : ''}>언론사</option>
            <option value="40" ${searchDiv == '40' ? 'selected' : ''}>발행일</option>
        </select>
        <input type="text" name="searchWord" value="${searchWord}" placeholder="검색어 입력" />
        <button type="submit">검색</button>
    </form>

    <!-- 기사 리스트 -->
    <div class="news-list">
        <c:choose>
            <c:when test="${not empty list}">
                <c:forEach var="item" items="${list}">
                    <div class="news-item">
                        <div class="news-title">
                            <a href="${item.url}" target="_blank">${item.title}</a>
                        </div>
                        <div class="summary">${item.summary}</div>
                        <div class="meta">
                            ${item.press} |
                            <fmt:formatDate value="${item.publicDt}" pattern="yyyy.MM.dd HH:mm" /> | 조회수: ${item.views}
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
        <%-- totalCount가 null이면 0으로 처리 --%>
        <c:set var="safeTotalCount" value="${empty totalCount ? 0 : totalCount}" />
        <c:set var="totalPage" value="${(safeTotalCount / pageSize) + (safeTotalCount % pageSize > 0 ? 1 : 0)}" />
        <c:forEach begin="1" end="${totalPage}" var="p">
            <c:choose>
                <c:when test="${pageNum == p}">
                    <span class="active">${p}</span>
                </c:when>
                <c:otherwise>
                    <a href="?pageNum=${p}&pageSize=${pageSize}&category=${category}&searchDiv=${searchDiv}&searchWord=${searchWord}">${p}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </div>
</div>
</body>
</html>