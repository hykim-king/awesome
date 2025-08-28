<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>뉴스 사전</title>
  <style>
    .dict-widget { font-size:14px; }
    .dict-form { display:flex; gap:8px; }
    .dict-form input { flex:1; padding:6px 8px; border:1px solid #ddd; border-radius:6px; }
    .dict-form button { padding:6px 10px; border:1px solid #0046FF; background:#0046FF; color:#fff; border-radius:6px; cursor:pointer; }
    .dict-form button:disabled { opacity:.6; cursor:not-allowed; }
    .dict-results { margin-top:10px; border-top:1px solid #e5e5e5; padding-top:8px; display:none; }
    .dict-item { padding:8px 0; border-bottom:1px dashed #eee; }
    .dict-term { font-weight:700; margin-bottom:4px; }
    .dict-summary { color:#555; line-height:1.4; margin-bottom:6px; }
    .dict-actions a { text-decoration:underline; }
    .dict-empty, .dict-error, .dict-loading { color:#666; padding:8px 0; }
  </style>
</head>
<body>
<div class="dict-widget" role="search" aria-label="뉴스 사전 검색">
  <form id="dictForm" class="dict-form" autocomplete="off">
    <input id="dictQuery" type="text" name="query" placeholder="궁금한 용어를 검색해보세요" required aria-label="검색어 입력" />
    <button id="dictSearchBtn" type="submit" aria-label="검색">검색</button>
  </form>

  <div id="dictResults" class="dict-results" aria-live="polite" aria-busy="false"></div>
</div>

<script>
(function () {
  // 안전한 절대경로: 컨텍스트 자동 부착됨
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
            '<div class="dict-term">' + term + '</div>' +
            '<div class="dict-summary">' + summary + '</div>' +
            '<div class="dict-actions"><a href="' + link + '" target="_blank" rel="noopener">자세히보기</a></div>' +
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