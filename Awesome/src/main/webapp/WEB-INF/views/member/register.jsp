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
          <button type="button" class="btn btn-ghost" disabled>중복확인</button>
        </div>
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
        <label><input class="agree req" type="checkbox" /> 이용약관 필수 동의</label>
        <label><input class="agree" type="checkbox" /> 마케팅 정보 수신 동의 (선택)</label>
      </div>

      <!-- 숨김 필드 -->
      <input type="hidden" id="emailAuthYn"  name="emailAuthYn"  value="N" />
      <input type="hidden" id="emailAuthToken" name="emailAuthToken" value="" />
      <input type="hidden" name="userGradeCd" value="1" />

      <button id="btnSubmit" class="btn submit" type="submit">회원가입 완료</button>
    </form>
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

    // (선택) 코드 인증 방식 사용 시 서버에 구현되어 있다면 연결
    $("#btnVerifyCode").onclick = async ()=>{
      const token = $("#emailAuthToken").value.trim(); // 필요 시 서버에서 되돌려 받은 token을 저장해둠
      const code  = $("#emailCode").value.trim();
      if(!code){ alert("인증번호를 입력하세요."); return; }

      // 서버에 verifyEmailCode 엔드포인트가 있을 때만 사용
      try{
        const res = await fetch('/ehr/member/verifyEmailCode', {
          method:'POST',
          headers:{'Content-Type':'application/x-www-form-urlencoded'},
          body:'token='+encodeURIComponent(token)+'&code='+encodeURIComponent(code)
        });
        const ok = (await res.text()).trim() === 'OK';
        $("#emailAuthYn").value = ok ? "Y" : "N";
        alert(ok ? "인증 완료" : "인증 실패");
      }catch(e){
        // 링크 인증만 사용할 경우엔 이 버튼을 숨기셔도 됩니다.
        alert("서버에서 코드 인증 엔드포인트를 제공하지 않습니다.");
      }
    };

    // 제출 전 검증
    $("#joinForm").onsubmit = ()=>{
      if($("#pwd").value !== $("#pwd2").value){
        alert("비밀번호가 일치하지 않습니다."); return false;
      }
      if(!document.querySelector(".agree.req").checked){
        alert("이용약관(필수)에 동의해주세요."); return false;
      }
      if($("#emailAuthYn").value !== "Y"){
        // 링크 인증만 쓰는 경우: 이메일 발송 후 링크 클릭으로 검증되므로
        // 가입 전 검사를 완화하려면 아래 줄을 주석 처리하세요.
        alert("이메일 인증을 완료하세요."); return false;
      }
      return true;
    };
  </script>
</body>
</html>
