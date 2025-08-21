<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
    <main id="main">
      <div class="main-container">
        <h2>비밀번호 변경</h2>
        <form action="${pageContext.request.contextPath}/mypage/changePassword.do" method="post">
          
		  <label>새 비밀번호</label>
		  <input type="password" name="newPwd" required minlength="8" autocomplete="new-password">
		
		  <label>새 비밀번호 확인</label>
		  <input type="password" name="confirmPwd" required minlength="8" autocomplete="new-password">
        
          <div class="button-box">
            <button type="submit">변경하기</button>
            <a href="${pageContext.request.contextPath}/mypage/edit.do">취소</a>
          </div>
        </form>
      </div>
    </main>

</body>
</html>