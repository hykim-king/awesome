package com.pcwk.ehr.user.service;

import java.sql.SQLException;
import java.util.List;

import com.pcwk.ehr.user.domain.UserDTO;

public interface UserService {

	// 상수
	int MIN_LOGIN_COUNT_FOR_SILVER = 50;
	int MIN_RECOMMAND_FOR_GOLD = 30;

	int doSave(UserDTO param) throws SQLException;

	UserDTO doSelectOne(UserDTO param) throws SQLException;

	int doUpdate(UserDTO param);

	int doDelete(UserDTO param);

	List<UserDTO> doretrieve(UserDTO param);

	// 전체 회원을 대상으로 등업
	void upgradeLevels() throws SQLException;

}