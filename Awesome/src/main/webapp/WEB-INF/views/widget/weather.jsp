<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
  /* 컨테이너 & 지도 */
  .weather-map{ position:relative; width:100%; max-width:520px; margin:0 auto; }
  .map-image{
    display:block; width:100%; height:auto;
    background:#eef3ff; /* 로드 실패 시 틀 보이게 */
    border-radius:12px;
  }

  /* 라벨 공통 */
  .city-label{
    position:absolute; transform:translate(-50%, -100%);
    background:rgba(255,255,255,.8); border:1px solid rgba(0,0,0,.06);
    padding:6px 8px; border-radius:8px; box-shadow:0 1px 4px rgba(0,0,0,.08);
    font-size:10px; line-height:1.1; white-space:nowrap; text-align:center;
  }
  .city-label .city-name{ font-weight:600; }
  .city-label .temp{ font-weight:600; }
  .weather-error{
    position:absolute; left:50%; top:50%; transform:translate(-50%, -50%);
    background:rgba(0,0,0,.6); color:#fff; padding:8px 12px; border-radius:8px;
  }

  /* ===== 이미지 비율 기준 좌표===추후 작업 必==========*/

  .city-label.서울 { top:19%; left:41%; }
  .city-label.인천 { top:25%; left:20%; }
  .city-label.춘천 { top:17%; left:59%; }

  /* 중부 */

  .city-label.대전 { top:46%; left:47%; }

  /* 영남 */
  .city-label.대구 { top:62%; left:65%; }

  .city-label.울산 { top:64%; left:83%; }
  .city-label.부산 { top:75%; left:71%; }

  /* 호남 */
  .city-label.광주 { top:62%; left:36%; }

  /* 제주 */
  .city-label.제주 { top:98%; left:20%; }
</style>

<div class="weather-map">
  <!-- 지도 배경 (로드 실패 시 폴백 이미지/색) -->
  <img
    src="${ctx}/resources/file/map_of_Korea_3.png"
    alt="대한민국 지도"
    class="map-image"
    onerror="this.onerror=null; this.style.background='#ddd'; this.alt='지도 로드 실패';"
  />

  <c:choose>
    <c:when test="${not empty weatherList}">
      <c:forEach var="w" items="${weatherList}">
        <!-- cityName은 '서울', '부산' 처럼 라벨 클래스와 동일하게 내려온다고 가정 -->
        <div class="city-label ${w.cityName}">
          <span class="city-name"><c:out value="${w.cityName}" /></span><br/>
          <span class="temp"><fmt:formatNumber value="${w.temperature}" pattern="#0"/>℃</span><br/>
          <span class="status"><c:out value="${w.pty gt 0 ? w.ptyText : w.skyText}" /></span>
        </div>
      </c:forEach>
    </c:when>
    <c:otherwise>
      <p class="weather-error">날씨 데이터를 불러오는 중입니다…</p>
    </c:otherwise>
  </c:choose>
</div>