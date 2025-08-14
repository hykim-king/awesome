<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head><meta charset="UTF-8"><title>비밀번호 재설정</title></head>
<body>
  <h1>비밀번호 재설정</h1>

  <c:if test="${not empty error}">
    <div style="color:red">${error}</div>
  </c:if>

  <form method="post" action="<c:url value='/member/resetPwd'/>">
    <input type="hidden" name="token" value="${token}">
    <div>
      <label>새 비밀번호</label>
      <input type="password" name="newPwd" required>
    </div>
    <button type="submit">변경</button>
  </form>
</body>
</html>
