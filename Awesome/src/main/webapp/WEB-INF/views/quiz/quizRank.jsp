<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="CP" value="${pageContext.request.contextPath }" />

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
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
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
    <div id="ranking-list-container">
        <p class="no-data-message">랭킹을 불러오는 중...</p>
    </div>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
$(document).ready(function() {
    function loadRanking() {
        $.ajax({
            url: "${CP}/quiz/ranking.do",
            type: "GET",
            dataType: "json",
            success: function(rankingList) {
                let rankingContainer = $('#ranking-list-container');
                rankingContainer.empty();

                if (rankingList && rankingList.length > 0) {
                    $.each(rankingList, function(index, rank) {
                        let rankHtml;
                        let userRank = parseInt(rank.userRank, 10);
                        
                        if (userRank === 1) {
                            rankHtml = '<img src="https://i.imgur.com/gold_crown_icon.png" alt="1위" class="rank-icon">';
                        } else if (userRank === 2) {
                            rankHtml = '<img src="https://i.imgur.com/silver_crown_icon.png" alt="2위" class="rank-icon">';
                        } else if (userRank === 3) {
                            rankHtml = '<img src="https://i.imgur.com/bronze_crown_icon.png" alt="3위" class="rank-icon">';
                        } else {
                            rankHtml = '<span class="rank-icon">' + userRank + '</span>';
                        }
                        
                        // Create elements one by one to avoid potential string errors
                        let rankingItem = $('<div>').addClass('ranking-item');
                        let rankInfo = $('<div>').addClass('rank-info');
                        
                        let nickname = $('<span>').addClass('nickname').text(rank.userId);
                        let score = $('<span>').addClass('score').text(rank.totalScore + '점');

                        rankInfo.append(nickname).append(score);
                        rankingItem.append(rankHtml).append(rankInfo);
                        
                        rankingContainer.append(rankingItem);
                    });
                } else {
                    rankingContainer.append('<p class="no-data-message">아직 랭킹 정보가 없습니다.</p>');
                }
            },
            error: function(xhr, status, error) {
                console.error("랭킹 데이터를 가져오는 중 오류 발생:", error);
                $('#ranking-list-container').html('<p class="no-data-message">랭킹 정보를 불러올 수 없습니다.</p>');
            }
        });
    }

    loadRanking();
    setInterval(loadRanking, 30000);
});
</script>