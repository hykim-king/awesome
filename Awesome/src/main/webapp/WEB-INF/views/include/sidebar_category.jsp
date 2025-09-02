<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>   

<style>
  /* 사이드바 컨테이너: 세로로 배치 + 간격 */
  #sidebar{
    display:flex;
    flex-direction:column;
    gap:16px; /* 간격 조절 */
  }

  /* 내부 카드들은 부모 폭 100% 사용 */
  #sidebar > *{
    width:100%;
    max-width:none;
    margin:0;           /* 포함된 조각이 기본 margin 주면 무시하기 */
  }
  
  

  @media (max-width: 900px){
    #sidebar{ gap:12px; }
  }
</style>

<div id="sidebar">
  <jsp:include page="/WEB-INF/views/quiz/quizRank.jsp"/>
  <jsp:include page="/WEB-INF/views/chat/chat.jsp"/>
  <jsp:include page="/WEB-INF/views/widget/dictionary.jsp"/>
</div>
