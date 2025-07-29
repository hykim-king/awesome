/**
 * Package Name : com.pcwk.ehr.user.dao <br/>
 * 파일명: UserDao.java <br/>
 */
package com.pcwk.ehr.user.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Repository;

import com.pcwk.ehr.cmn.DTO;
import com.pcwk.ehr.cmn.PLog;
import com.pcwk.ehr.cmn.SearchDTO;
import com.pcwk.ehr.user.domain.UserDTO;

//@Component를 사용, DAO라는 의미로 @Repository 정의
@Repository
public class UserDaoImpl implements UserDao, PLog {

	final String NAMESPACE = "com.pcwk.ehr.user";
	final String DOT = ".";

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	public UserDaoImpl() {
	}

	/**
	 * 전체 삭제
	 * 
	 * @throws SQLException
	 */
	@Override
	public void deleteAll() throws SQLException {
		String statement = NAMESPACE + DOT + "deleteAll";
		log.debug("1. statement:" + statement);
		int flag = sqlSessionTemplate.delete(statement);
		log.debug("2. flag: {}", flag);

	}

	@Override
	public int getCount() throws SQLException {
		// select count(*) total_cnt from member

		int count = 0;
		String statement = NAMESPACE + DOT + "getCount";
		log.debug("1.statement:" + statement);

		count = sqlSessionTemplate.selectOne(statement);
		log.debug("2.count:" + count);

		return count;
	}

	@Override
	public List<UserDTO> doRetrieve(DTO param) {
		List<UserDTO> list = new ArrayList<UserDTO>();
		
		SearchDTO searchDTO = (SearchDTO) param;

		log.debug("1.param: {}", searchDTO);
		String statement = NAMESPACE + DOT + "doRetrieve";
		list = sqlSessionTemplate.selectList(statement, searchDTO);

		return list;

	}

	@Override
	public int saveAll() {
		int flag = 0;

		String statement = NAMESPACE + DOT + "saveAll";
		log.debug("1. statement:" + statement);

		flag = sqlSessionTemplate.insert(statement);
		log.debug("2. flag:" + flag);

		return flag;
	}

	@Override
	public int doDelete(UserDTO param) {
		int flag = 0;

		log.debug("1. param:" + param.toString());

		String statement = NAMESPACE + DOT + "doDelete";
		log.debug("2. statement:" + statement);

		flag = sqlSessionTemplate.delete(statement, param);
		log.debug("3. flag:" + flag);

		return flag;
	}

	@Override
	public int doUpdate(UserDTO param) {
		int flag = 0;

		String statement = NAMESPACE + DOT + "doUpdate";
		log.debug("1.statement:{}", statement);
		log.debug("2.param: {}", param);

		flag = sqlSessionTemplate.update(statement, param);
		log.debug("3.flag:" + flag);

		return flag;

	}

	@Override
	public List<UserDTO> getAll() {

		List<UserDTO> userList = new ArrayList<UserDTO>();

		String statement = NAMESPACE + DOT + "getAll";
		log.debug("1.statement:{}", statement);

		userList = sqlSessionTemplate.selectList(statement);
		for (UserDTO dto : userList) {

			log.debug(dto);
		}

		return userList;
	}

	/**
	 * 단건 조회
	 * 
	 * @param param
	 * @return UserDTO
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	@Override
	public UserDTO doSelectOne(UserDTO param) throws SQLException {
		UserDTO outDTO = null;
		// 3.1 sql

		Object[] args = { param.getUserId() };

		log.debug("2.param: {}", param);
		for (Object obj : args) {
			log.debug(obj.toString());
		}

		String statement = NAMESPACE + DOT + "doSelectOne";
		log.debug("2.statement:{}", statement);

		outDTO = sqlSessionTemplate.selectOne(statement, param);

		log.debug("3. outDTO: {}", outDTO);
		if (outDTO == null) {
			throw new EmptyResultDataAccessException(param.getUserId() + "(아이디)를 확인하세요.", 0);

		}

		return outDTO;
	}

	/**
	 * 단건 등록
	 * 
	 * @param param
	 * @return 1(성공)/0(실패)
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	@Override
	public int doSave(UserDTO param) throws SQLException {
		int flag = 0;
		log.debug("1.param: {}", param);

		String statement = NAMESPACE + DOT + "doSave";
		log.debug("2.statement:{}", statement);

		flag = sqlSessionTemplate.insert(statement, param);
		log.debug("3. flag:" + flag);

		return flag;
	}
}