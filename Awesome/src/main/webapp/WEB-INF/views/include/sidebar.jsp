<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<style>
  /* 사이드바 내부 카드들은 부모폭 100% 사용 */
  #sidebar_category .dict-wrap,
  #sidebar_category .quiz-ranking-wrap{
    width:100%;
    max-width:none;
    margin:0;
  }
  
</style>

<div id="sidebar">
   <jsp:include page = "/WEB-INF/views/quiz/quizRank.jsp" />
   <jsp:include page = "/WEB-INF/views/widget/dictionary.jsp" />


</div>