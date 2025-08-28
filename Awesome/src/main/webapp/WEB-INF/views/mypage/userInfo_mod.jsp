<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>   
<c:set var="CP" value="${pageContext.request.contextPath }" /> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${CP}/resources/css/userInfo_mod.css">
<link rel="stylesheet" href="/ehr/resources/css/pcwk_main.css">
<link rel="stylesheet" href="/ehr/resources/css/header.css">
<link rel="stylesheet" href="/ehr/resources/css/pwd_modal.css">
<title>회원정보 수정</title>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
   <div id="container">
   
    <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/include/sidebar.jsp"></jsp:include>
      <!--main-->
      <main id="main">
      <div class="main-container">
		<h2>회원정보 수정</h2>
		<form action="${pageContext.request.contextPath}/mypage/update.do" method="post">
		  <label>아이디</label>
		  <input type="text" name="userId" value="${user.userId}" readonly>
		
		  <label>이름</label>
		  <input type="text" name="userNm" value="${user.userNm}" readonly>
		
		  <label>닉네임</label>
		  <input type="text" name="nickNm" value="${user.nickNm}">
		
		  <label>생년월일</label>
		  <input type="date" name="birthDt" value="${user.birthDt}" readonly>
		
		  <label>이메일</label>
		  <input type="email" name="mailAddr" value="${user.mailAddr}" readonly>
		
		  <div class="button-box">
		    <a href="#" class="btn-pw open-pw">비밀번호 변경</a>
		    <button type="submit">저장</button>
		    <a href="${CP}/mypage/userInfo.do">취소</a>
		  </div>
		</form>
      </div>
    </main>
    
    <!-- 모달 마크업 -->
    <div id="pwModal" class="modal-backdrop" aria-hidden="true">
      <div class="modal" role="dialog" aria-modal="true" aria-labelledby="pwTitle">
        <h2 id="pwTitle">비밀번호 변경</h2>
        <form action="${CP}/mypage/changePassword.do" method="post" class="modal-form">
          <label for="newPwd">새 비밀번호</label>
          <input id="newPwd" type="password" name="newPwd" required minlength="8" autocomplete="new-password">
	      <label for="confirmPwd">비밀번호 확인</label>
	      <input id="confirmPwd" type="password" name="confirmPwd" required minlength="8" autocomplete="new-password">
	      <div class="button-row">
	       <a href="${CP}/mypage/userInfo.do" class="btn btn-cancel" data-close="pw">취소</a>
	        <button type="submit" class="btn btn-save">저장</button>
          </div>
        </form>
      </div>
    </div>
    
  <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
   </div> 
	<!-- ▼ 모달 열고 닫는 스크립트(이 페이지 맨 아래) -->
	<script>
	(function(){
	  const modal=document.getElementById('pwModal');
	  document.querySelector('.open-pw')?.addEventListener('click',e=>{
	    e.preventDefault(); modal.classList.add('is-open');
	    setTimeout(()=>document.getElementById('newPwd')?.focus(),0);
	  });
	  modal.addEventListener('click',e=>{ if(e.target===modal) modal.classList.remove('is-open'); });
	  modal.querySelector('[data-close="pw"]')?.addEventListener('click',e=>{
	    e.preventDefault(); modal.classList.remove('is-open');
	  });
	  document.addEventListener('keydown',e=>{ if(e.key==='Escape') modal.classList.remove('is-open'); });
	})();
	</script>
</body>
</html>