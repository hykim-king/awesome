<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<style>

/* 사이드바 컨테이너 */
#sidebar {
  display: flex;
  flex-direction: column;
  gap: 14px;       /* 카드 간격 */
  width: 280px;    /* 사이드바 고정 폭 */
  min-width: 280px;
  max-width: 280px;
}

/* 내부 카드들은 부모폭 100% 사용 */
#sidebar > * {
  width: 100%;
  max-width: none;
  margin: 0;       /* 불필요한 margin 제거 */
}

/* 반응형: 모바일에서 사이드바 폭 줄이기 */
@media (max-width: 900px) {
  #sidebar {
    width: 100%;   /* 모바일 화면에서는 가로폭 꽉 채우기 */
    min-width: auto;
    max-width: 100%;
    gap: 12px;
  }
}
  
  
</style>

<div id="sidebar">
   <jsp:include page = "/WEB-INF/views/quiz/quizRank.jsp" />
   <jsp:include page = "/WEB-INF/views/widget/dictionary.jsp" />


</div>