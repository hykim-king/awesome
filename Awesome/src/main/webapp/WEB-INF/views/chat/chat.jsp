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


/************************************REPORT CSS*******************************************************/
/* 오버레이 */
.rp-overlay{position:fixed;inset:0;background:rgba(0,0,0,.45);display:flex;align-items:center;justify-content:center;z-index:9999;}
/* 모달 */
.rp-modal{width:min(560px,92vw);max-height:90vh;overflow:auto;background:#fff;border-radius:14px;box-shadow:0 16px 48px rgba(0,0,0,.25);padding:20px 20px 24px;}
.rp-close{position:absolute;right:14px;top:10px;border:0;background:transparent;font-size:22px;cursor:pointer}
.rp-title{margin:0 0 10px;font-size:20px;font-weight:700}
.rp-meta{background:#fafafa;border:1px solid #eee;border-radius:10px;padding:10px 12px;margin-bottom:16px}
.rp-msg{margin-top:4px;white-space:pre-wrap;word-break:break-word;color:#444}
.rp-sec-title{margin:8px 0 10px;font-size:14px;color:#666}
/* 사유 카드 */
.rp-reason{border:1px solid #e5e5e5;border-radius:10px;margin:8px 0;overflow:hidden}
.rp-reason-head{display:flex;align-items:center;gap:10px;padding:12px 14px;cursor:pointer;user-select:none}
.rp-reason-head input{margin-right:6px}
.rp-toggle{margin-left:auto;border:0;background:transparent;cursor:pointer;width:24px;height:24px;position:relative}
.rp-toggle::before{content:"";position:absolute;inset:0;margin:auto;border:6px solid transparent;border-top-color:#888;top:8px;transition:transform .2s}
.rp-toggle[aria-expanded="true"]::before{transform:rotate(180deg);top:2px}
.rp-reason-detail{padding:10px 18px 14px;background:#fcfcfc;border-top:1px solid #eee;color:#666}
.rp-reason-detail ul{margin:0;padding-left:18px}
.rp-etc{margin-top:12px}
.rp-etc textarea{width:100%;min-height:80px;border:1px solid #ddd;border-radius:10px;padding:10px;resize:vertical}
.rp-actions{text-align:right;margin-top:14px}
.rp-submit{background:#2563eb;color:#fff;border:0;border-radius:10px;padding:10px 16px;cursor:pointer}

}
</style>
</head>
<body>
  <div class="chat-wrap" id="chatRoot" 
       data-cp="${CP}" 
       data-category="${CATEGORY}"
       data-logged-in="${not empty sessionScope.USER_ID}">
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
      <!-- ✅ [예시 1건] 스팸홍보/도배글입니다. -->
      <div class="rp-reason">
        <label class="rp-reason-head">
          <input type="radio" name="reason" value="SPAM">
          <span>스팸홍보/도배글입니다.</span>
          <button type="button" class="rp-toggle" aria-expanded="false"></button>
        </label>
        <div class="rp-reason-detail" hidden>
          <ul>
            <li>사행성 오락이나 도박을 홍보하거나 권장하는 내용 등의 부적절한 스팸 홍보 행위</li>
            <li>동일하거나 유사한 내용 반복 게시</li>
          </ul>
        </div>
      </div>

      <!-- (여기에 동일 패턴으로 다른 항목들을 추가) -->

      <!-- 기타사항 (선택) -->
      <div class="rp-etc">
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
        +     '<button class="report" onclick="openReport(this)" title="신고">🚨 신고</button>'
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
  
    //모달 상태 저장
  var __rp = { chatCode: 0, writer: '', msg: '' };

  window.openReport = function(btn){
    var li = btn.closest('.chat-item');
    if(!li) return;

    __rp.chatCode = parseInt(li.dataset.code || '0', 10);
    __rp.writer   = li.dataset.uid  || 'user***';
    __rp.msg      = li.dataset.text || '';

    document.getElementById('rpWriter').textContent = __rp.writer;
    document.getElementById('rpMsg').textContent    = __rp.msg;

    // 선택 초기화
    Array.prototype.forEach.call(document.getElementsByName('rpReason'), function(r){ r.checked=false; });
    document.getElementById('rpOther').value = '';

    document.getElementById('reportModal').style.display = 'flex';
  };

  window.closeReport = function(){
    document.getElementById('reportModal').style.display = 'none';
  };

  window.closeDone = function(){
    document.getElementById('reportDone').style.display = 'none';
  };

  // 신고 제출
  window.submitReport = function(){
    if(!__rp.chatCode){ alert("대상 메시지 정보가 없습니다."); return; }

    var selected = null;
    var radios = document.getElementsByName('rpReason');
    for (var i=0;i<radios.length;i++) if (radios[i].checked) { selected = radios[i].value; break; }

    if(!selected){ alert("신고 사유를 선택하세요."); return; }

    var otherText = document.getElementById('rpOther').value.trim();
    var reasonPayload = (selected === 'OTHER' && otherText) ? ('OTHER | ' + otherText) : selected;

    var headers = {'Content-Type':'application/json'};
    if (CSRF_HEADER && CSRF_TOKEN) headers[CSRF_HEADER] = CSRF_TOKEN;

    // 서버: /report  (ReportController#create)
    fetch(CP + "/report", {
      method: "POST",
      headers: headers,
      credentials: "same-origin",
      body: JSON.stringify({
        chatCode: __rp.chatCode,
        reason:   reasonPayload
      })
    })
    .then(function(r){ return r.json(); })
    .then(function(res){
      closeReport();
      document.getElementById('doneWriter').textContent = __rp.writer;
      document.getElementById('doneMsg').textContent    = __rp.msg;
      document.getElementById('reportDone').style.display = 'flex';
      if(res && res.message){ console.log(res.message); }
    })
    .catch(function(err){
      console.error(err);
      alert("신고 전송 중 오류가 발생했습니다.");
    });
  };
  
//모달 열기: 채팅 항목의 신고 버튼에서 호출
  function openReport(chatCode, author, message){
	ensureReportModal(); 
    const ov = document.getElementById('reportOverlay');
    ov.style.display = 'flex';
    ov.setAttribute('aria-hidden','false');

    // 메타 채우기 + chatCode 보관
    document.getElementById('rpAuthor').textContent = author || '-';
    document.getElementById('rpMessage').textContent = message || '';
    ov.dataset.chatCode = String(chatCode||0);

    // 라디오/아코디언 초기화
    document.querySelectorAll('#rpForm input[name="reason"]').forEach(r => r.checked = false);
    document.getElementById('rpEtc').value = '';
    document.querySelectorAll('.rp-reason-detail').forEach(d => d.hidden = true);
    document.querySelectorAll('.rp-toggle').forEach(b => b.setAttribute('aria-expanded','false'));
  }

  // 닫기
  function rpClose(){
  const ov = document.getElementById('reportOverlay');
  if(!ov) return;
  ov.style.display = 'none';
  ov.setAttribute('aria-hidden','true');
  }

  // 아코디언: title 영역 어디를 눌러도 열리게 위임
  document.addEventListener('click', function(e){
  const head = e.target.closest('.rp-reason-head');
  if(!head) return;
  const box = head.parentElement;
  const detail = box.querySelector('.rp-reason-detail');
  const toggle = box.querySelector('.rp-toggle');
  const expanded = toggle.getAttribute('aria-expanded') === 'true';
  toggle.setAttribute('aria-expanded', String(!expanded));
  detail.hidden = expanded;
  const r = head.querySelector('input[type="radio"]');
  if(r) r.checked = true;
});

  // 전송
async function rpSubmit(){
  const ov = document.getElementById('reportOverlay');
  const chatCode = parseInt(ov?.dataset.chatCode || '0', 10);
  const reason   = document.querySelector('#rpForm input[name="reason"]:checked')?.value;
  const etc      = (document.getElementById('rpEtc')?.value || '').trim();
  if(!chatCode){ alert('대상 메시지 코드가 없습니다.'); return; }
  if(!reason){   alert('사유를 선택해 주세요.'); return; }

  const headers = {'Content-Type':'application/json'};
  const h = document.querySelector('meta[name="_csrf_header"]')?.content;
  const t = document.querySelector('meta[name="_csrf"]')?.content;
  if (h && t) headers[h] = t;

  const payload = { chatCode, reason, reasonDetail: etc };

  const r = await fetch(CP + '/report', {
    method: 'POST',
    headers,
    credentials: 'same-origin',
    body: JSON.stringify(payload)
  }).catch(err => { console.error(err); alert('전송 오류'); });
  if(!r) return;

  const res = await r.json().catch(()=>({}));
  alert(res?.message || (res?.ok ? '신고가 접수되었습니다.' : '신고 실패'));
  if(res?.ok) rpClose();
}
</script>

</body>
</html>
