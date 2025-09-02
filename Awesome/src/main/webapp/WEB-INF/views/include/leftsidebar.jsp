<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>   

<style>
#leftsidebar .advertisement {
  text-align: center;   /* 가운데 정렬 */
  margin: 10px 0;
}
#leftsidebar .advertisement img {
  max-width: 70%;      /* 사이드바 너비에 맞춤 */
  height: auto;

}
</style>

<div id="leftsidebar">
  <div class="advertisement">
    <img src="<c:url value='/resources/file/adv03.png'/>" alt="광고">
  </div>

</div>