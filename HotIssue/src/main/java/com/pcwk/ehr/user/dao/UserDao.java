package com.pcwk.ehr.user.dao;

import java.sql.SQLException;
import java.util.List;

import com.pcwk.ehr.cmn.DTO;
import com.pcwk.ehr.user.domain.UserDTO;

public interface UserDao {

	int getCount() throws SQLException;

	List<UserDTO> doRetrieve(DTO param);

	int saveAll();

	int doDelete(UserDTO param);

	int doUpdate(UserDTO param);

	List<UserDTO> getAll();

	/**
	 * 전체 삭제
	 * 
	 * @throws SQLException
	 */
	void deleteAll() throws SQLException;

	/**
	 * 단건 조회
	 * 
	 * @param param
	 * @return UserDTO
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	UserDTO doSelectOne(UserDTO param) throws SQLException;

	/**
	 * 단건 등록
	 * 
	 * @param param
	 * @return 1(성공)/0(실패)
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	int doSave(UserDTO param) throws SQLException;

}