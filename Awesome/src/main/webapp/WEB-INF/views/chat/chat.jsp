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
/************************************CHATMESSAGE CSS*******************************************************/
:root { --bg:#fff; --line:#eee; --muted:#888; --btn:#444; --btn-text:#fff; }
* { box-sizing: border-box; }
body { margin:0; font:14px/1.45 -apple-system, BlinkMacSystemFont,"Segoe UI",Roboto,"Noto Sans KR",Arial,"Apple SD Gothic Neo","Malgun Gothic",sans-serif; background:#f7f7f7; color:#222; }

/* ── 채팅 카드(컨테이너) ─────────────────────────────── */
.chat-wrap{
  width: 100%;           /* 부모(사이드바) 폭 100% 활용 */
  max-width: none;       /* max-width 제한 제거 */
  margin: 0;             /* 중앙정렬 여백 제거 (사이드바 안이라 필요 없음) */
  background: var(--bg);
  border-radius: 12px;
  box-shadow: 0 4px 14px rgba(0,0,0,.06);
  display: flex;
  flex-direction: column;
  overflow: hidden;      /* 둥근 모서리 유지용 */
}

/* ── 헤더 ───────────────────────────────────────────── */
.chat-header{
  padding:14px 16px;
  border-bottom:1px solid var(--line);
  display:flex; align-items:center; gap:10px;
}
.chat-title{ font-weight:700; font-size:16px; }
.chat-cat{ margin-left:auto; color:var(--muted); font-size:12px; }

/* ── 메시지 리스트(무한 스크롤 복구 핵심) ───────────── */
.chat-list{
  list-style:none; padding:0; margin:0;
  /* ① 고정 높이 사용하려면: height: 460px; */
  /* ② 화면 높이 기반(권장): */
  max-height: 40vh; /* 높이 조절 */
  overflow-y: auto;
  background:#fff;
}
.chat-item{ display:flex; gap:10px; padding:12px; border-bottom:1px solid var(--line); }
.avatar{ width:36px; height:36px; border-radius:50%; background:#ddd; display:flex; align-items:center; justify-content:center; font-size:12px; color:#555; flex-shrink:0; }
.bubble{ flex:1; min-width:0; }
.meta{ display:flex; align-items:center; gap:8px; font-size:12px; color:var(--muted); }
.meta .uid{ font-weight:600; color:#444; }
.meta .time{ margin-left:2px; }
.meta .report{ margin-left:auto; border:none; background:transparent; cursor:pointer; font-size:12px; color:#d9534f; }
.text{ margin-top:4px; font-size:14px; word-break:break-word; white-space:pre-wrap; }

/* ── 입력 영역 ──────────────────────────────────────── */
.chat-input{
  position:sticky; bottom:0; /* 리스트가 스크롤될 때 하단에 붙도록 */
  display:flex; gap:8px; padding:10px;
  background:#fafafa; border-top:1px solid var(--line);
}
.chat-input input{ flex:1; padding:12px; border:1px solid #ccc; border-radius:8px; outline:none; }
.chat-input button{ padding:12px 16px; border:none; border-radius:8px; background:var(--btn); color:var(--btn-text); cursor:pointer; }
.chat-input button:disabled{ opacity:.5; cursor:not-allowed; }

/* ── 모바일 대응 ────────────────────────────────────── */
@media (max-width: 540px){
  .chat-wrap{ margin: 0; border-radius: 0; height: 100vh; }
  /* 모바일에서는 리스트 높이를 자동으로 꽉 채우도록 */
  .chat-list{ max-height: none; flex: 1 1 auto; }
}


/************************************REPORT CSS*******************************************************/
.rp-overlay{position:fixed;inset:0;background:rgba(0,0,0,.45);display:flex;align-items:center;justify-content:center;z-index:9999;}
.rp-modal{width:min(560px,92vw);max-height:90vh;overflow:auto;background:#fff;border-radius:14px;box-shadow:0 16px 48px rgba(0,0,0,.25);padding:20px 20px 24px;position:relative;}
.rp-close{position:absolute;right:14px;top:10px;border:0;background:transparent;font-size:22px;cursor:pointer}
.rp-title{margin:0 0 10px;font-size:20px;font-weight:700}
.rp-meta{background:#fafafa;border:1px solid #eee;border-radius:10px;padding:10px 12px;margin-bottom:16px}
.rp-msg{margin-top:4px;white-space:pre-wrap;word-break:break-word;color:#444}
.rp-sec-title{margin:8px 0 10px;font-size:14px;color:#666}
.rp-reason{border:1px solid #e5e5e5;border-radius:10px;margin:8px 0;overflow:hidden}
.rp-reason-head{display:flex;align-items:center;gap:10px;padding:12px 14px;cursor:pointer;user-select:none}
.rp-reason-head input{margin-right:6px}
.rp-toggle{margin-left:auto;border:0;background:transparent;cursor:pointer;width:24px;height:24px;position:relative}
.rp-toggle::before{content:none;}
.rp-toggle[aria-expanded="true"]::before{transform:rotate(180deg);top:2px}
.rp-reason-detail{padding:10px 18px 14px;background:#fcfcfc;border-top:1px solid #eee;color:#666}
.rp-reason-detail ul{margin:0;padding-left:18px}
.rp-etc{margin-top:12px}
.rp-etc textarea{width:100%;min-height:80px;border:1px solid #ddd;border-radius:10px;padding:10px;resize:vertical}
.rp-actions{text-align:right;margin-top:14px}
.rp-submit{background:#2563eb;color:#fff;border:0;border-radius:10px;padding:10px 16px;cursor:pointer}

</style>
</head>
<body>
  <div class="chat-wrap" id="chatRoot" 
       data-cp="${CP}" 
       data-category="${CATEGORY}"
     data-logged-in="${sessionScope.loginUser != null}"
     data-user="${sessionScope.loginUser != null ? sessionScope.loginUser.userId : ''}">
    <div class="chat-header">
      <div class="chat-title">채팅창</div>
    </div>

    <ul class="chat-list"></ul>

    <div class="chat-input">
      <input id="msg" type="text" placeholder="내용을 입력하세요." autocomplete="off"
             onkeydown="if(event.key==='Enter') sendMessage()">
      <button id="sendBtn" onclick="sendMessage()">전송</button>
    </div>
  </div>
  
<!-- 신고 모달: 처음엔 숨김 -->
<div id="reportOverlay" class="rp-overlay" style="display:none" aria-hidden="true">
  <div class="rp-modal" role="dialog" aria-modal="true" aria-labelledby="rpTitle">
    <button type="button" class="rp-close" aria-label="닫기" onclick="rpClose()">×</button>

    <h3 id="rpTitle" class="rp-title">신고하기</h3>

    <div class="rp-meta">
      <div><b>작성자</b> <span id="rpAuthor">-</span></div>
      <div><b>내용</b> <div id="rpMessage" class="rp-msg"></div></div>
    </div>

    <h4 class="rp-sec-title">사유선택</h4>



    <form id="rpForm" onsubmit="return false;">
      <!-- 스팸홍보/도배글입니다. -->
      <div class="rp-reason">
        <label class="rp-reason-head">
          <input type="radio" name="reason" value="SPAM">
          <span>스팸홍보/도배글입니다.</span>
          <button type="button" class="rp-toggle" aria-expanded="false">  
          	<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
       	  	   	 fill="currentColor" viewBox="0 0 16 16">
    		<path d="M7.247 11.14 2.451 5.658C1.885 5.013 
            		 2.345 4 3.204 4h9.592a1 1 0 0 1 
             		.753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/>
             </svg>
           </button>
        </label>
        <div class="rp-reason-detail" hidden>
          <ul>
            <li>사행성 오락이나 도박을 홍보하거나 권장하는 내용 등의 부적절한 스팸 홍보 행위</li>
            <li>동일하거나 유사한 내용 반복 게시</li>
          </ul>
        </div>
      </div>

      <!-- 음란물입니다. -->
      <div class="rp-reason">
        <label class="rp-reason-head">
          <input type="radio" name="reason" value="OBSCENITY">
          <span>음란물입니다.</span>
          <button type="button" class="rp-toggle" aria-expanded="false">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
       	  	   	 fill="currentColor" viewBox="0 0 16 16">
    		<path d="M7.247 11.14 2.451 5.658C1.885 5.013 
            		 2.345 4 3.204 4h9.592a1 1 0 0 1 
             		.753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/>
             </svg>
          </button>
        </label>
        <div class="rp-reason-detail" hidden>
          <ul>
            <li>성적 수치심을 일으키는 내용</li>
            <li>아동이나 청소년을 성 대상화한 표현</li>
            <li>과도하거나 의도적인 신체 노출</li>
            <li>음란한 행위와 관련된 부적절한 내용</li>
          </ul>
        </div>
      </div>
      
      <!-- 불법정보를 포함하고 있습니다. -->
      <div class="rp-reason">
        <label class="rp-reason-head">
          <input type="radio" name="reason" value="INJUSTICE">
          <span>불법정보를 포함하고 있습니다.</span>
          <button type="button" class="rp-toggle" aria-expanded="false">
             <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
       	  	   	 fill="currentColor" viewBox="0 0 16 16">
    		<path d="M7.247 11.14 2.451 5.658C1.885 5.013 
            		 2.345 4 3.204 4h9.592a1 1 0 0 1 
             		.753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/>
             </svg>
          </button>
        </label>
        <div class="rp-reason-detail" hidden>
          <ul>
            <li>불법 행위, 불법 링크에 대한 정보 제공</li>
            <li>불법 상품을 판매하거나 유도하는 내용</li>
          </ul>
        </div>
      </div>
      
      <!-- 청소년에게 유해한 내용입니다. -->
      <div class="rp-reason">
        <label class="rp-reason-head">
          <input type="radio" name="reason" value="HARMFUL TO YOUTH">
          <span>청소년에게 유해한 내용입니다.</span>
          <button type="button" class="rp-toggle" aria-expanded="false">
             <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
       	  	   	 fill="currentColor" viewBox="0 0 16 16">
    		<path d="M7.247 11.14 2.451 5.658C1.885 5.013 
            		 2.345 4 3.204 4h9.592a1 1 0 0 1 
             		.753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/>
             </svg>
          </button>
        </label>
        <div class="rp-reason-detail" hidden>
          <ul>
            <li>가출/왕따/학교폭력/자살 등 청소년에게 부정적인 영향을 조성하는 내용</li>
          </ul>
        </div>
      </div>
      
      <!-- 욕설/생명경시/혐오/차별적 표현입니다. -->
      <div class="rp-reason">
        <label class="rp-reason-head">
          <input type="radio" name="reason" value="ABUSE">
          <span>욕설/생명경시/혐오/차별적 표현입니다.</span>
          <button type="button" class="rp-toggle" aria-expanded="false">
          	 <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
       	  	   	 fill="currentColor" viewBox="0 0 16 16">
    		<path d="M7.247 11.14 2.451 5.658C1.885 5.013 
            		 2.345 4 3.204 4h9.592a1 1 0 0 1 
             		.753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/>
             </svg>
          </button>
        </label>
        <div class="rp-reason-detail" hidden>
          <ul>
            <li>직·간접적인 욕설을 사용하여 타인에게 모욕감을 주는 내용</li>
            <li>생명을 경시여기거나 비하하는 내용</li>
            <li>계층/지역/종교/성별 등을 혐오하거나 비하하는 표현</li>
            <li>신체/외모/취향 등을 경멸하는 표현</li>            
          </ul>
        </div>
      </div>
      
      <!-- 개인정보 노출 게시물입니다. -->
      <div class="rp-reason">
        <label class="rp-reason-head">
          <input type="radio" name="reason" value="PERSONAL INFORMATION">
          <span>개인정보 노출 게시물입니다.</span>
          <button type="button" class="rp-toggle" aria-expanded="false">
             <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
       	  	   	 fill="currentColor" viewBox="0 0 16 16">
    		<path d="M7.247 11.14 2.451 5.658C1.885 5.013 
            		 2.345 4 3.204 4h9.592a1 1 0 0 1 
             		.753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/>
             </svg>
          </button>
        </label>
        <div class="rp-reason-detail" hidden>
          <ul>
            <li>법적으로 중요한 타인의 개인정보를 게재</li>
            <li>당사자 동의 없는 특정 개인을 인지할 수 있는 정보</li>          
          </ul>
        </div>
      </div>
      
      <!-- 불쾌한 표현이 있습니다. -->
      <div class="rp-reason">
        <label class="rp-reason-head">
          <input type="radio" name="reason" value="UNPLEASANT">
          <span>개인정보 노출 게시물입니다.</span>
          <button type="button" class="rp-toggle" aria-expanded="false">
             <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
       	  	   	 fill="currentColor" viewBox="0 0 16 16">
    		<path d="M7.247 11.14 2.451 5.658C1.885 5.013 
            		 2.345 4 3.204 4h9.592a1 1 0 0 1 
             		.753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/>
             </svg>
          </button>
        </label>
        <div class="rp-reason-detail" hidden>
          <ul>
            <li>불쾌한 표현 포함 (해당 사유는 클린봇 학습에 도움이 될 수 있습니다.)</li>        
          </ul>
        </div>
      </div>

      <!-- 기타사항 (선택) -->
      <div class="rp-etc">
       <input type="radio" name="reason" value="OTHER MATTERS">      
        <label for="rpEtc">기타사항</label>
        <textarea id="rpEtc" placeholder="기타 사유를 입력하세요. (선택)"></textarea>
      </div>

      <div class="rp-actions">
        <button type="button" class="rp-submit" onclick="rpSubmit()">신고하기</button>
      </div>
    </form>
  </div>
</div>


  <!-- SockJS/STOMP (CDN) -->
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<script>
// ===== 1) 전역 가드: 중복 초기화 방지 =====
if (!window.__chatInit) {
  window.__chatInit = true;

  // ===== 2) 루트 & 도우미 =====
  const ROOT = document.getElementById('chatRoot');              // ★ 이 안에서만 DOM 조회
  const qs  = (sel) => ROOT ? ROOT.querySelector(sel) : null;
  const qsa = (sel) => ROOT ? ROOT.querySelectorAll(sel) : [];

  // 환경
  const CP        = ROOT?.getAttribute('data-cp') || '';
  const CATEGORY  = parseInt(ROOT?.getAttribute('data-category') || '10', 10);
  const CSRF_H    = (document.querySelector('meta[name="_csrf_header"]')||{}).content;
  const CSRF_T    = (document.querySelector('meta[name="_csrf"]')||{}).content;

  // 로그인 여부(세션으로 data-logged-in 주입했다면 그걸 쓰고, 아니라면 버튼 상태로 대체)
  const LOGGED_IN = (ROOT?.getAttribute('data-logged-in') === 'true') ||
                    !!qs('#sendBtn'); // 페이지 구조에 맞게 필요시 조정

  // UI 캐시
  const $list    = qs('.chat-list');
  const $input   = qs('#msg');
  const $sendBtn = qs('#sendBtn');

  if ($sendBtn && $input && !LOGGED_IN) {
    $sendBtn.disabled = true;
    $input.disabled   = true;
    $input.placeholder = '로그인 후 이용 가능합니다.';
  }

  // ===== 3) STOMP 연결 상태 =====
  let stomp        = null;
  let subscription = null;
  let connecting   = false;

  function safeUnsubscribe() {
    try { if (subscription && subscription.id) subscription.unsubscribe(); }
    catch(e) {}
    subscription = null;
  }

  function safeDisconnect() {
    try { if (stomp && stomp.connected) stomp.disconnect(() => {}); }
    catch(e) {}
    stomp = null;
  }

  // ===== 4) 연결 & 구독 =====
  function connectWS() {
    if (connecting || (stomp && stomp.connected)) return;
    connecting = true;

    const sock = new SockJS(CP + '/ws-chat');
    stomp = Stomp.over(sock);
    stomp.debug = null; // 필요하면 주석 처리하여 디버그

    stomp.connect({}, () => {
      connecting = false;

      // 구독 1개만 유지
      safeUnsubscribe();
      subscription = stomp.subscribe('/topic/chat/' + CATEGORY, frame => {
        try {
          const m = JSON.parse(frame.body);
          appendMessage(m);
        } catch (e) {
          console.error('parse error', e);
        }
      });

      // 초기 최근 N개
      fetch(CP + '/chat/recent?category=' + CATEGORY + '&size=30', {credentials:'same-origin'})
        .then(r => r.json())
        .then(list => { list.reverse().forEach(appendMessage); })
        .catch(console.error);

      if ($sendBtn && LOGGED_IN) $sendBtn.disabled = false;
    }, err => {
      console.error('STOMP error:', err);
      connecting = false;
      if ($sendBtn) $sendBtn.disabled = true;
      // 재연결 로직을 원하면 지수 백오프 등으로 재시도 가능
    });
  }

  // ===== 5) 메시지 전송 =====
  function sendMessage() {
    if (!LOGGED_IN) { alert('로그인 후 이용해 주세요.'); return; }
    if (!stomp || !stomp.connected) return;
    if (!$input) return;

    const text = ($input.value || '').trim();
    if (!text) return;

    const payload = { message: text };
    stomp.send('/app/send/' + CATEGORY, {}, JSON.stringify(payload));
    $input.value = '';
    $input.focus();
  }
  window.sendMessage = sendMessage; // 버튼/엔터에서 호출

  // 엔터 전송
  if ($input) {
    $input.addEventListener('keydown', e => {
      if (e.key === 'Enter') sendMessage();
    });
  }
  if ($sendBtn) {
    $sendBtn.addEventListener('click', sendMessage);
  }

  // ===== 6) 렌더링 =====
  function escHtml(s){ const d=document.createElement('div'); d.innerText = (s==null?'':String(s)); return d.innerHTML; }
  function pad2(n){ n = +n; return (n<10?'0':'') + n; }
  function fmt(dt){
    try{
      if(!dt) return '';
      const d = new Date(dt);
      if (isNaN(d)) return String(dt);
      return d.getFullYear()+'.'+pad2(d.getMonth()+1)+'.'+pad2(d.getDate())+' '+pad2(d.getHours())+':'+pad2(d.getMinutes());
    }catch(e){ return String(dt||''); }
  }

  function appendMessage(m) {
    if (!$list) return;

    const li = document.createElement('li');
    li.className   = 'chat-item';
    li.dataset.code = m.chatCode || 0;
    li.dataset.uid  = m.userId   || 'user***';
    li.dataset.text = m.message  || '';

    li.innerHTML =
      '<div class="avatar">'+escHtml((li.dataset.uid.charAt(0)||'u'))+'</div>'+
      '<div class="bubble">'+
        '<div class="meta">'+
          '<span class="uid">'+escHtml(li.dataset.uid)+'</span>'+
          '<span class="time">'+escHtml(fmt(m.sendDt))+'</span>'+
          '<button class="report" title="신고">🚨 신고</button>'+
        '</div>'+
        '<div class="text">'+escHtml(li.dataset.text)+'</div>'+
      '</div>';

    // 신고 버튼 핸들러(버블 내부에서만 scope)
    const btn = li.querySelector('.report');
    if (btn) btn.addEventListener('click', () => openReportFrom(li));

    $list.appendChild(li);
    // 보이는 리스트에 스크롤
    $list.scrollTop = $list.scrollHeight;
  }

  // ===== 7) 신고 모달(옵션) =====
  function openReportFrom(li){
    const ov = qs('#reportOverlay');
    if (!ov || !li) return;

    ov.style.display = 'flex';
    ov.setAttribute('aria-hidden','false');
    ov.dataset.chatCode = li.dataset.code;

    const $author  = qs('#rpAuthor');
    const $message = qs('#rpMessage');
    if ($author)  $author.textContent  = li.dataset.uid || '-';
    if ($message) $message.textContent = li.dataset.text || '';

    // 초기화
    qsa('#rpForm input[name="reason"]').forEach(r => r.checked = false);
    const etc = qs('#rpEtc'); if (etc) etc.value = '';
    qsa('.rp-reason-detail').forEach(d => d.hidden = true);
    qsa('.rp-toggle').forEach(b => b.setAttribute('aria-expanded','false'));
  }
  window.rpClose = function(){
    const ov = qs('#reportOverlay');
    if (!ov) return;
    ov.style.display = 'none';
    ov.setAttribute('aria-hidden','true');
  };
  window.rpSubmit = async function(){
    const ov = qs('#reportOverlay');
    if (!ov) return;

    const chatCode = parseInt(ov.dataset.chatCode||'0',10);
    const reason   = (qs('#rpForm input[name="reason"]:checked')||{}).value;
    const etc      = (qs('#rpEtc')||{}).value?.trim?.() || '';

    if (!LOGGED_IN) { alert('로그인 후 신고 가능합니다.'); return; }
    if (!chatCode)  { alert('대상 메시지 코드가 없습니다.'); return; }
    if (!reason)    { alert('사유를 선택해 주세요.'); return; }

    const headers = {'Content-Type':'application/json'};
    if (CSRF_H && CSRF_T) headers[CSRF_H] = CSRF_T;

    try {
      const r = await fetch(CP + '/report', {
        method:'POST', headers, credentials:'same-origin',
        body: JSON.stringify({ chatCode, reason, reasonDetail: etc })
      });
      const res = await r.json().catch(()=>({}));
      alert(res?.message || (res?.ok ? '신고가 접수되었습니다.' : '신고 실패'));
      if (res?.ok) window.rpClose();
    } catch (e) {
      console.error(e); alert('전송 오류');
    }
  };

  // 토글(접힘/펼침) – 이벤트 위임
  ROOT.addEventListener('click', e => {
    const head = e.target.closest('.rp-reason-head');
    if (!head || !ROOT.contains(head)) return;
    const box = head.parentElement;
    const detail = box.querySelector('.rp-reason-detail');
    const toggle = box.querySelector('.rp-toggle');
    const expanded = toggle.getAttribute('aria-expanded') === 'true';
    toggle.setAttribute('aria-expanded', String(!expanded));
    detail.hidden = expanded;
    const r = head.querySelector('input[type="radio"]'); if (r) r.checked = true;
  });

  // ===== 8) 생명주기 =====
  document.addEventListener('DOMContentLoaded', connectWS);
  window.addEventListener('beforeunload', () => {
    safeUnsubscribe();
    safeDisconnect();
    window.__chatInit = false;
  });
}
</script>


</body>
</html>
