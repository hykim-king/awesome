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
:root { --bg:#ffffff; --line:#eee; --muted:#888; --btn:#444; --btn-text:#fff; }
* { box-sizing: border-box; }
body { margin:0; font:14px/1.45 -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Noto Sans KR", Arial, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif; background:#f7f7f7; color:#222; }

.chat-wrap { max-width: none; width:420px; margin: 24px auto; background:var(--bg); border-radius:12px; box-shadow:0 4px 14px rgba(0,0,0,.06); overflow:hidden; }
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

    <ul id="chatList" class="chat-list"></ul>

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
/* ------------------- 공통 환경 ------------------- */
(function initGlobals(){
  const root = document.getElementById('chatRoot');
  window.CP = root ? (root.getAttribute('data-cp') || '') : '';
  window.CATEGORY = root ? parseInt(root.getAttribute('data-category') || '10', 10) : 10;
  window.LOGGED_IN = !!(root && root.getAttribute('data-logged-in') === 'true');

  // 로그인 아니면 전송 비활성화 & 안내 문구
  const sendBtn = document.getElementById('sendBtn');
  const msg = document.getElementById('msg');
  if (!LOGGED_IN) {
    sendBtn.disabled = true;
    msg.disabled = true;
    msg.placeholder = '로그인 후 이용 가능합니다.';
  }
})();

const CSRF_HEADER = (document.querySelector('meta[name="_csrf_header"]')||{}).content;
const CSRF_TOKEN  = (document.querySelector('meta[name="_csrf"]')||{}).content;

/* ------------------- WebSocket ------------------- */
let stomp = null;
let connected = false;
let connecting = false;
let subscription = null;

function safeSubscribe(){
  try { if (subscription && subscription.id) subscription.unsubscribe(); } catch(e){}
  subscription = stomp.subscribe("/topic/chat/" + CATEGORY, function(frame){
    appendMessage(JSON.parse(frame.body));
  });
}

function connectWS(){
  if (connecting || (stomp && stomp.connected)) return;
  connecting = true;

  const sock = new SockJS(CP + "/ws-chat");
  stomp = Stomp.over(sock);
  stomp.debug = null;

  stomp.connect({}, function(){
    connected = true; connecting = false;
    if (LOGGED_IN) document.getElementById('sendBtn').disabled = false;

    safeSubscribe();

    fetch(CP + "/chat/recent?category=" + CATEGORY + "&size=30", {credentials:'same-origin'})
      .then(r => r.json())
      .then(list => list.reverse().forEach(appendMessage))
      .catch(console.error);
  }, function(err){
    console.error("STOMP error:", err);
    connected = false; connecting = false;
    document.getElementById('sendBtn').disabled = true;
  });
}

/* ------------------- 채팅 보내기 ------------------- */
function sendMessage(){
  if(!LOGGED_IN){ alert('로그인 후 이용해 주세요.'); return; }
  const input = document.getElementById('msg');
  const text = (input.value || '').trim();
  if(!text || !connected) return;

  const payload = { message: text };
  stomp.send("/app/send/" + CATEGORY, {}, JSON.stringify(payload));
  input.value = '';
  input.focus();
}
window.sendMessage = sendMessage;

/* ------------------- 렌더링 ------------------- */
function escHtml(s){ const d=document.createElement('div'); d.innerText = (s==null?'':String(s)); return d.innerHTML; }
function pad2(n){ n = +n; return (n<10?'0':'')+n; }
function fmt(dt){
  try{
    if(!dt) return '';
    const d = new Date(dt);
    if(isNaN(d)) return String(dt);
    return d.getFullYear()+'.'+pad2(d.getMonth()+1)+'.'+pad2(d.getDate())+' '+pad2(d.getHours())+':'+pad2(d.getMinutes());
  }catch(e){ return String(dt||''); }
}

function appendMessage(m){
  const li = document.createElement('li');
  li.className = 'chat-item';
  li.dataset.code = m.chatCode || 0;
  li.dataset.uid  = m.userId   || 'user***';
  li.dataset.text = m.message  || '';

  const html =
    '<div class="avatar">'+escHtml((li.dataset.uid.charAt(0)||'u'))+'</div>'+
    '<div class="bubble">'+
      '<div class="meta">'+
        '<span class="uid">'+escHtml(li.dataset.uid)+'</span>'+
        '<span class="time">'+escHtml(fmt(m.sendDt))+'</span>'+
        '<button class="report" onclick="openReportFrom(this)" title="신고">🚨 신고</button>'+
      '</div>'+
      '<div class="text">'+escHtml(li.dataset.text)+'</div>'+
    '</div>';
  li.innerHTML = html;

  const list = document.getElementById('chatList');
  list.appendChild(li);
  li.scrollIntoView({behavior:'smooth', block:'end'});
}

/* ------------------- 신고 모달 ------------------- */
function openReportFrom(btn){
  const li = btn.closest('.chat-item');
  if(!li) return;

  const chatCode = parseInt(li.dataset.code||'0',10);
  const author   = li.dataset.uid || '-';
  const message  = li.dataset.text || '';

  const ov = document.getElementById('reportOverlay');
  ov.style.display = 'flex';
  ov.setAttribute('aria-hidden','false');
  ov.dataset.chatCode = String(chatCode);

  document.getElementById('rpAuthor').textContent  = author;
  document.getElementById('rpMessage').textContent = message;

  document.querySelectorAll('#rpForm input[name="reason"]').forEach(r=>r.checked=false);
  document.getElementById('rpEtc').value = '';
  document.querySelectorAll('.rp-reason-detail').forEach(d=>d.hidden=true);
  document.querySelectorAll('.rp-toggle').forEach(b=>b.setAttribute('aria-expanded','false'));
}
window.openReportFrom = openReportFrom;

function rpClose(){
  const ov = document.getElementById('reportOverlay');
  ov.style.display = 'none';
  ov.setAttribute('aria-hidden','true');
}
window.rpClose = rpClose;

document.addEventListener('click', function(e){
  const head = e.target.closest('.rp-reason-head');
  if(!head) return;
  const box = head.parentElement;
  const detail = box.querySelector('.rp-reason-detail');
  const toggle = box.querySelector('.rp-toggle');
  const expanded = toggle.getAttribute('aria-expanded') === 'true';
  toggle.setAttribute('aria-expanded', String(!expanded));
  detail.hidden = expanded;
  const r = head.querySelector('input[type="radio"]'); if(r) r.checked = true;
});

async function rpSubmit(){
  const ov = document.getElementById('reportOverlay');
  const chatCode = parseInt(ov.dataset.chatCode||'0',10);
  const reason   = document.querySelector('#rpForm input[name="reason"]:checked')?.value;
  const etc      = document.getElementById('rpEtc').value.trim();

  if(!LOGGED_IN){ alert('로그인 후 신고 가능합니다.'); return; }
  if(!chatCode){ alert('대상 메시지 코드가 없습니다.'); return; }
  if(!reason){   alert('사유를 선택해 주세요.'); return; }

  const headers = {'Content-Type':'application/json'};
  if (CSRF_HEADER && CSRF_TOKEN) headers[CSRF_HEADER] = CSRF_TOKEN;

  const r = await fetch(CP + '/report', {
    method:'POST',
    headers, credentials:'same-origin',
    body: JSON.stringify({ chatCode, reason, reasonDetail: etc })
  }).catch(e => { console.error(e); alert('전송 오류'); });
  if(!r) return;

  const res = await r.json().catch(()=>({}));
  alert(res?.message || (res?.ok ? '신고가 접수되었습니다.' : '신고 실패'));
  if(res?.ok) rpClose();
}
window.rpSubmit = rpSubmit;

/* ------------------- 생명주기 ------------------- */
document.addEventListener('DOMContentLoaded', connectWS);
window.addEventListener('beforeunload', function(){
  try { if (subscription && subscription.id) subscription.unsubscribe(); } catch(e){}
  try { if (stomp && stomp.connected) stomp.disconnect(function(){}); } catch(e){}
});
</script>

</body>
</html>
