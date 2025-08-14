<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="CP" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>아이디 찾기</title>

  <link rel="stylesheet" href="<c:url value='/resources/css/pcwk_main.css'/>">
  <link rel="stylesheet" href="<c:url value='/resources/css/header.css'/>">

  <style>
    :root{
      --bg:#f7fafc; --card:#fff; --text:#0f172a; --muted:#475569;
      --line:#e5e7eb; --green:#84cc16; --green-dark:#65a30d;
    }
    *{box-sizing:border-box}
    body{margin:0; background:var(--bg); color:var(--text);
      font-family: Inter,Pretendard,system-ui,-apple-system,Segoe UI,Roboto,
                   "Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",sans-serif;}

    /* 이 페이지 전용: 우측 레일이 있으면 숨기고 흰 배경 */
    .page-find #main, .page-find #main .main-container{background:#fff !important;}
    .page-find #main aside, .page-find #main .right, .page-find #main .banner{display:none !important;}

    /* 카드 중앙 배치 */
    .wrap{
      max-width: 420px;
      margin: 60px 0;
      position: relative; left:50vw; transform: translateX(-50%);
      background:var(--card); border-radius:16px;
      box-shadow:0 10px 30px rgba(15,23,42,.08);
      padding:28px 22px;
    }
    h1{font-size:22px; font-weight:800; text-align:center; margin:4px 0 18px;}
    .group{margin-bottom:14px;}
    label{display:block; font-size:13px; font-weight:700; margin:0 0 6px;}
    input[type="text"], input[type="email"]{
      width:100%; height:44px; padding:0 12px; border:1px solid var(--line);
      border-radius:10px; background:#f9fafb; font-size:14px; outline:none;
    }
    input:focus{border-color:var(--green); box-shadow:0 0 0 4px rgba(132,204,22,.2); background:#fff;}
    .btn{
      width:100%; height:46px; border:0; border-radius:12px;
      background:var(--green); color:#fff; font-weight:700; cursor:pointer;
    }
    .btn:hover{background:var(--green-dark)}
    .note{margin-top:10px; text-align:center; font-size:12px; color:var(--muted)}
    .note a{text-decoration:underline}

    /* ------ 결과 모달 ------ */
    .modal{position:fixed; inset:0; display:none; align-items:center; justify-content:center; z-index:1000;}
    .modal.open{display:flex;}
    .modal .backdrop{position:absolute; inset:0; background:rgba(0,0,0,.45);}
    .modal .panel{
      position:relative; width:min(92vw,420px); background:#fff; border-radius:16px;
      box-shadow:0 20px 50px rgba(0,0,0,.2); padding:28px 22px; text-align:center;
    }
    .modal h2{margin:0 0 12px; font-size:20px}
    .modal p{margin:10px 0; font-size:16px}
    .modal .id{display:inline-block; margin:6px 0; font-weight:800; font-size:22px}
    .modal .actions{margin-top:16px; display:flex; gap:10px; justify-content:center;}
    .ghost{background:#eef6d0; color:#3f6212; border:0; padding:10px 16px; border-radius:10px; cursor:pointer;}
  
    .utils {
		    display: flex;
		    justify-content: center; /* 가로 가운데 정렬 */
		    align-items: center;     /* 세로 가운데 정렬 */
		    gap: 8px;                /* 요소 간 간격 */
		    margin-top: 10px;        /* 위쪽 여백 (선택) */
		}
		.utils a {
		    text-decoration: none;
		    color: #4f46e5; /* 링크 색상 (원하는 색상으로 변경) */
		}
		.utils span {
		    color: #999; /* 구분선 색상 */
		}
    
  
  
  </style>
</head>

<body class="page-find">
  <div id="container">
    <jsp:include page="/WEB-INF/views/include/header.jsp"/>
    <jsp:include page="/WEB-INF/views/include/sidebar.jsp"/>

    <main id="main">
      <div class="main-container">
        <div class="wrap">
          <h1>아이디 찾기</h1>

          <form method="post" action="<c:url value='/member/findId.do'/>">
            <div class="group">
              <label for="userNm">이름</label>
              <input id="userNm" name="userNm" type="text" required placeholder="이름을 입력해주세요">
            </div>

            <div class="group">
              <label for="mailAddr">이메일</label>
              <input id="mailAddr" name="mailAddr" type="email" required placeholder="이메일을 입력해주세요">
            </div>

            <button class="btn" type="submit">아이디 찾기</button>
            <%-- <p class="note"><a href="<c:url value='/member/findPwd.do'/>">비밀번호 찾기</a></p>

            <p class="note"><a href="<c:url value='/member/login.do'/>">로그인으로 돌아가기</a></p> --%>
            
            <div class="utils">
              <a href="<c:url value='/member/findPwd.do'/>">비밀번호 찾기</a>
              <span>│</span>
              <a href="<c:url value='/member/login.do'/>">로그인</a>
      
            </div>
            
            
          </form>
        </div>
      </div>
    </main>

    <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
  </div>

  <!-- 결과 모달 -->
  <div id="resultModal" class="modal <c:if test='${submitted}'>open</c:if>">
    <div class="backdrop" data-close></div>
    <div class="panel">
      <c:choose>
        <c:when test="${not empty foundId}">
          <h2>회원님의 아이디는</h2>
          <div class="id">${foundId}</div>
          <p>입니다.</p>
          <div class="actions">
            <a class="ghost" href="<c:url value='/member/login.do'/>">로그인</a>
            <button class="ghost" type="button" data-close>닫기</button>
          </div>
        </c:when>
        <c:otherwise>
          <h2>일치하는 계정을 찾을 수 없습니다.</h2>
          <p>이름/이메일을 다시 확인해주세요.</p>
          <div class="actions">
            <button class="ghost" type="button" data-close>닫기</button>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <script>
    // 모달 닫기
    document.querySelectorAll('[data-close]').forEach(el=>{
      el.addEventListener('click', ()=> document.getElementById('resultModal').classList.remove('open'));
    });
    document.addEventListener('keydown', (e)=>{
      if(e.key==='Escape') document.getElementById('resultModal').classList.remove('open');
    });
  </script>
</body>
</html>
