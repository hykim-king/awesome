<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>회원가입</title>

  <style>
    :root{
      --bg:#f7fafc;
      --card:#ffffff;
      --text:#0f172a;
      --muted:#6b7280;
      --line:#e5e7eb;
      --green:#84cc16;     /* 라임빛 초록(두 번째 스샷 느낌) */
      --green-dark:#65a30d;
      --input:#f9fafb;
    }
    *{box-sizing:border-box}
    body{
      margin:0;
      background:var(--bg);
      color:var(--text);
      font-family: "Inter", "Pretendard", system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", sans-serif;
    }
    .wrap{
      max-width: 360px;
      margin: 48px auto;
      padding: 28px 22px;
      background:var(--card);
      border-radius: 16px;
      box-shadow: 0 10px 30px rgba(15,23,42,.08);
    }
    h1{
      font-size: 22px;
      font-weight: 800;
      text-align: center;
      margin: 6px 0 22px;
    }

    .group{ margin-bottom: 14px; }
    label{
      display:block;
      font-size: 13px;
      font-weight: 700;
      margin: 2px 0 8px;
    }
    .row{
      display:flex; gap:10px; align-items:center;
    }
    input[type="text"],
    input[type="password"],
    input[type="email"],
    input[type="date"]{
      width:100%;
      height:44px;
      padding:0 12px;
      border:1px solid var(--line);
      background:var(--input);
      border-radius:10px;
      outline:none;
      transition: .15s ease;
      font-size:14px;
    }
    input:focus{
      border-color:var(--green);
      box-shadow:0 0 0 4px color-mix(in srgb, var(--green) 20%, transparent);
      background:#fff;
    }

    .btn{
      height:44px;
      padding:0 14px;
      border:0;
      background:var(--green);
      color:#fff;
      border-radius:10px;
      font-size:14px;
      font-weight:700;
      cursor:pointer;
      transition: .15s ease;
      white-space:nowrap;
    }
    .btn:hover{ background:var(--green-dark); }

    .btn-ghost{
      background:#eef6d0;
      color:#3f6212;
    }
    .btn-ghost:hover{
      background:#e3f0b3;
    }

    .hint{
      font-size:12px; color:var(--muted); margin-top:6px;
    }

    .checks{ margin: 8px 0 2px; }
    .checks label{
      display:flex; gap:10px; align-items:center;
      font-size:14px; font-weight:600; color:#111827;
      margin:10px 0;
    }
    .checks input[type="checkbox"]{
      width:18px; height:18px; accent-color:var(--green);
    }

    .submit{
      margin-top: 16px;
      width:100%;
      height:48px;
      font-size:15px;
      border-radius:12px;
    }

    .msg{ font-size:12px; margin-top:6px; }
    .msg.ok{ color:#15803d; }
    .msg.err{ color:#b91c1c; }
  
  
  /* ---- modal ---- */
.modal{position:fixed; inset:0; display:none; align-items:center; justify-content:center; z-index:1000;}
.modal.open{display:flex;}
.modal .backdrop{position:absolute; inset:0; background:rgba(0,0,0,.45);}
.modal .panel{
  position:relative; max-width:640px; width:calc(100% - 32px);
  max-height:80vh; overflow:auto; background:var(--card);
  border-radius:16px; padding:20px; box-shadow:0 20px 50px rgba(0,0,0,.2)
}
.modal .close{
  position:absolute; top:10px; right:12px; border:0; background:transparent;
  font-size:22px; cursor:pointer; line-height:1;
}
.modal h2{margin:0 0 10px; font-size:18px}
.modal .content{font-size:14px; color:#334155}

/* 약관 링크(글자 클릭) 스타일 */
.checks .link{
  margin-left:8px; color:#2563eb; text-decoration:underline; cursor:pointer;
}
.checks .term{ user-select:none; }
  
  
  
  
  
  </style>
</head>
<body>
  <div class="wrap">
    <h1>회원가입</h1>

    <form id="joinForm" method="post" action="<c:url value='/member/register.do'/>">
      <!-- 아이디 -->
      <div class="group">
        <label for="userId">아이디 *</label>
        <div class="row">
          <input id="userId" name="userId" type="text" required />
          <button id="btnIdCheck" type="button" class="btn btn-ghost">중복확인</button>
        </div>
        <div id="idMsg" class="msg"></div>
      </div>

      <!-- 비밀번호 -->
      <div class="group">
        <label for="pwd">비밀번호 *</label>
        <input id="pwd" name="pwd" type="password" minlength="8" maxlength="20" required />
        <div class="hint">8~20자(영문/숫자/특수문자 조합 권장)</div>
      </div>

      <!-- 비밀번호 확인 -->
      <div class="group">
        <label for="pwd2">비밀번호 확인 *</label>
        <input id="pwd2" type="password" required />
      </div>

      <!-- 이름 -->
      <div class="group">
        <label for="userNm">이름</label>
        <input id="userNm" name="userNm" type="text" />
      </div>

      <!-- 닉네임 -->
	<div class="group">
	  <label for="nickNm">닉네임</label>
	  <div class="row">
	    <input id="nickNm" name="nickNm" type="text" />
	    <!-- disabled 제거, id 부여 -->
	    <button id="btnNickCheck" type="button" class="btn btn-ghost">중복확인</button>
	  </div>
	  <div id="nickMsg" class="msg"></div> <!-- 결과 메시지 영역 -->
	</div>


      <!-- 생년월일 -->
      <div class="group">
        <label for="birthDt">생년월일</label>
        <input id="birthDt" name="birthDt" type="date" placeholder="YYYYMMDD" />
      </div>

      <!-- 이메일 + 인증요청 -->
      <div class="group">
        <label for="mailAddr">이메일 본인 인증 *</label>
        <div class="row">
          <input id="mailAddr" name="mailAddr" type="email" required />
          <button id="btnSendCode" type="button" class="btn">인증하기</button>
        </div>
        <div class="hint">메일에서 인증 링크를 확인하거나, 코드 인증을 사용할 수 있습니다.</div>
      </div>

      <!-- 인증번호 입력 -->
      <div class="group">
        <input id="emailCode" type="text" placeholder="인증번호 6자리를 입력해주세요" />
        <div class="row" style="margin-top:8px">
          <button id="btnVerifyCode" type="button" class="btn btn-ghost" style="margin-left:auto">인증확인</button>
        </div>
      </div>

      <!-- 약관 -->
     <div class="checks">
  <label><input id="agreeAll" type="checkbox" /> 아래 약관에 모두 동의합니다.</label>

  <label class="term">
    <input class="agree req" type="checkbox" />
    <span class="link" role="button" tabindex="0" data-modal="tosModal">
      이용약관 필수 동의
    </span>
  </label>

  <label class="term">
    <input class="agree" type="checkbox" />
    <span class="link" role="button" tabindex="0" data-modal="marketingModal">
      마케팅 정보 수신 동의 (선택)
    </span>
  </label>
</div>
      <!-- 숨김 필드 -->
      <input type="hidden" id="emailAuthYn"  name="emailAuthYn"  value="N" />
      <input type="hidden" id="emailAuthToken" name="emailAuthToken" value="" />
      <input type="hidden" name="userGradeCd" value="1" />

      <button id="btnSubmit" class="btn submit" type="submit">회원가입 완료</button>
    </form>
    
    <!-- 이용약관 모달 -->
	<div id="tosModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="tosTitle">
	  <div class="backdrop" data-close></div>
	  <div class="panel" tabindex="-1">
	    <button type="button" class="close" aria-label="닫기" data-close>&times;</button>
	    <h2 id="tosTitle">이용약관</h2>
	    <div class="content">
	      <!-- 👉 여기에 실제 약관 내용을 넣으세요 -->
	      <p>본인은 본 서비스의 이용약관 내용을 확인하였으며, 이에 동의합니다.</p>
	    </div>
	  </div>
	</div>

	<!-- 마케팅 동의 모달 -->
	<div id="marketingModal" class="modal" aria-hidden="true" role="dialog" aria-labelledby="mkTitle">
	  <div class="backdrop" data-close></div>
	  <div class="panel" tabindex="-1">
	    <button type="button" class="close" aria-label="닫기" data-close>&times;</button>
	    <h2 id="mkTitle">마케팅 정보 수신 동의</h2>
	    <div class="content">
	      <p>본인은 본 서비스로부터 마케팅 정보를 수신하는 것에 동의합니다.</p>
	    </div>
	  </div>
	</div>
	     
    
    
    
  </div>

  <script>
    const $ = (s)=>document.querySelector(s);

    // 전체 동의
    $("#agreeAll").addEventListener("change", e=>{
      document.querySelectorAll(".agree").forEach(ch=>ch.checked = e.target.checked);
    });

    // 아이디 중복확인
    $("#btnIdCheck").onclick = async ()=>{
      const id = $("#userId").value.trim();
      if(!id){ $("#idMsg").className="msg err"; $("#idMsg").textContent="아이디를 입력하세요."; return; }
      const res  = await fetch('/ehr/member/checkId?userId='+encodeURIComponent(id));
      const text = (await res.text()).trim();
      const ok   = (text === 'OK');
      $("#idMsg").className = "msg " + (ok ? "ok":"err");
      $("#idMsg").textContent = ok ? "사용 가능한 아이디입니다." : "이미 사용 중인 아이디입니다.";
    };
    
   
 // 닉네임 중복확인
 /*    $("#btnNickNmCheck").onclick = async ()=>{
      const id = $("#nickNm").value.trim();
      if(!Nick){ 
    	  $("#nickNmMsg").className="msg err"; 
    	  $("#nickNmMsg").textContent="닉네임를 입력하세요."; 
    	  return; 
    	  }
      const res  = await fetch('/ehr/member/nickNmCheck?nickNm='+encodeURIComponent(nickNm));
      const text = (await res.text()).trim();
      const ok   = (text === 'OK');
      $("#nickNmMsg").className = "msg " + (ok ? "ok":"err");
      $("#nickNmMsg").textContent = ok ? "사용 가능한 닉네임입니다." : "이미 사용 중인 닉네임입니다.";
    }; 
     */

    

     // 컨텍스트 경로 (/ehr 등)
     const CTX = '<c:url value="/"/>'.replace(/\/$/, '');

     // 닉네임 중복확인
     document.getElementById('btnNickCheck').addEventListener('click', async ()=>{
    const nick = document.getElementById('nickNm').value.trim();
    const msg  = document.getElementById('nickMsg');

    if(!nick){
      msg.className = 'msg err';
      msg.textContent = '닉네임을 입력하세요.';
      return;
    }

    try{
      const url  = CTX + '/member/checkNick?nickNm=' + encodeURIComponent(nick);
      const res  = await fetch(url);
      const text = (await res.text()).trim(); // "OK" | "DUP"

      const ok = (text === 'OK'); // OK=사용 가능
      msg.className = 'msg ' + (ok ? 'ok' : 'err');
      msg.textContent = ok ? '사용 가능한 닉네임입니다.' : '이미 사용 중인 닉네임입니다.';
    }catch(e){
      msg.className = 'msg err';
      msg.textContent = '요청 실패: ' + e;
    }
  });
    

    // 인증코드(또는 인증링크) 발송
    $("#btnSendCode").onclick = async ()=>{
      const email = $("#mailAddr").value.trim();
      const userId = $("#userId").value.trim();

      if(!email){ alert("이메일을 입력하세요."); return; }
      const emailReg=/^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if(!emailReg.test(email)){ alert("이메일 형식이 올바르지 않습니다."); return; }

      const res = await fetch('/ehr/member/sendEmailAuth.do', {
        method:'POST',
        headers:{'Content-Type':'application/x-www-form-urlencoded'},
        body:'userId='+encodeURIComponent(userId)+'&mailAddr='+encodeURIComponent(email)
      });

      const text = (await res.text()).trim();
      if(!res.ok || text!=='SENT'){
        alert('메일 전송 실패: '+text);
        return;
      }
      alert('이메일로 인증 안내를 보냈습니다. 메일함을 확인해주세요.');
    };


  
  // 인증번호 확인 (mailAddr + code로 전송)
  $("#btnVerifyCode").onclick = async ()=>{
    const email = $("#mailAddr").value.trim();
    const code  = $("#emailCode").value.trim();

    if(!email){ alert("이메일을 입력하세요."); return; }
    if(!code){  alert("인증번호를 입력하세요."); return; }

    try{
      const res = await fetch('/ehr/member/verifyEmailCode', {
        method:'POST',
        headers:{'Content-Type':'application/x-www-form-urlencoded'},
        body:'mailAddr='+encodeURIComponent(email)+'&code='+encodeURIComponent(code)
      });

      const text = (await res.text()).trim(); // OK | INVALID | EXPIRED | NO_CODE

      if(text === 'OK'){
        $("#emailAuthYn").value = "Y";
        // 성공 후 이메일/버튼 잠궈 중복 인증 방지 (선택)
        $("#mailAddr").readOnly = true;
        $("#btnSendCode").disabled = true;
        $("#emailCode").readOnly = true;
        alert("인증 완료");
      }else if(text === 'EXPIRED'){
        alert("유효시간(5분)이 지났습니다. 다시 ‘인증하기’를 눌러 코드를 받으세요.");
      }else if(text === 'NO_CODE'){
        alert("인증코드가 없습니다. 먼저 ‘인증하기’로 코드를 받으세요.");
      }else{ // INVALID
        alert("인증 실패: 코드가 올바르지 않습니다.");
      }
    }catch(e){
      alert("서버 통신 오류: " + e);
    }
  };
  
  
  
  // 모달 열기/닫기
  function openModal(id){
    var m = document.getElementById(id);
    if(!m) return;
    m.classList.add('open');
    m.setAttribute('aria-hidden','false');
    var p = m.querySelector('.panel');
    if(p) p.focus();
  }
  function closeModal(el){
    var m = el.closest('.modal');
    if(!m) return;
    m.classList.remove('open');
    m.setAttribute('aria-hidden','true');
  }

  // 글자(약관 텍스트) 클릭 시 모달 오픈
  document.querySelectorAll('.checks .link').forEach(function(el){
    el.addEventListener('click', function(e){
      e.preventDefault();      // 라벨 기본 동작(체크 토글) 방지
      e.stopPropagation();     // 버블링 방지
      openModal(el.getAttribute('data-modal'));
    });
    // 키보드 접근성(Enter/Space)
    el.addEventListener('keydown', function(e){
      if(e.key === 'Enter' || e.key === ' '){
        e.preventDefault();
        openModal(el.getAttribute('data-modal'));
      }
    });
  });

  // 모달 닫기 버튼/배경 클릭, ESC 닫기
  document.querySelectorAll('[data-close]').forEach(function(el){
    el.addEventListener('click', function(e){ e.preventDefault(); closeModal(el); });
  });
  document.addEventListener('keydown', function(e){
    if(e.key === 'Escape'){
      document.querySelectorAll('.modal.open').forEach(function(m){
        m.classList.remove('open');
        m.setAttribute('aria-hidden','true');
      });
    }
  });
</script>


</body>
</html>
