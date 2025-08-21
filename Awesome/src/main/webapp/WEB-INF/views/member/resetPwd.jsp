<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="CP" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>비밀번호 재설정</title>

  <!-- 공통 리소스 -->
  <link rel="stylesheet" href="<c:url value='/resources/css/pcwk_main.css'/>">
  <link rel="stylesheet" href="<c:url value='/resources/css/header.css'/>">

  <style>
    :root{
      --bg:#f7fafc; --card:#fff; --text:#0f172a; --muted:#475569;
      --line:#e5e7eb; --blue-light:#4aa3ff; --blue:#0a45ff;
    }
    *{box-sizing:border-box}

    /* 페이지 전체 흰 배경 + 헤더 보조바 숨김 */
    .page-resetpwd,
    .page-resetpwd #container,
    .page-resetpwd #main,
    .page-resetpwd #main .main-container{ background:#fff !important; }
    .page-resetpwd #main::before{ display:none; }
    
    
     /* 회원가입 페이지만 흰 배경 유지 */
        .page-restpwd #main,
        .page-restpwd #main .main-container { background:#fff !important; }
    

    /* 혹시 남아있는 사이드 레이아웃 여백 제거 + 중앙정렬 */
    .page-resetpwd #main{ padding-left:0 !important; }
    .page-resetpwd #main .main-container{
      margin-left:0 !important; width:100% !important;
      display:flex !important; justify-content:center !important;
      padding:64px 16px 96px !important; /* 헤더/하단 여백 */
    }

    /* 카드 */
    .page-resetpwd .wrap{
      max-width:520px; width:100%;
      background:var(--card);
      border-radius:16px;
      box-shadow:0 10px 30px rgba(15,23,42,.08);
      padding:28px 22px;
    }

    /* 타이틀/설명 */
    .page-resetpwd h1{
      font-size:22px; font-weight:800; text-align:center; margin:4px 0 18px;
    }
    .page-resetpwd .desc{ margin:0 0 18px; color:#64748b; font-size:14px; }

    /* 인풋 */
    .page-resetpwd .form-group{ margin-bottom:14px; }
    .page-resetpwd label{ display:block; font-size:13px; font-weight:700; margin:0 0 6px; }
    .page-resetpwd input[type="password"]{
      width:100%; height:44px; padding:0 12px;
      border:1px solid var(--line); border-radius:10px;
      background:#f9fafb; font-size:14px; outline:none;
      transition:border-color .15s, box-shadow .15s, background .15s;
    }
    .page-resetpwd input[type="password"]:focus{
      border-color:var(--blue);
      box-shadow:0 0 0 4px color-mix(in srgb, var(--blue) 20%, transparent);
      background:#fff;
    }
    .page-resetpwd .help{ display:block; margin-top:6px; font-size:12px; color:#94a3b8; }

    /* 버튼 2개 가로 정렬 */
    .page-resetpwd .actions{ display:flex; gap:10px; margin-top:10px; }
    .page-resetpwd .btn{
      flex:1 1 auto; height:46px; border:0; border-radius:12px;
      display:block; text-align:center; line-height:46px;
      font-weight:700; cursor:pointer; text-decoration:none;
      transition:background .15s ease;
    }
    .page-resetpwd .btn-primary{ background:var(--blue-light); color:#fff; }
    .page-resetpwd .btn-primary:hover{ background:var(--blue); }
    .page-resetpwd .btn-ghost{
      background:#eef2ff; color:#1e40af; border:1px solid #dbe3ff;
    }
    .page-resetpwd .btn-ghost:hover{ background:#e3e9ff; }

    /* (옵션) 메시지 박스 */
    .alert{ padding:10px 12px; border-radius:12px; font-size:14px; margin-bottom:14px; border:1px solid; }
    .alert-error{ background:#fee2e2; border-color:#fecaca; color:#7f1d1d; }
    .alert-success{ background:#dcfce7; border-color:#bbf7d0; color:#064e3b; }
  
  
  
  
  
  
  </style>
</head>

<body class="page-resetpwd">
<div id="container">
  <jsp:include page="/WEB-INF/views/include/header.jsp"/>

  <!-- main은 단 한 번만 -->
  <main id="main">
    <div class="main-container">
      <div class="wrap">
        <h1>새로운 비밀번호</h1>
        <p class="desc">새 비밀번호를 설정해 주세요.</p>

        <c:if test="${not empty error}">
          <div class="alert alert-error">${error}</div>
        </c:if>
        <c:if test="${not empty message}">
          <div class="alert alert-success">${message}</div>
        </c:if>

        <form method="post" action="<c:url value='/member/resetPwd.do'/>" autocomplete="off">
          <input type="hidden" name="token" value="${token}">

          <div class="form-group">
            <label for="newPwd">새 비밀번호</label>
            <input type="password" id="newPwd" name="newPwd"
                   required minlength="8" autocomplete="new-password"
                   placeholder="8자 이상 입력">
            <small class="help">8자 이상, 추천: 영문 대/소문자+숫자+특수문자 조합</small>
          </div>

          <div class="actions">
            <button class="btn btn-primary" type="submit">변경</button>
            <a class="btn btn-ghost" href="<c:url value='/mainPage/main.do'/>">메인으로</a>
          </div>
        </form>
      </div>
    </div>
  </main>

  <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</body>
</html>
