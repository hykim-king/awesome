<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 컨텍스트 경로/카테고리 -->
<c:set var="CP" value="${pageContext.request.contextPath}" />
<c:set var="CATEGORY" value="${empty param.category ? 10 : param.category}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>실시간 채팅</title>

<!-- (선택) Spring Security CSRF -->
<c:if test="${not empty _csrf}">
  <meta name="_csrf_header" content="${_csrf.headerName}"/>
  <meta name="_csrf" content="${_csrf.token}"/>
</c:if>

<style>
:root { --bg:#ffffff; --line:#eee; --muted:#888; --btn:#444; --btn-text:#fff; }
* { box-sizing: border-box; }
body { margin:0; font:14px/1.45 -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Noto Sans KR", Arial, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif; background:#f7f7f7; color:#222; }

.chat-wrap { max-width: 520px; margin: 24px auto; background:var(--bg); border-radius:12px; box-shadow:0 4px 14px rgba(0,0,0,.06); overflow:hidden; }
.chat-header { padding:14px 16px; border-bottom:1px solid var(--line); display:flex; align-items:center; gap:10px; }
.chat-title { font-weight:700; font-size:16px; }
.chat-cat { margin-left:auto; color:var(--muted); font-size:12px; }

.chat-list { list-style:none; padding:0; margin:0; max-height:60vh; overflow:auto; background:#fff; }
.chat-item { display:flex; gap:10px; padding:12px; border-bottom:1px solid var(--line); }
.avatar { width:36px; height:36px; border-radius:50%; background:#ddd; display:flex; align-items:center; justify-content:center; font-size:12px; color:#555; flex-shrink:0; }
.bubble { flex:1; min-width:0; }
.meta { display:flex; align-items:center; gap:8px; font-size:12px; color:var(--muted); }
.meta .uid { font-weight:600; color:#444; }
.meta .time { margin-left:2px; }
.meta .report { margin-left:auto; border:none; background:transparent; cursor:pointer; font-size:12px; color:#d9534f; }
.text { margin-top:4px; font-size:14px; word-break:break-word; white-space:pre-wrap; }

.chat-input { position:sticky; bottom:0; display:flex; gap:8px; padding:10px; background:#fafafa; border-top:1px solid var(--line); }
.chat-input input { flex:1; padding:12px; border:1px solid #ccc; border-radius:8px; outline:none; }
.chat-input button { padding:12px 16px; border:none; border-radius:8px; background:var(--btn); color:var(--btn-text); cursor:pointer; }
.chat-input button:disabled { opacity:.5; cursor:not-allowed; }

@media (max-width: 540px){
  .chat-wrap { margin: 0; border-radius: 0; height: 100vh; display:flex; flex-direction:column; }
  .chat-list { flex:1; max-height:none; }
}
</style>
</head>
<body>
  <div class="chat-wrap" id="chatRoot" data-cp="${CP}" data-category="${CATEGORY}">
    <div class="chat-header">
      <div class="chat-title">채팅창</div>
      <div class="chat-cat">카테고리: <b id="catLabel">${CATEGORY}</b></div>
    </div>

    <ul id="chatList" class="chat-list"></ul>

    <div class="chat-input">
      <input id="msg" type="text" placeholder="내용을 입력하세요." autocomplete="off"
             onkeydown="if(event.key==='Enter') sendMessage()">
      <button id="sendBtn" onclick="sendMessage()">전송</button>
    </div>
  </div>

  <!-- SockJS/STOMP (CDN) -->
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<script>
  // ===== 전역 가드 =====
  // 타일즈/인클루드/뒤로가기 캐시 등으로 스크립트가 중복 실행되는 것을 차단
  if (window.__chatInit) {
    console.warn("chat page already initialized; skipping duplicate init");
  } else {
    window.__chatInit = true;

    // ===== 기본 환경 =====
    (function(){
      var root = document.getElementById('chatRoot');
      window.CP = root ? (root.getAttribute('data-cp') || '') : '';
      window.CATEGORY = root ? parseInt(root.getAttribute('data-category') || '10', 10) : 10;
    })();

    var CSRF_HEADER = (document.querySelector('meta[name=\"_csrf_header\"]')||{}).content;
    var CSRF_TOKEN  = (document.querySelector('meta[name=\"_csrf\"]')||{}).content;

    // ===== WebSocket 상태 =====
    var stomp = null;
    var connected = false;
    var connecting = false;
    var subscription = null; // 구독 핸들러 보관

    function safeSubscribe() {
      // 혹시 이전 구독이 살아있다면 해제
      try { if (subscription && subscription.id) { subscription.unsubscribe(); } } catch(e) {}
      subscription = stomp.subscribe("/topic/chat/" + CATEGORY, function(frame){
        var m = JSON.parse(frame.body);
        appendMessage(m);
      });
    }

    function connectWS() {
      if (connecting || (stomp && stomp.connected)) {
        console.log("skip connect: already connecting/connected");
        return;
      }
      connecting = true;

      var sock = new SockJS(CP + "/ws-chat");
      stomp = Stomp.over(sock);
      stomp.debug = null; // 필요시 주석 처리하여 로그 확인

      stomp.connect({}, function(){
        connected = true;
        connecting = false;
        document.getElementById('sendBtn').disabled = false;

        safeSubscribe(); // 구독 1개만 유지

        // 초기 로딩
        fetch(CP + "/chat/recent?category=" + CATEGORY + "&size=30", {credentials:"same-origin"})
          .then(function(r){ return r.json(); })
          .then(function(list){ list.reverse().forEach(appendMessage); })
          .catch(console.error);
      }, function(err){
        console.error("STOMP error:", err);
        connected = false;
        connecting = false;
        document.getElementById('sendBtn').disabled = true;
      });
    }

    // ===== 메시지 보내기 =====
    window.sendMessage = function(){
      var input = document.getElementById('msg');
      var text = (input.value || '').trim();
      if(!text || !connected) return;

      var payload = { message: text };
      stomp.send("/app/send/" + CATEGORY, {}, JSON.stringify(payload));
      input.value = "";
      input.focus();
    };

    // ===== 메시지 렌더링 =====
    function appendMessage(m){
      var code = m.chatCode || 0;
      var userId = m.userId || "user***";
      var avatarText = (userId.charAt(0) || 'u');
      var time = formatTime(m.sendDt);
      var text = escapeHtml(m.message || '');

      var li = document.createElement('li');
      li.className = 'chat-item';
      li.setAttribute('data-code', String(code));

      var html = ''
        + '<div class="avatar">' + escapeHtml(avatarText) + '</div>'
        + '<div class="bubble">'
        +   '<div class="meta">'
        +     '<span class="uid">' + escapeHtml(userId) + '</span>'
        +     '<span class="time">' + escapeHtml(time) + '</span>'
        +     '<button class="report" onclick="reportMsg(' + code + ')" title="신고">🚨 신고</button>'
        +   '</div>'
        +   '<div class="text">' + text + '</div>'
        + '</div>';

      li.innerHTML = html;
      var list = document.getElementById('chatList');
      list.appendChild(li);
      li.scrollIntoView({behavior:'smooth', block:'end'});
    }

    // ===== 신고 =====
    window.reportMsg = function(chatCode){
      if(!chatCode){ alert("메시지 코드가 없습니다."); return; }
      var reason = prompt("신고 사유를 입력하세요.");
      if(!reason) return;

      var headers = {'Content-Type':'application/json'};
      if (CSRF_HEADER && CSRF_TOKEN) headers[CSRF_HEADER] = CSRF_TOKEN;

      fetch(CP + "/report", {
        method:'POST',
        headers: headers,
        credentials:'same-origin',
        body: JSON.stringify({ chatCode: chatCode, reason: reason })
      })
      .then(function(r){ return r.json(); })
      .then(function(res){ alert((res && res.message) ? res.message : '신고가 접수되었습니다.'); })
      .catch(function(err){ console.error(err); alert('신고 전송 중 오류가 발생했습니다.'); });
    };

    // ===== 유틸 =====
    function escapeHtml(s){ var d=document.createElement('div'); d.innerText = (s==null? '' : String(s)); return d.innerHTML; }
    function pad2(n){ n = Number(n); return (n<10?'0':'') + n; }
    function formatTime(dt){
      try{
        if(!dt) return '';
        var d = new Date(dt);
        if (isNaN(d.getTime())) return String(dt);
        return d.getFullYear()+'.'+pad2(d.getMonth()+1)+'.'+pad2(d.getDate())+' '+pad2(d.getHours())+':'+pad2(d.getMinutes());
      }catch(e){ return String(dt||''); }
    }

    // ===== 생명주기 =====
    document.addEventListener('DOMContentLoaded', function(){
      document.getElementById('sendBtn').disabled = true;
      connectWS();
    });

    // 페이지 떠날 때 깔끔히 정리(중복 연결 방지)
    window.addEventListener('beforeunload', function(){
      try { if (subscription && subscription.id) subscription.unsubscribe(); } catch(e) {}
      try { if (stomp && stomp.connected) stomp.disconnect(function(){}); } catch(e) {}
      window.__chatInit = false;
    });
  }
</script>

</body>
</html>
