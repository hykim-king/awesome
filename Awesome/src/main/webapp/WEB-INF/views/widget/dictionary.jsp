<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="card dict-widget">
  <div class="card-header">용어사전</div>

  <!-- 페이지 리로드 방식: .do 엔드포인트 -->
<div class="dict-form">
  <input type="text" id="dictQuery" placeholder="용어를 입력하세요" value="${query}" required />
  <button type="button"
          onclick="location.href='${ctx}/widget/dict/search.do?query='
                   + encodeURIComponent(document.getElementById('dictQuery').value)">
    검색
  </button>
</div>

  <c:if test="${not empty recentKeywords}">
    <div class="recent">
      <span class="title">최근 검색어</span>
      <div class="chips">
        <c:forEach var="k" items="${recentKeywords}">
          <a class="chip" href="<c:url value='/widget/dict/search.do'/>?query=${k}"><c:out value="${k}" /></a>
        </c:forEach>
      </div>
    </div>
  </c:if>

  <c:if test="${not empty dictError}">
    <div class="error"><c:out value="${dictError}" /></div>
  </c:if>

  <c:if test="${not empty result}">
    <div class="dict-result">
      <c:if test="${not empty result.items}">
        <c:forEach var="item" items="${result.items}">
          <div class="entry">
            <a href="${item.link}" target="_blank" class="term"><c:out value="${item.title}" /></a>
            <div class="desc"><c:out value="${item.description}" /></div>
          </div>
        </c:forEach>
      </c:if>
      <c:if test="${empty result.items}">
        <div class="no-data">검색 결과가 없습니다.</div>
      </c:if>
    </div>
  </c:if>
</div>

<style>
.dict-widget { padding:12px; border:1px solid #e5e7eb; border-radius:12px; background:#fff; }
.dict-widget .card-header { font-weight:700; margin-bottom:8px; }
.dict-form { display:flex; gap:6px; margin-bottom:8px; }
.dict-form input { flex:1; padding:6px 8px; }
.recent .title { font-size:12px; color:#666; }
.chips { display:flex; flex-wrap:wrap; gap:6px; margin-top:6px; }
.chip { padding:4px 8px; border:1px solid #ddd; border-radius:999px; font-size:12px; text-decoration:none; }
.dict-result .entry { padding:8px 0; border-top:1px solid #f0f0f0; }
.dict-result .entry .term { font-weight:600; }
.dict-result .entry .desc { font-size:13px; color:#444; margin-top:4px; }
.error { color:#b91c1c; }
</style>