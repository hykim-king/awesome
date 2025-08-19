<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>실시간 채팅</title>

  <!-- ✅ 지금은 HTML 골격만. JS/CSS는 다음 단계에서 추가 -->
  <!-- ✅ ctx: /ehr 같은 컨텍스트루트. JS에서 ${ctx}로 참조 가능 -->
</head>

 <!-- 페이지 전역 데이터(카테고리, 로그인 유저)를 data-* 로 내려줌 -->
  <div id="app"
       data-category="${category}"
       data-user="${loginUserId}">
  </div>

  <div class="chat-wrap">
    <header class="chat-header">
      <h1>실시간 채팅</h1>
      <!-- 상태표시만 남김 -->
      <span id="statusBadge" class="badge off">연결안됨</span>
    </header>

    <main class="chat-main">
      <ul id="messageList" class="messages"></ul>
    </main>

    <footer class="chat-footer">
      <input id="messageInput" type="text" placeholder="메시지를 입력하고 Enter" />
      <button id="sendBtn" type="button">전송</button>
    </footer>
  </div>

  <!-- 로그인 필요 오버레이 (로그인 안됐을 때 노출) -->
  <div id="needLogin" class="need-login" style="display:none">
    <p>채팅은 로그인 후 이용 가능합니다.</p>
    <a href="${ctx}/member/login.do">로그인 하러가기</a>
  </div>
  
  <!-- CDN -->
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<script>
// ===========================
// 0) 컨텍스트/엔드포인트 상수
// ===========================
const CTX_FROM_JSP = '${ctx}';
const CTX = (CTX_FROM_JSP && CTX_FROM_JSP !== '${ctx}')
  ? CTX_FROM_JSP
  : (() => {
      const seg = location.pathname.split('/');
      return seg.length > 1 ? ('/' + seg[1]) : '';
    })();

const WS_ENDPOINT  = CTX + '/realtime-chat'; // SockJS 엔드포인트
const SEND_DEST    = '/send';                // @MessageMapping("/send")
const TOPIC_PREFIX = '/topic';               // simple-broker prefix

// ===========================
// 1) 페이지 데이터 (안전 주입)
// ===========================
// (선택) JSP에서 전역 변수로 내려오는 경우 사용
const CATEGORY_FROM_JSP   = (typeof CATEGORY !== 'undefined') ? CATEGORY : null;
const LOGIN_USER_FROM_JSP = (typeof LOGIN_USER !== 'undefined') ? LOGIN_USER : null;

// (대안) #app data- 속성에서 읽기
const appEl = document.getElementById('app');
const CATEGORY_FROM_DATA   = appEl?.dataset?.category ? Number(appEl.dataset.category) : null;
const LOGIN_USER_FROM_DATA = appEl?.dataset?.user || null;

// 최종 결정 (JSP > data-* > fallback)
const CATEGORY_FINAL   = (CATEGORY_FROM_JSP   ?? CATEGORY_FROM_DATA ?? 10);
const LOGIN_USER_FINAL = (LOGIN_USER_FROM_JSP ?? LOGIN_USER_FROM_DATA ?? ('guest-' + Date.now()));

// ===========================
// 2) DOM
// ===========================
const $ = (sel) => document.querySelector(sel);
const statusBadge = $('#statusBadge');
const messageList = $('#messageList');
const inputEl     = $('#messageInput');
const sendBtn     = $('#sendBtn');

// ===========================
// 3) STOMP
// ===========================
let stomp = null, sub = null;

function setStatus(on){
  if(!statusBadge) return;
  statusBadge.className   = 'badge ' + (on ? 'on' : 'off');
  statusBadge.textContent = on ? '연결됨' : '연결안됨';
}

function escapeHtml(s){
  return (s || '').replace(/[&<>"']/g, (c) => ({
    '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'
  }[c]));
}

function appendMessage(dto, isNew=false){
  if(!messageList) return;
  const li = document.createElement('li');
  li.className = 'msg' + (isNew ? ' new' : '');
  li.innerHTML =
    `<div class="meta">#${dto.chatCode ?? '-'} · ${escapeHtml(dto.userId || '')}</div>
     <div class="text">${escapeHtml(dto.message || '')}</div>`;
  messageList.appendChild(li);
  messageList.parentElement.scrollTop = messageList.parentElement.scrollHeight;
}

async function loadRecent(){
  if(!messageList) return;
  messageList.innerHTML = '';
  try{
    const url = `${CTX}/chat/recent?category=${CATEGORY_FINAL}&limit=30`;
    const res = await fetch(url, { headers: { 'Accept': 'application/json' }});
    if(!res.ok) throw new Error('HTTP ' + res.status);
    const data = await res.json();
    data.reverse().forEach(m => appendMessage(m, false));
  }catch(e){
    console.error('[REST] loadRecent error:', e);
  }
}

function connectWS(){
  if(stomp?.connected){ setStatus(true); return; }

  console.log('[WS] endpoint =', WS_ENDPOINT);
  const sock = new SockJS(WS_ENDPOINT);
  stomp = Stomp.over(sock);
  stomp.debug = null; // 필요시 로그 보고 싶으면 주석 해제

  stomp.connect({/* headers */}, () => {
    setStatus(true);

    // 구독 재설정
    if(sub){ try{sub.unsubscribe();}catch(_){}; sub = null; }
    const dest = `${TOPIC_PREFIX}/chat.${CATEGORY_FINAL}`;
    console.log('[WS] subscribe ->', dest);
    sub = stomp.subscribe(dest, (frame) => {
      const dto = JSON.parse(frame.body);
      appendMessage(dto, true);
    });

  }, (err) => {
    console.error('[WS] connect error:', err);
    setStatus(false);
  });
}

function sendMessage(){
  const msg = (inputEl?.value || '').trim();
  if(!msg) return;

  if(!stomp?.connected){
    alert('연결이 끊어졌습니다. 새로고침 해주세요.');
    return;
  }

  const dto = {
    category: CATEGORY_FINAL,
    userId:   LOGIN_USER_FINAL,
    message:  msg
  };

  console.log('[WS] send ->', SEND_DEST, dto);
  stomp.send(SEND_DEST, {}, JSON.stringify(dto)); // ★ '/send' 로 보냄

  inputEl.value = '';
  inputEl.focus();
}

// ===========================
// 4) 초기화
// ===========================
(function init(){
  console.log('[INIT] CTX=', CTX, 'CAT=', CATEGORY_FINAL, 'USER=', LOGIN_USER_FINAL);
  loadRecent();   // 최근 메시지 불러오기(REST)
  connectWS();    // 소켓 연결
  sendBtn?.addEventListener('click', sendMessage);
  inputEl?.addEventListener('keydown', e => { if(e.key === 'Enter') sendMessage(); });
})();
</script>

  
</body>
</html>
