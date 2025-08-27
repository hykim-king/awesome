<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 
 <style>
  .quiz-ranking-sidebar {
  width: 385px;
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 15px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
  margin-left: 20px;
  background-color: #f9f9f9;
  }
  
  .quiz-ranking-sidebar h2 {
  text-align: center;
  color: #333;
  margin-top: 0;
  font-size: 1.1rem;
  margin-bottom: 15px;
  }
  
  .ranking-item {
  display: flex;
  align-items: center;
  padding: 8px 0;
  border-bottom: 1px solid #eee;
  }
  
  .ranking-item:last-child {
  border-bottom: none;
  }
  
  .rank-icon {
  width: 24px;
  height: 24px;
  margin-right: 10px;
  }
  
  .rank-info {
  flex-grow: 1;
  display: flex;
  justify-content: space-between;
  align-items: center;
  }
  
  .nickname {
  font-size: 0.9rem;
  color: #555;
  }
  
  .score {
  font-size: 0.9rem;
  color: #3498db;
  font-weight: bold;
  }
  
  .no-data-message {
  text-align: center;
  padding: 20px;
  color: #888;
  font-size: 0.85rem;
  }
 </style>
 
 <div class="quiz-ranking-sidebar">
  <h2>🏆 오늘의 퀴즈 랭킹</h2>
  <c:choose>
  <c:when test="${not empty rankingList}">
  <c:forEach var="rank" items="${rankingList}" varStatus="loop">
  <div class="ranking-item">
  <c:choose>
  <c:when test="${loop.index == 0}">
  <img src="https://i.imgur.com/gold_crown_icon.png" alt="1위" class="rank-icon">
  </c:when>
  <c:when test="${loop.index == 1}">
  <img src="https://i.imgur.com/silver_crown_icon.png" alt="2위" class="rank-icon">
  </c:when>
  <c:when test="${loop.index == 2}">
  <img src="https://i.imgur.com/bronze_crown_icon.png" alt="3위" class="rank-icon">
  </c:when>
  <c:otherwise>
  <img src="https://i.imgur.com/default_rank_icon.png" alt="${rank.userRank}위" class="rank-icon">
  </c:otherwise>
  </c:choose>
  <div class="rank-info">
  <span class="nickname">${rank.userId}</span>
  <span class="score">${rank.totalScore}</span>
  </div>
  </div>
  </c:forEach>
  </c:when>
  <c:otherwise>
  <p class="no-data-message">아직 랭킹 정보가 없습니다.</p>
  </c:otherwise>
  </c:choose>
 </div>
 
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
 <script>
  $(document).ready(function() {
  function loadRanking() {
  $.ajax({
  url: "/quiz/ranking.do",
  type: "GET",
  dataType: "json",
  success: function(rankingList) {
  let rankingContainer = $('.quiz-ranking-sidebar');
  rankingContainer.empty().append('<h2>🏆 오늘의 퀴즈 랭킹</h2>');
  
  if (rankingList.length > 0) {
  $.each(rankingList, function(index, rank) {
  let rankIcon = '';
  if (index === 0) {
  rankIcon = '<img src="https://i.imgur.com/gold_crown_icon.png" alt="1위" class="rank-icon">';
  } else if (index === 1) {
  rankIcon = '<img src="https://i.imgur.com/silver_crown_icon.png" alt="2위" class="rank-icon">';
  } else if (index === 2) {
  rankIcon = '<img src="https://i.imgur.com/bronze_crown_icon.png" alt="3위" class="rank-icon">';
  } else {
  rankIcon = '<img src="https://i.imgur.com/default_rank_icon.png" alt="' + rank.userRank + '위" class="rank-icon">';
  }
  
  let rankingItem = $('<div class="ranking-item"></div>');
  let rankInfo = $('<div class="rank-info"></div>');
  rankInfo.append('<span class="nickname">' + rank.userId + '</span>');
  rankInfo.append('<span class="score">' + rank.totalScore + '</span>');
  
  rankingItem.append(rankIcon).append(rankInfo);
  rankingContainer.append(rankingItem);
  });
  } else {
  rankingContainer.append('<p class="no-data-message">아직 랭킹 정보가 없습니다.</p>');
  }
  },
  error: function(xhr, status, error) {
  console.error("랭킹 데이터를 가져오는 중 오류 발생:", error);
  }
  });
  }
  
  loadRanking();
  setInterval(loadRanking, 30000); // 30초마다 랭킹 업데이트 (선택 사항)
  });
 </script>