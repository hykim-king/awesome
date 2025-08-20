<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>회원가입</title>

  <!-- 프로젝트 정적 리소스 -->
  <link rel="stylesheet" href="<c:url value='/resources/css/pcwk_main.css'/>">
  <link rel="stylesheet" href="<c:url value='/resources/css/header.css'/>">

  <style>
   :root{
  --bg:#f7fafc; --card:#ffffff; --text:#0f172a; --muted:#6b7280;
  --line:#e5e7eb;
  --blue-light:#4aa3ff;   /* 기본(연한 파랑) */
  --blue:#0a45ff;         /* hover/클릭 시 진한 파랑 */
  --input:#f9fafb;
}
    *{box-sizing:border-box}
    body{ margin:0; background:var(--bg); color:var(--text);
      font-family: "Inter","Pretendard",system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",sans-serif;
    }
    .wrap{ max-width:360px; margin:48px auto; padding:28px 22px; background:var(--card);
      border-radius:16px; box-shadow:0 10px 30px rgba(15,23,42,.08);
    }
    h1{ font-size:22px; font-weight:800; text-align:center; margin:6px 0 22px; }
    .group{ margin-bottom:14px; }
    label{ display:block; font-size:13px; font-weight:700; margin:2px 0 8px; }
    .row{ display:flex; gap:10px; align-items:center; }
    input[type="text"],input[type="password"],input[type="email"],input[type="date"]{
      width:100%; height:44px; padding:0 12px; border:1px solid var(--line);
      background:var(--input); border-radius:10px; outline:none; transition:.15s ease; font-size:14px;
    }
    
    input:focus{border-color : var(--blue);box-shadow: 0 0 0 4px color-mix(in srgb, var(--blue) 20%,  transparent);background:#fff;}
    /* 버튼 */
.btn{
  height:44px; padding:0 14px; border:0;
  background: var(--blue-light);   /* ✅ 연한 파랑 */
  color:#fff; border-radius:10px;
  font-size:14px; font-weight:700;
  cursor:pointer; transition:.15s ease; white-space:nowrap;
}
.btn:hover{
  background: var(--blue);         /*  hover 시 진한 파랑 */
}
.btn:active{
  background: #072fc7;             /* (선택) 클릭 시 더 어두운 파랑 */
}

    /* modal */
    .modal{position:fixed; inset:0; display:none; align-items:center; justify-content:center; z-index:1000;}
    .modal.open{display:flex;}
    .modal .backdrop{position:absolute; inset:0; background:rgba(0,0,0,.45);}
    .modal .panel{ position:relative; max-width:640px; width:calc(100% - 32px); max-height:80vh; overflow:auto;
      background:var(--card); border-radius:16px; padding:20px; box-shadow:0 20px 50px rgba(0,0,0,.2)
    }
    .modal .close{ position:absolute; top:10px; right:12px; border:0; background:transparent; font-size:22px; cursor:pointer; line-height:1; }
    .modal h2{margin:0 0 10px; font-size:18px}
    .modal .content{font-size:14px; color:#334155}
    /* 체크박스 영역 글자 색상 통일 */
	.checks label,
	.checks .link {
	  color: #111827 !important;   /* 진한 검정 */
	  text-decoration: none !important; /* 밑줄 제거 */
	  cursor: default;             /* 손가락 대신 기본 커서 */
	}
  
	    /* 회원가입 페이지에만 적용 */
		.page-register,
		.page-register #main,
		.page-register .main-container { background:#fff !important; }
		
		.page-register .wrap { max-width:520px; }
		.page-register input[type="text"],
		.page-register input[type="password"],
		.page-register input[type="email"],
		.page-register input[type="date"] { height:44px; }
    
        
        /* 회원가입 페이지만 흰 배경 유지 */
		.page-register #main,
		.page-register #main .main-container { background:#fff !important; }
		
		
		
		/* 폼 카드(.wrap)를 "뷰포트 기준" 가로 중앙 정렬 */
		.page-register .wrap{
		  max-width: 520px;
		  margin: 48px 0;             /* 좌우 auto 제거 */
		  position: relative;
		  left: 50vw;                  /* 화면 가로의 정중앙으로 보낸 뒤 */
		  transform: translateX(-50%); /* 자기 너비의 절반만큼 되돌려 정확히 가운데 */
		}
		
	
  
  
    /* 회원가입 버튼 스타일 */
	  #btnSubmit{
	  display:block;
	  width:100%;
	  height:48px;
	  margin-top:20px;   /* 위쪽 여백만 */
	  text-align:center;
	  border-radius:12px;
	}
	    
 
  </style>
</head>


  <body class="page-register">
   
  <div id="container">
    <!-- 공통 레이아웃 -->
    <jsp:include page="/WEB-INF/views/include/header.jsp"/>
   <%--  <jsp:include page="/WEB-INF/views/include/sidebar.jsp"/> --%>

    <!-- 메인 -->
    <main id="main">
      <div class="main-container">
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
                <button id="btnNickCheck" type="button" class="btn btn-ghost">중복확인</button>
              </div>
              <div id="nickMsg" class="msg"></div>
            </div>

            <!-- 생년월일 -->
            <div class="group">
              <label for="birthDt">생년월일</label>
              <input id="birthDt" name="birthDt" type="date" placeholder="YYYYMMDD" />
            </div>

           <!-- 이메일 + 인증요청 -->
		<!-- 이메일 + 인증요청 -->
		<div class="group">
		  <label for="mailAddr">이메일 본인 인증 *</label>
		  <div class="row">
		    <input id="mailAddr" name="mailAddr" type="email" required />
		    <button id="btnSendCode" type="button" class="btn">인증하기</button>
		  </div>
		  <small id="emailHint" class="hint">메일에서 인증 링크를 확인해주세요.</small>
		  <div id="emailMsg" class="msg"></div>
		</div>
		
		<!-- 인증번호 입력 -->
		<div class="group">
		  <input id="emailCode" type="text" placeholder="인증번호 6자리를 입력해주세요" />
		  <div class="row" style="margin-top:8px">
		    <button id="btnVerifyCode" type="button" class="btn btn-ghost" style="margin-left:auto">인증확인</button>
		  </div>
		  <div id="codeMsg" class="msg"></div>
		</div>
		
	
            <!-- 약관 -->
            <div class="checks">
              <label><input id="agreeAll" type="checkbox" /> 아래 약관에 모두 동의합니다.</label>

              <label class="term">
                <input class="agree req" type="checkbox" />
                <span class="link" role="button" tabindex="0" data-modal="tosModal">이용약관 필수 동의</span>
              </label>

              <label class="term">
                <input class="agree" type="checkbox" />
                <span class="link" role="button" tabindex="0" data-modal="marketingModal">마케팅 정보 수신 동의 (선택)</span>
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
      </div>
    </main>

    <!-- 공통 푸터 -->
    <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
  </div>

 <script>
  const CP = '${pageContext.request.contextPath}';
  const $  = function(s){ return document.querySelector(s); };

  // 버튼/필드 캐시
  const btnId   = $('#btnIdCheck');
  const btnNick = $('#btnNickCheck');
  const btnSend = $('#btnSendCode');
  const btnVer  = $('#btnVerifyCode');

  const f = {
    userId  : $('#userId'),
    nickNm  : $('#nickNm'),
    mail    : $('#mailAddr'),
    code    : $('#emailCode'),
    pwd     : $('#pwd'),
    pwd2    : $('#pwd2'),
    emailOk : $('#emailAuthYn')
  };

  const emailHint = document.getElementById('emailHint');

  // 공통 POST(x-www-form-urlencoded)
  async function postForm(url, params){
    const resp = await fetch(url, {
      method:'POST',
      headers:{'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'},
      body:new URLSearchParams(params)
    });
    if(!resp.ok){
      const t = await resp.text();
      throw new Error('HTTP ' + resp.status + ' ' + (t || ''));
    }
    return resp.json();
  }

  // ID 중복
  if (btnId){
    btnId.addEventListener('click', async function(){
      const id  = (f.userId.value || '').trim();
      const box = document.getElementById('idMsg');
      if(!id){ box.className='msg err'; box.textContent='아이디를 입력하세요.'; return; }

      const res  = await fetch(CP + '/member/checkId.do?userId=' + encodeURIComponent(id));
      const text = (await res.text()).trim();
      const ok   = (text === 'OK');
      box.className  = 'msg ' + (ok ? 'ok' : 'err');
      box.textContent= ok ? '사용 가능한 아이디입니다.' : '이미 사용 중인 아이디입니다.';
    });
  }

  // 닉네임 중복
  if (btnNick){
    btnNick.addEventListener('click', async function(){
      const nick = (f.nickNm.value || '').trim();
      const box  = document.getElementById('nickMsg');
      if(!nick){ box.className='msg err'; box.textContent='닉네임을 입력하세요.'; return; }

      const res  = await fetch(CP + '/member/checkNick.do?nickNm=' + encodeURIComponent(nick));
      const text = (await res.text()).trim();
      const ok   = (text === 'OK');
      box.className  = 'msg ' + (ok ? 'ok' : 'err');
      box.textContent= ok ? '사용 가능한 닉네임입니다.' : '이미 사용 중인 닉네임입니다.';
    });
  }

  // 이메일 인증 코드 발송
  if (btnSend){
    btnSend.addEventListener('click', async function(){
      const email = (f.mail.value || '').trim();
      const msg   = document.getElementById('emailMsg');

      if(!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)){
        msg.className='msg err'; msg.textContent='이메일 형식이 올바르지 않습니다.';
        if (emailHint) emailHint.style.display = 'none';
        return;
      }

      msg.className='msg'; msg.textContent='전송 중…';
      try{
        const data = await postForm(CP + '/member/email/sendCode.do', {mailAddr: email});
        msg.className  = 'msg ' + (data.ok ? 'ok' : 'err');
        msg.textContent= data.message || (data.ok ? '인증 코드가 발송되었습니다.' : '메일 전송 실패');
        if (emailHint) emailHint.style.display = 'none';

        // 재전송 쿨다운
        if (data.ok){
          var left = 60;
          btnSend.disabled = true;
          btnSend.textContent = '재전송(' + left + 's)';
          var timer = setInterval(function(){
            left--;
            btnSend.textContent = '재전송(' + left + 's)';
            if(left <= 0){
              clearInterval(timer);
              btnSend.disabled = false;
              btnSend.textContent = '인증하기';
            }
          }, 1000);
        }
      }catch(e){
        msg.className='msg err'; msg.textContent = '요청 실패: ' + e.message;
      }
    });
  }

  // 인증 코드 확인
  if (btnVer){
    btnVer.addEventListener('click', async function(){
      const email = (f.mail.value || '').trim();
      const code  = (f.code.value || '').trim();
      const msg   = document.getElementById('codeMsg');

      if(!email){ msg.className='msg err'; msg.textContent='이메일을 입력하세요.'; return; }
      if(code.length !== 6){ msg.className='msg err'; msg.textContent='6자리 코드를 입력하세요.'; return; }

      msg.className='msg'; msg.textContent='확인 중…';
      try{
        const data = await postForm(CP + '/member/email/verifyCode.do', {mailAddr: email, code: code});
        msg.className  = 'msg ' + (data.ok ? 'ok' : 'err');
        msg.textContent= data.message || (data.ok ? '이메일 인증 완료!' : '코드 확인 실패');

        if (data.ok){
          f.emailOk.value = 'Y';
          f.mail.readOnly  = true;
          btnSend.disabled = true;
          f.code.readOnly  = true;
        }
      }catch(e){
        msg.className='msg err'; msg.textContent = '요청 실패: ' + e.message;
      }
    });
  }

  // 폼 제출 전 최종 검증
  var joinForm = document.getElementById('joinForm');
  if (joinForm){
    joinForm.addEventListener('submit', function(e){
      if(f.pwd.value !== f.pwd2.value){
        alert('비밀번호가 일치하지 않습니다.'); e.preventDefault(); return;
      }
      var req = document.querySelector('.agree.req');
      if(req && !req.checked){
        alert('이용약관(필수)에 동의해주세요.'); e.preventDefault(); return;
      }
      if(f.emailOk.value !== 'Y'){
        alert('이메일 인증을 완료하세요.'); e.preventDefault(); return;
      }
    });
  }
</script>



</body>
</html>
