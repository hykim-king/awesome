/**
 * Package Name : com.pcwk.ehr.user.domain <br/>
 * 파일명: UserDTO.java <br/>
 */
package com.pcwk.ehr.user.domain;

import com.pcwk.ehr.cmn.DTO;

public class UserDTO extends DTO {
	// 세로편집: Alt + Shift + A
	// 소문자 변환: Alt + Shift + Y
	// 대문자 변환: Alt + Shift + X

	// UserDTO
	// ---------------------------------------------------
	// 전역변수
	// Default 생성자
	// 인자있는 생성자
	// get/setters
	// toString()

	private String userId;// 사용자ID
	private String name;// 이름
	private String password;// 비밀번호
	private String regDt;// 등록일
//-------------------------------- 추가 ------------------------------------
	private int Login; /* 로그인 */
	private int Recommand; /* 추천 */
	private Level Grade; /* 등급 */
	private String Email; /* 이메일 */
//	로그인 : NUMBER(7)
//	추천 : NUMBER(7)
//	등급 : NUMBER(2)
//	이메일: VARCHAR2(320) 

	public UserDTO() {
	}

	/**
	 * @param userId
	 * @param name
	 * @param password
	 * @param regDt
	 * @param login
	 * @param recommand
	 * @param grade
	 * @param email
	 */
	public UserDTO(String userId, String name, String password, String regDt, int login, int recommand, Level grade,
			String email) {
		super();
		this.userId = userId;
		this.name = name;
		this.password = password;
		this.regDt = regDt;
		Login = login;
		Recommand = recommand;
		Grade = grade;
		Email = email;
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
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * @return the password
	 */
	public String getPassword() {
		return password;
	}

	/**
	 * @param password the password to set
	 */
	public void setPassword(String password) {
		this.password = password;
	}

	/**
	 * @return the regDt
	 */
	public String getRegDt() {
		return regDt;
	}

	/**
	 * @param regDt the regDt to set
	 */
	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}

	/**
	 * @return the login
	 */
	public int getLogin() {
		return Login;
	}

	/**
	 * @param login the login to set
	 */
	public void setLogin(int login) {
		Login = login;
	}

	/**
	 * @return the recommand
	 */
	public int getRecommand() {
		return Recommand;
	}

	/**
	 * @param recommand the recommand to set
	 */
	public void setRecommand(int recommand) {
		Recommand = recommand;
	}

	/**
	 * @return the grade
	 */
	public Level getGrade() {
		return Grade;
	}

	/**
	 * @param grade the grade to set
	 */
	public void setGrade(Level grade) {
		Grade = grade;
	}

	/**
	 * @return the email
	 */
	public String getEmail() {
		return Email;
	}

	/**
	 * @param email the email to set
	 */
	public void setEmail(String email) {
		Email = email;
	}

	@Override
	public String toString() {
		return "UserDTO [userId=" + userId + ", name=" + name + ", password=" + password + ", regDt=" + regDt
				+ ", Login=" + Login + ", Recommand=" + Recommand + ", Grade=" + Grade + ", Email=" + Email + "]";
	}

}
