<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- ① 컨텍스트/모델 안전 세팅 --%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="cat" value="${empty category ? 10 : category}" />
<c:set var="uid" value="${empty loginUserId ? '' : loginUserId}" />

<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <title>실시간 채팅</title>

  <%-- ② 정적 리소스(로컬에 둔 JS) : 404가 나지 않도록 경로 확인 --%>
  <script src="${ctx}/resources/js/sockjs.min.js"></script>
  <script src="${ctx}/resources/js/stomp.min.js"></script>

  <%-- ③ 최소 스타일(보기 편하게) --%>
  <style>
    body{font-family:system-ui,Segoe UI,Apple SD Gothic Neo,Malgun Gothic,Arial}
    .wrap{max-width:880px;margin:24px auto;padding:0 12px}
    .badge{display:inline-block;padding:2px 8px;border-radius:12px;background:#999;color:#fff;font-size:12px}
    .badge.on{background:#0a7}
    .panel{display:grid;grid-template-columns:1fr auto;gap:8px}
    .list{height:320px;overflow:auto;border:1px solid #ddd;border-radius:8px;padding:8px;background:#fafafa}
    .msg{margin:8px 0;padding:6px 8px;border-radius:6px;background:#fff;border:1px solid #eee}
    .msg .meta{font-size:12px;color:#666;margin-bottom:4px}
    .msg.new{border-color:#0a7;box-shadow:0 0 0 2px rgba(0,160,120,.08) inset}
    .send{display:flex;gap:6px}
    input[type=text]{flex:1;padding:10px;border-radius:6px;border:1px solid #ccc}
    button{padding:10px 14px;border:0;border-radius:6px;background:#246bff;color:#fff;cursor:pointer}
  </style>
</head>
<body>

<%-- ④ 화면 모델을 data-* 로 내려줌 (JS에서 그대로 읽기) --%>
<div class="wrap" id="app"
     data-ctx="${ctx}"
     data-category="${cat}"
     data-user="${uid}">  <h1>실시간 채팅</h1>
  <p>상태: <span id="statusBadge" class="badge">연결안됨</span></p>

  <div class="panel">
    <div class="list"><ul id="messageList" style="list-style:none;padding:0;margin:0"></ul></div>
    <div>
      <div style="font-size:12px;color:#666;margin-bottom:6px">
        사용자: <b><c:out value="${empty uid ? '게스트' : uid}"/></b>,
        카테고리: <b><c:out value="${cat}"/></b>
      </div>
      <div class="send">
        <input id="messageInput" type="text" placeholder="메시지를 입력하세요" />
        <button id="sendBtn">전송</button>
      </div>
    </div>
  </div>
</div>

<script>
/* ====== ⑤ 컨텍스트 경로 계산 (JSP 미렌더 대비 안전) ====== */
(function () {
  var rendered = '<c:out value="${ctx}"/>';
  window.CTX = rendered && rendered !== '${ctx}' ? rendered : (function(){
    var seg = location.pathname.split('/');
    return seg.length > 1 ? '/' + seg[1] : '';
  })();
})();

/* ====== ⑥ 엔드포인트/프리픽스 ====== */
const WS_ENDPOINT  = CTX + '/realtime-chat';  // SockJS 엔드포인트
const SEND_PREFIX  = '/send';                 // @MessageMapping("/send")
const TOPIC_PREFIX = '/topic';                // convertAndSend("/topic/...")

/* ====== ⑦ 페이지 모델 ====== */
const appEl = document.getElementById('app');
let CATEGORY = Number(appEl.dataset.category || '10');
if (Number.isNaN(CATEGORY) || CATEGORY <= 0) CATEGORY = 10;
const LOGIN_USER = (appEl.dataset.user && appEl.dataset.user.length > 0)
  ? appEl.dataset.user : ('guest-' + Date.now());

/* ====== ⑧ DOM 캐시 ====== */
const $ = s => document.querySelector(s);
const statusBadge = $('#statusBadge');
const messageList = $('#messageList');
const inputEl     = $('#messageInput');
const sendBtn     = $('#sendBtn');

/* ====== ⑨ 유틸 ====== */
function setStatus(on){
  statusBadge.className = 'badge ' + (on ? 'on' : '');
  statusBadge.textContent = on ? '연결됨' : '연결안됨';
}
function escapeHtml(s){
  return (s||'').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;', "'":'&#39;'}[c]));
}
function appendMessage(m,isNew=false){
  const li = document.createElement('li');
  li.className = 'msg' + (isNew ? ' new' : '');
  li.innerHTML =
    '<div class="meta">#'+(m.chatCode!=null?m.chatCode:'-')+' · '+escapeHtml(m.userId||'')+'</div>'+
    '<div class="text">'+escapeHtml(m.message||'')+'</div>';
  messageList.appendChild(li);
  messageList.parentElement.scrollTop = messageList.parentElement.scrollHeight;
}

/* ====== ⑩ 최근 N건 로드(REST) ====== */
async function loadRecent(){
  messageList.innerHTML = '';
  try{
    const url = `${CTX}/chat/recent?category=${CATEGORY}&limit=30`;
    const res = await fetch(url, { headers:{ 'Accept':'application/json' }});
    if(!res.ok) throw new Error('[REST] ' + res.status);
    const data = await res.json();
    data.reverse().forEach(m => appendMessage(m, false));
  }catch(e){ console.error(e); }
}

/* ====== ⑪ STOMP 연결/전송 ====== */
let stomp=null, sub=null;
function connectWS(){
  if(stomp && stomp.connected){ setStatus(true); return; }
  const sock = new SockJS(WS_ENDPOINT);
  stomp = Stomp.over(sock);
  stomp.debug = null;
  stomp.connect({}, () => {
    setStatus(true);
    if(sub){ try{sub.unsubscribe();}catch(_){ } sub=null; }
    sub = stomp.subscribe(`${TOPIC_PREFIX}/chat.${CATEGORY}`,
      f => appendMessage(JSON.parse(f.body), true));
  }, err => { console.error(err); setStatus(false); });
}
function sendMessage(){
  const msg = (inputEl.value||'').trim();
  if(!msg) return;
  if(!stomp || !stomp.connected){ alert('연결이 끊어졌습니다. 새로고침 해주세요.'); return; }
  const dto = { category:CATEGORY, userId:LOGIN_USER, message:msg };
  stomp.send(`${SEND_PREFIX}/send`, {}, JSON.stringify(dto));
  inputEl.value=''; inputEl.focus();
}

/* ====== ⑫ 초기화 ====== */
(async function(){
  await loadRecent();
  connectWS();
  sendBtn.addEventListener('click', sendMessage);
  inputEl.addEventListener('keydown', e => { if(e.key === 'Enter') sendMessage(); });
})();
</script>
</body>
</html>
