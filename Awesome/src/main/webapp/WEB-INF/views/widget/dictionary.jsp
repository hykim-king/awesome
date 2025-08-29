<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>뉴스 사전 위젯</title>

  <!-- 분리된 CSS 파일 -->
  <link rel="stylesheet" href="<c:url value='/resources/css/dictionary01.css'/>">
</head>
<body>
<div class="dict-widget" role="search" aria-label="뉴스 사전 검색">
<!-- 헤더 -->
<div class="dict-header">
  <strong class="dict-title">🔍 용어 사전</strong>
</div>

  <!-- 검색 폼 -->
  <form id="dictForm" class="dict-form" autocomplete="off">
    <input id="dictQuery" type="text" name="query" placeholder="궁금한 용어를 검색해보세요." required aria-label="검색어 입력" />
    <button id="dictSearchBtn" type="submit" aria-label="검색">검색</button>
  </form>

  <!-- 결과 -->
  <div id="dictResults" class="dict-results" aria-live="polite" aria-busy="false"></div>
</div>

<script>
(function () {
  var searchUrl = '<c:url value="/widget/dict/search.do"/>';
  var form = document.getElementById('dictForm');
  var input = document.getElementById('dictQuery');
  var btn = document.getElementById('dictSearchBtn');
  var box = document.getElementById('dictResults');

  form.addEventListener('submit', function (e) {
    e.preventDefault();
    doSearch();
  });

  input.addEventListener('keydown', function (e) {
    if (e.key === 'Enter') {
      e.preventDefault();
      doSearch();
    }
  });

  function setLoading(on) {
    box.style.display = 'block';
    box.setAttribute('aria-busy', on ? 'true' : 'false');
    btn.disabled = !!on;
    if (on) box.innerHTML = '<div class="dict-loading">검색 중...</div>';
  }

  function esc(s) {
    return String(s || '')
      .replace(/&/g,'&amp;').replace(/</g,'&lt;')
      .replace(/>/g,'&gt;').replace(/"/g,'&quot;')
      .replace(/'/g,'&#39;');
  }

  async function doSearch() {
    var q = (input.value || '').trim();
    if (!q) {
      box.style.display = 'none';
      box.innerHTML = '';
      return;
    }

    setLoading(true);
    try {
      var resp = await fetch(searchUrl + '?query=' + encodeURIComponent(q), {
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
      });
      if (!resp.ok) throw new Error('HTTP ' + resp.status);
      var data = await resp.json(); // [{term, summary, link}, ...]

      if (!Array.isArray(data) || data.length === 0) {
        box.innerHTML = '<div class="dict-empty">검색 결과가 없습니다.</div>';
        return;
      }

      var top5 = data.slice(0, 5);
      box.innerHTML = top5.map(function (it) {
        var term = esc(it.term);
        var summary = esc(it.summary);
        var link = it.link || '#';
        return (
          '<div class="dict-item">' +
            // ✅ 한 줄짜리 좌우 배치(용어 왼쪽 / 자세히보기 오른쪽)
            '<div class="dict-row">' +
              '<div class="dict-term">' + term + '</div>' +
              '<div class="dict-actions"><a href="' + link + '" target="_blank" rel="noopener">자세히보기</a></div>' +
            '</div>' +
            // 요약은 다음 줄
            '<div class="dict-summary">' + summary + '</div>' +
          '</div>'
        );
      }).join('');

    } catch (err) {
      console.error(err);
      box.innerHTML = '<div class="dict-error">오류가 발생했습니다. 잠시 후 다시 시도해 주세요.</div>';
    } finally {
      setLoading(false);
    }
  }
})();
</script>
</body>
</html>