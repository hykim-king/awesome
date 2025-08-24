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
/**
 * 채팅 JS – 회원만 전송 가능 / 비회원은 에러 큐로 안내
 * - 필요한 data-* :
 *   <div id="chatRoot" data-cp="${CP}" data-category="${CATEGORY}" data-logged-in="${not empty sessionScope.USER_ID}"></div>
 */
(function(){
  'use strict';

  // ===== 중복 초기화 방지 =====
  if (window.__chatInit) {
    console.warn('[chat] already initialized; skip');
    return;
  }
  window.__chatInit = true;

  // ===== 환경값 / DOM =====
  var root = document.getElementById('chatRoot');
  if (!root) {
    console.error('[chat] #chatRoot not found');
    return;
  }
  var CP        = root.getAttribute('data-cp') || '';
  var CATEGORY  = parseInt(root.getAttribute('data-category') || '10', 10);
  var LOGGED_IN = (String(root.getAttribute('data-logged-in')) === 'true');

  var $list   = document.getElementById('chatList'); // <ul id="chatList">
  var $input  = document.getElementById('msg');      // <input id="msg">
  var $send   = document.getElementById('sendBtn');  // <button id="sendBtn">

  var CSRF_HEADER = (document.querySelector('meta[name="_csrf_header"]')||{}).content;
  var CSRF_TOKEN  = (document.querySelector('meta[name="_csrf"]')||{}).content;

  // ===== WebSocket/STOMP 상태 =====
  var stomp = null;
  var connected = false;
  var connecting = false;
  var subChat = null;   // 채팅 수신 구독 핸들
  var subError = null;  // 에러(비회원) 구독 핸들

  // 안전 구독 / 해제
  function unsubscribeSafe(sub){
    try { if (sub && sub.id) sub.unsubscribe(); } catch(e) {}
  }

  function safeSubscribeChat(){
    unsubscribeSafe(subChat);
    subChat = stomp.subscribe("/topic/chat/" + CATEGORY, function(frame){
      try {
        var m = JSON.parse(frame.body);
        appendMessage(m);
      } catch(e){ console.error(e); }
    });
  }

  function safeSubscribeErrors(){
    unsubscribeSafe(subError);
    // 서버가 convertAndSendToUser(..., "/queue/errors", ...)로 보냄 → 클라: /user/queue/errors
    subError = stomp.subscribe("/user/queue/errors", function(frame){
      try {
        var msg = JSON.parse(frame.body);
        alert(msg.message || '로그인이 필요한 기능입니다. 먼저 로그인해 주세요.');
      } catch(e) {
        alert('로그인이 필요한 기능입니다. 먼저 로그인해 주세요.');
      }
    });
  }

  // ===== 연결 =====
  function connectWS(){
    if (connecting || (stomp && stomp.connected)) {
      console.log('[chat] skip connect: connecting/connected');
      return;
    }
    connecting = true;
    $send && ($send.disabled = true);

    var sock = new SockJS(CP + "/ws-chat");
    stomp = Stomp.over(sock);
    stomp.debug = null; // 필요시 로그 보고 싶으면 주석 처리

    stomp.connect({}, function(){
      connected = true;
      connecting = false;

      // 에러 큐(비회원 전송 시 서버가 여기로 push)
      safeSubscribeErrors();

      // 채팅 구독
      safeSubscribeChat();

      // 초기 로딩
      fetch(CP + "/chat/recent?category=" + CATEGORY + "&size=30", { credentials: "same-origin" })
        .then(function(r){ return r.json(); })
        .then(function(list){ (list||[]).reverse().forEach(appendMessage); })
        .catch(console.error);

      $send && ($send.disabled = false);
    }, function(err){
      console.error("[chat] STOMP error:", err);
      connected = false;
      connecting = false;
      $send && ($send.disabled = true);
    });
  }

  // ===== 전송 =====
  function sendMessage(){
    var text = ($input && $input.value || '').trim();
    if (!text) return;

    // 로그인 가드 (UX상 서버까지 보내지 않음)
    if (!LOGGED_IN) {
      alert('로그인이 필요한 기능입니다. 먼저 로그인해 주세요.');
      return;
    }
    if (!connected || !stomp) {
      alert('연결이 원활하지 않습니다. 잠시 후 다시 시도해 주세요.');
      return;
    }

    var payload = { message: text };
    stomp.send("/app/send/" + CATEGORY, {}, JSON.stringify(payload));
    $input.value = '';
    $input.focus();
  }
  // 전역 노출(HTML onclick/Enter에서 사용)
  window.sendMessage = sendMessage;

  // ===== 메시지 렌더링 =====
  function appendMessage(m){
    if (!$list) return;
    var code      = m.chatCode || 0;
    var userId    = m.userId || 'user***';
    var avatar    = (userId.charAt(0) || 'u');
    var timeLabel = formatTime(m.sendDt);
    var textHtml  = escapeHtml(m.message || '');

    var li = document.createElement('li');
    li.className = 'chat-item';
    li.setAttribute('data-code', String(code));

    li.innerHTML =
      '<div class="avatar">' + escapeHtml(avatar) + '</div>' +
      '<div class="bubble">' +
      '  <div class="meta">' +
      '    <span class="uid">' + escapeHtml(userId) + '</span>' +
      '    <span class="time">' + escapeHtml(timeLabel) + '</span>' +
      '    <button class="report" onclick="reportMsg(' + code + ')" title="신고">🚨 신고</button>' +
      '  </div>' +
      '  <div class="text">' + textHtml + '</div>' +
      '</div>';

    $list.appendChild(li);
    li.scrollIntoView({ behavior:'smooth', block:'end' });
  }

  // ===== 신고 =====
  window.reportMsg = function(chatCode){
    if(!chatCode){ alert("메시지 코드가 없습니다."); return; }

    // 간단 프롬프트 → 이후 모달로 교체 가능
    var reason = prompt("신고 사유를 입력하세요.\n(예: SPAM / ABUSE / 기타 내용)");
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
    .then(function(res){
      alert((res && res.message) ? res.message : '신고가 접수되었습니다.');
    })
    .catch(function(err){
      console.error(err);
      alert('신고 전송 중 오류가 발생했습니다.');
    });
  };

  // ===== 유틸 =====
  function escapeHtml(s){
    var d = document.createElement('div');
    d.innerText = (s == null ? '' : String(s));
    return d.innerHTML;
  }
  function pad2(n){ n = Number(n); return (n<10 ? '0':'') + n; }
  function formatTime(dt){
    try{
      if(!dt) return '';
      var d = new Date(dt);
      if (isNaN(d.getTime())) return String(dt);
      return d.getFullYear()+'.'+pad2(d.getMonth()+1)+'.'+pad2(d.getDate())+' '+pad2(d.getHours())+':'+pad2(d.getMinutes());
    }catch(e){
      return String(dt || '');
    }
  }

  // ===== 부트 =====
  document.addEventListener('DOMContentLoaded', function(){
    if ($send) $send.disabled = true;
    connectWS();
  });

  // ===== 정리 =====
  window.addEventListener('beforeunload', function(){
    unsubscribeSafe(subChat);
    unsubscribeSafe(subError);
    try { if (stomp && stomp.connected) stomp.disconnect(function(){}); } catch(e) {}
    window.__chatInit = false;
  });
})();
</script>


</body>
</html>
