package com.pcwk.ehr.quiz.domain;

import org.apache.ibatis.type.Alias;

@Alias("rankingDTO")
public class RankingDTO {

    private String userId;
    private double totalScore;
    private int userRank;

    // Getters and Setters
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public double getTotalScore() {
        return totalScore;
    }
    public void setTotalScore(double totalScore) {
        this.totalScore = totalScore;
    }
    public int getUserRank() {
        return userRank;
    }
    public void setUserRank(int userRank) {
        this.userRank = userRank;
    }
    
    @Override
    public String toString() {
        return "RankingDTO [userId=" + userId + ", totalScore=" + totalScore + ", userRank=" + userRank + "]";
    }
}