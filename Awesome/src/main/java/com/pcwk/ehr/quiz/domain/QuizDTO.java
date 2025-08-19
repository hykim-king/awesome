package com.pcwk.ehr.quiz.domain;

import java.util.Date;

public class QuizDTO {
	
	// ========== 페이징 처리를 위한 파라미터 ==========
    private int pageStart;
    private int pageEnd;

    // ========== QUIZ_QUESTIONS 테이블 컬럼 ==========
    private long qsCode;
    private long qqCode;
    private long articleCode;
    private int questionNo;
    private String question;
    private String answer;
    private String explanation;
    private Date regDt;

    // ========== QUIZ_RESULT 테이블 컬럼 ==========
    private long qrCode;
    private String userId;
    private String userAnswer;
    private double score; // 주의: 테이블은 NUMBER(3,0)이지만, 12.5점을 처리하기 위해 double 사용
    private Date solvedDt;

    // ========== 랭킹 조회를 위한 추가 필드 ==========
    private double totalScore;
    private int userRank;
    
    public QuizDTO(){}

	/**
	 * @return the pageStart
	 */
	public int getPageStart() {
		return pageStart;
	}

	/**
	 * @param pageStart the pageStart to set
	 */
	public void setPageStart(int pageStart) {
		this.pageStart = pageStart;
	}

	/**
	 * @return the pageEnd
	 */
	public int getPageEnd() {
		return pageEnd;
	}

	/**
	 * @param pageEnd the pageEnd to set
	 */
	public void setPageEnd(int pageEnd) {
		this.pageEnd = pageEnd;
	}

	/**
	 * @return the qsCode
	 */
	public long getQsCode() {
		return qsCode;
	}

	/**
	 * @param qsCode the qsCode to set
	 */
	public void setQsCode(long qsCode) {
		this.qsCode = qsCode;
	}

	/**
	 * @return the qqCode
	 */
	public long getQqCode() {
		return qqCode;
	}

	/**
	 * @param qqCode the qqCode to set
	 */
	public void setQqCode(long qqCode) {
		this.qqCode = qqCode;
	}

	/**
	 * @return the articleCode
	 */
	public long getArticleCode() {
		return articleCode;
	}

	/**
	 * @param articleCode the articleCode to set
	 */
	public void setArticleCode(long articleCode) {
		this.articleCode = articleCode;
	}

	/**
	 * @return the questionNo
	 */
	public int getQuestionNo() {
		return questionNo;
	}

	/**
	 * @param questionNo the questionNo to set
	 */
	public void setQuestionNo(int questionNo) {
		this.questionNo = questionNo;
	}

	/**
	 * @return the question
	 */
	public String getQuestion() {
		return question;
	}

	/**
	 * @param question the question to set
	 */
	public void setQuestion(String question) {
		this.question = question;
	}

	/**
	 * @return the answer
	 */
	public String getAnswer() {
		return answer;
	}

	/**
	 * @param answer the answer to set
	 */
	public void setAnswer(String answer) {
		this.answer = answer;
	}

	/**
	 * @return the explanation
	 */
	public String getExplanation() {
		return explanation;
	}

	/**
	 * @param explanation the explanation to set
	 */
	public void setExplanation(String explanation) {
		this.explanation = explanation;
	}

	/**
	 * @return the regDt
	 */
	public Date getRegDt() {
		return regDt;
	}

	/**
	 * @param regDt the regDt to set
	 */
	public void setRegDt(Date regDt) {
		this.regDt = regDt;
	}

	/**
	 * @return the qrCode
	 */
	public long getQrCode() {
		return qrCode;
	}

	/**
	 * @param qrCode the qrCode to set
	 */
	public void setQrCode(long qrCode) {
		this.qrCode = qrCode;
	}

	/**
	 * @return the userId
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * @param userId the userId to set
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * @return the userAnswer
	 */
	public String getUserAnswer() {
		return userAnswer;
	}

	/**
	 * @param userAnswer the userAnswer to set
	 */
	public void setUserAnswer(String userAnswer) {
		this.userAnswer = userAnswer;
	}

	/**
	 * @return the score
	 */
	public double getScore() {
		return score;
	}

	/**
	 * @param score the score to set
	 */
	public void setScore(double score) {
		this.score = score;
	}

	/**
	 * @return the solvedDt
	 */
	public Date getSolvedDt() {
		return solvedDt;
	}

	/**
	 * @param solvedDt the solvedDt to set
	 */
	public void setSolvedDt(Date solvedDt) {
		this.solvedDt = solvedDt;
	}

	/**
	 * @return the totalScore
	 */
	public double getTotalScore() {
		return totalScore;
	}

	/**
	 * @param totalScore the totalScore to set
	 */
	public void setTotalScore(double totalScore) {
		this.totalScore = totalScore;
	}

	/**
	 * @return the userRank
	 */
	public int getUserRank() {
		return userRank;
	}

	/**
	 * @param userRank the userRank to set
	 */
	public void setUserRank(int userRank) {
		this.userRank = userRank;
	}

	/**
	 * @param pageStart
	 * @param pageEnd
	 * @param qsCode
	 * @param qqCode
	 * @param articleCode
	 * @param questionNo
	 * @param question
	 * @param answer
	 * @param explanation
	 * @param regDt
	 * @param qrCode
	 * @param userId
	 * @param userAnswer
	 * @param score
	 * @param solvedDt
	 * @param totalScore
	 * @param userRank
	 */
	public QuizDTO(int pageStart, int pageEnd, long qsCode, long qqCode, long articleCode, int questionNo,
			String question, String answer, String explanation, Date regDt, long qrCode, String userId,
			String userAnswer, double score, Date solvedDt, double totalScore, int userRank) {
		super();
		this.pageStart = pageStart;
		this.pageEnd = pageEnd;
		this.qsCode = qsCode;
		this.qqCode = qqCode;
		this.articleCode = articleCode;
		this.questionNo = questionNo;
		this.question = question;
		this.answer = answer;
		this.explanation = explanation;
		this.regDt = regDt;
		this.qrCode = qrCode;
		this.userId = userId;
		this.userAnswer = userAnswer;
		this.score = score;
		this.solvedDt = solvedDt;
		this.totalScore = totalScore;
		this.userRank = userRank;
	}

	@Override
	public String toString() {
		return "QuizDTO [pageStart=" + pageStart + ", pageEnd=" + pageEnd + ", qsCode=" + qsCode + ", qqCode=" + qqCode
				+ ", articleCode=" + articleCode + ", questionNo=" + questionNo + ", question=" + question + ", answer="
				+ answer + ", explanation=" + explanation + ", regDt=" + regDt + ", qrCode=" + qrCode + ", userId="
				+ userId + ", userAnswer=" + userAnswer + ", score=" + score + ", solvedDt=" + solvedDt
				+ ", totalScore=" + totalScore + ", userRank=" + userRank + "]";
	}
    
    
    
    

}
