<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>   

<style>
  /* 사이드바 내부 카드들은 부모폭 100% 사용 */
  #sidebar_category .chat-wrap,
  #sidebar_category .dict-wrap,
  #sidebar_category .quiz-ranking-wrap{
    width:100%;
    max-width:none;
    margin:0;
  }
  
</style>
<div id="sidebar">
            <jsp:include page = "/WEB-INF/views/quiz/quizRank.jsp" />
            <jsp:include page = "/WEB-INF/views/chat/chat.jsp" />
            <jsp:include page = "/WEB-INF/views/widget/dictionary.jsp" />
</div>

<script>
/*chat.jsp 자식만으로 부모인 <aside> width 바꿀수가 없어서, JSP 내부 스크립트로 직접 style을 하기 위해서 세팅함.*/
(function(){
  // 이 JSP의 루트 엘리먼트
  var root = document.getElementById('sidebar_category');
  if(!root) return;

  // 이 루트가 들어 있는 부모 <aside>를 찾는다
  var host = root.closest('aside');         
  // 혹시 구조가 다르면 fallback
  if(!host) host = root.parentElement;

  if(host){
    var W = 479; // 사이드바 가로폭 수정은 여기서 하면됨
    host.style.width    = W + 'px';
    host.style.flex     = '0 0 ' + W + 'px'; 
    host.style.maxWidth = 'none';
    host.style.overflow = 'visible';
  }
})();
</script>