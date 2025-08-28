<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>   
<c:set var="CP" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${CP}/resources/css/userInfo.css">
<link rel="stylesheet" href="/ehr/resources/css/pcwk_main.css">
<link rel="stylesheet" href="/ehr/resources/css/header.css">
<title>회원정보</title>
</head>
<body>
   <div id="container">
   
    <jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/include/sidebar.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/views/include/leftsidebar.jsp"></jsp:include>
   
      <!--main-->
      <main id="main">
      <div class="main-container">
      
      <c:if test="${not empty msg}">
	    <div id="flash-msg" style="display:none;">${fn:escapeXml(msg)}</div>
		  <script>
		    alert(document.getElementById('flash-msg').textContent);
		  </script>
	  </c:if>
	    <h2>회원정보</h2>
		<div class="userInfo-box">
		  <h3>아이디</h3>
		  <p>${user.userId}</p>
		
		  <h3>이름</h3>
		  <p>${user.userNm}</p>
		
		  <h3>닉네임</h3>
		  <p>${user.nickNm}</p>
		
		  <h3>생년월일</h3>
		  <p>${user.birthDt}</p>
		
		  <h3>이메일</h3>
		  <p>${user.mailAddr}</p>
		</div>
		
		<div class="button-box">
		  <a href="${pageContext.request.contextPath}/mypage/edit.do">수정</a>
		  <a href="#" class="open-del">탈퇴</a>
		</div>
	  </div>
	</main>
	
	<!-- 삭제(탈퇴) 확인 모달 -->
	<div id="deleteModal" class="modal-backdrop" aria-hidden="true">
	  <div class="modal" role="dialog" aria-modal="true" aria-labelledby="delTitle">
	    <h2 id="delTitle">정말 탈퇴하시겠어요?</h2>
	    <p>탈퇴 시 계정과 데이터가 삭제될 수 있습니다. 이 작업은 되돌릴 수 없습니다.</p>
	
	    <form id="deleteForm" action="${pageContext.request.contextPath}/mypage/delete.do" method="post">
	      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	      <div class="button-row">
	        <button type="button" class="btn btn-cancel" data-close="del">취소</button>
	        <button type="submit" class="btn btn-danger">탈퇴</button>
	      </div>
	    </form>
	  </div>
	</div>
    
	
  <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
   </div> 
   
   <!-- ▼ 모달 열고 닫는 스크립트-->
	<script>
	(function(){
	  const modal = document.getElementById('deleteModal');
	
	  // 열기
	  document.querySelector('.open-del')?.addEventListener('click', e => {
	    e.preventDefault();
	    modal.classList.add('is-open');
	    setTimeout(()=> modal.querySelector('.btn-danger')?.focus(), 0);
	    document.body.classList.add('body-locked'); // 선택: 스크롤 잠금
	  });
	
	  // 배경 클릭 닫기
	  modal.addEventListener('click', e => {
	    if (e.target === modal) close();
	  });
	
	  // 취소 버튼 닫기
	  modal.querySelector('[data-close="del"]')?.addEventListener('click', e => {
	    e.preventDefault(); close();
	  });
	
	  // ESC 닫기
	  document.addEventListener('keydown', e => {
	    if (e.key === 'Escape' && modal.classList.contains('is-open')) close();
	  });
	
	  function close(){
	    modal.classList.remove('is-open');
	    document.body.classList.remove('body-locked');
	  }
	})();
	</script>
</body>
</html>