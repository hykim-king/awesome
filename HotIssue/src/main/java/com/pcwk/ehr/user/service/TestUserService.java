/**
 * Package Name : com.pcwk.ehr.user.service <br/>
 * 파일명: TestUserService.java <br/>
 */
package com.pcwk.ehr.user.service;

import com.pcwk.ehr.user.domain.UserDTO;

public class TestUserService extends UserServiceImpl {

	private String userId;

	public TestUserService(String userId) {
		super();
		this.userId = userId;
	}

	@Override
	protected void upgradeLevel(UserDTO user) {
		if (userId.equals(user.getUserId())) {
			System.out.println("TestUserService****>>");
			throw new TestUserServiceException("예외가 발생했습니다.\n 사용자 아이디:" + userId);
		}

		super.upgradeLevel(user);
	}

}
