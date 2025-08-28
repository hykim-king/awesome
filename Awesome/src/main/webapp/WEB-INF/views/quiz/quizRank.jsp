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

.ranking-header {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    margin-bottom: 15px;
}

.ranking-header h2 {
    margin: 0;
}

.current-date {
    font-size: 0.8rem;
    color: #777;
    margin-top: 5px;
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
    <div class="ranking-header">
        <h2>🏆 오늘의 퀴즈 랭킹</h2>
        <span id="current-date" class="current-date"></span>
    </div>
    <div id="ranking-list-container">
        <p class="no-data-message">랭킹을 불러오는 중...</p>
    </div>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
$(document).ready(function() {
    // 현재 날짜를 가져와서 포맷팅하는 함수
    function displayCurrentDate() {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const formattedDate = `${year}년 ${month}월 ${day}일`;
        $('#current-date').text(formattedDate);
    }

    // 랭킹 데이터를 로드하는 함수
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

    // 페이지 로드 시 랭킹 및 날짜 표시
    displayCurrentDate();
    loadRanking();
    
    // 30초마다 랭킹 데이터 갱신
    setInterval(loadRanking, 30000);
});
</script>