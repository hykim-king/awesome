<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="CP" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>비밀번호 찾기</title>
  <link rel="stylesheet" href="<c:url value='/resources/css/pcwk_main.css'/>">
  <link rel="stylesheet" href="<c:url value='/resources/css/header.css'/>">
  
  <style>
   :root{
  --bg:#f7fafc; --card:#fff; --text:#0f172a; --muted:#475569;
  --line:#e5e7eb; --blue-light:#4aa3ff; --blue:#0a45ff;
}
*{box-sizing:border-box}
body{
  margin:0; background:var(--bg); color:var(--text);
  font-family: Inter,Pretendard,system-ui,-apple-system,Segoe UI,Roboto,
               "Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",sans-serif;}


    /* 아이디찾기(page-find)에서만 사이드바/우측레일/배너 숨김 */
    .page-find #main aside,
    .page-find #main #sidebar,
    .page-find #main .sidebar,
    .page-find #main .left-rail,
    .page-find #main .right-rail,
    .page-find #main .left,
    .page-find #main .right,
    .page-find #main .banner,
    .page-find #main .ad {
      display: none !important;
    }
    
    /* 사이드바 빠진 만큼 본문을 꽉 채우기 */
    .page-find #main { padding-left: 0 !important; }
    .page-find #main .main-container {
      margin-left: 0 !important;
      width: 100% !important;
    }


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
    input:focus{border-color:var(--blue);  box-shadow: 0 0 0 4px color-mix(in srgb, var(--blue) 20%, transparent); background:#fff;}
    .btn{
      width:100%; height:46px; border:0; border-radius:12px;
      background:var(--blue-light); color:#fff; font-weight:700; cursor:pointer;}
    .btn:hover{background:var(--blue)}
    .btn:active{ transform: translateY(0); }
    
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
    
    /* 아이디 찾기 페이지: 바깥 배경(오른쪽 여백 포함)도 전부 흰색 */
    body.page-find,
    .page-find #container,
    .page-find #main,
    .page-find #main .main-container{
      background:#fff !important;
    }


    /* 사이드바 공간 없애기 */
    .page-find #main { padding-left:0 !important; }
    .page-find #main .main-container { margin-left:0 !important; width:100% !important; }

  </style>

</head>
<body class="page-find">
  <div id="container">
    <jsp:include page="/WEB-INF/views/include/header.jsp"/>
   <%--  <jsp:include page="/WEB-INF/views/include/sidebar.jsp"/> --%>

  <main id="main">
    <div class="main-container">
      <div class="wrap">
        <h1>비밀번호 찾기</h1>

        <form method="post" action="<c:url value='/member/findPwd.do'/>">
          <div class="group">
            <label for="userId">아이디</label>
            <input id="userId" name="userId" type="text" required placeholder="아이디를 입력해주세요">
          </div>
          <div class="group">
            <label for="mailAddr">가입 이메일</label>
            <input id="mailAddr" name="mailAddr" type="email" required placeholder="이메일을 입력해주세요">
          </div>
          <button class="btn" type="submit">재설정 메일 보내기</button>
          <p class="note"><a href="<c:url value='/member/login.do'/>">로그인으로 돌아가기</a></p>
        </form>
      </div>
    </div>
  </main>

  <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</body>


</html>
