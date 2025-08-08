package com.pcwk.ehr.member.domain;


import java.util.Date;

public class MemberDTO {

	private String userId; // USER_ID: VARCHAR2(30 BYTE), PK
	private String pwd; // PWD: VARCHAR2(20 BYTE)
	private String userNm; // USER_NM: VARCHAR2(8 CHAR)
	private String nickNm; // NICK_NM: VARCHAR2(50 BYTE)
	private String birthDt; // BIRTH_DT: VARCHAR2(10 BYTE) YYYYMMDD
	private String mailAddr; // MAIL_ADDR: VARCHAR2(100 BYTE)
	private String emailAuthYn; // EMAIL_AUTH_YN: VARCHAR2(2 CHAR) -> 'Y' or 'N'
	private String emailAuthToken; // EMAIL_AUTH_TOKEN: VARCHAR2(100 BYTE)
	private int userGradeCd; // USER_GRADE_CD: NUMBER(1,0) → Oracle NUMBER는 Java에서 String 또는 int 사용 가능
	private Date regDt; // REG_DT: DATE
	private Date modDt; // MOD_DT: DATE
	/**
	 * 
	 */
	public MemberDTO() {
	}
	/**
	 * @param userId
	 * @param pwd
	 * @param userNm
	 * @param nickNm
	 * @param birthDt
	 * @param mailAddr
	 * @param emailAuthYn
	 * @param emailAuthToken
	 * @param userGradeCd
	 * @param regDt
	 * @param modDt
	 */
	public MemberDTO(String userId, String pwd, String userNm, String nickNm, String birthDt, String mailAddr,
			String emailAuthYn, String emailAuthToken, int userGradeCd, Date regDt, Date modDt) {
		super();
		this.userId = userId;
		this.pwd = pwd;
		this.userNm = userNm;
		this.nickNm = nickNm;
		this.birthDt = birthDt;
		this.mailAddr = mailAddr;
		this.emailAuthYn = emailAuthYn;
		this.emailAuthToken = emailAuthToken;
		this.userGradeCd = userGradeCd;
		this.regDt = regDt;
		this.modDt = modDt;
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
	 * @return the pwd
	 */
	public String getPwd() {
		return pwd;
	}
	/**
	 * @param pwd the pwd to set
	 */
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	/**
	 * @return the userNm
	 */
	public String getUserNm() {
		return userNm;
	}
	/**
	 * @param userNm the userNm to set
	 */
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	/**
	 * @return the nickNm
	 */
	public String getNickNm() {
		return nickNm;
	}
	/**
	 * @param nickNm the nickNm to set
	 */
	public void setNickNm(String nickNm) {
		this.nickNm = nickNm;
	}
	/**
	 * @return the birthDt
	 */
	public String getBirthDt() {
		return birthDt;
	}
	/**
	 * @param birthDt the birthDt to set
	 */
	public void setBirthDt(String birthDt) {
		this.birthDt = birthDt;
	}
	/**
	 * @return the mailAddr
	 */
	public String getMailAddr() {
		return mailAddr;
	}
	/**
	 * @param mailAddr the mailAddr to set
	 */
	public void setMailAddr(String mailAddr) {
		this.mailAddr = mailAddr;
	}
	/**
	 * @return the emailAuthYn
	 */
	public String getEmailAuthYn() {
		return emailAuthYn;
	}
	/**
	 * @param emailAuthYn the emailAuthYn to set
	 */
	public void setEmailAuthYn(String emailAuthYn) {
		this.emailAuthYn = emailAuthYn;
	}
	/**
	 * @return the emailAuthToken
	 */
	public String getEmailAuthToken() {
		return emailAuthToken;
	}
	/**
	 * @param emailAuthToken the emailAuthToken to set
	 */
	public void setEmailAuthToken(String emailAuthToken) {
		this.emailAuthToken = emailAuthToken;
	}
	/**
	 * @return the userGradeCd
	 */
	public int getUserGradeCd() {
		return userGradeCd;
	}
	/**
	 * @param userGradeCd the userGradeCd to set
	 */
	public void setUserGradeCd(int userGradeCd) {
		this.userGradeCd = userGradeCd;
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
	 * @return the modDt
	 */
	public Date getModDt() {
		return modDt;
	}
	/**
	 * @param modDt the modDt to set
	 */
	public void setModDt(Date modDt) {
		this.modDt = modDt;
	}
	@Override
	public String toString() {
		return "MemberDTO [userId=" + userId + ", pwd=" + pwd + ", userNm=" + userNm + ", nickNm=" + nickNm
				+ ", birthDt=" + birthDt + ", mailAddr=" + mailAddr + ", emailAuthYn=" + emailAuthYn
				+ ", emailAuthToken=" + emailAuthToken + ", userGradeCd=" + userGradeCd + ", regDt=" + regDt
				+ ", modDt=" + modDt + "]";
	}
			
}