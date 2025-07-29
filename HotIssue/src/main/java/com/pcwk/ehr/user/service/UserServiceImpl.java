/**
 * Package Name : com.pcwk.ehr.user.service <br/>
 * 파일명: UserService.java <br/>
 */
package com.pcwk.ehr.user.service;

import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;

import com.pcwk.ehr.user.dao.UserDao;
import com.pcwk.ehr.user.domain.Level;
import com.pcwk.ehr.user.domain.UserDTO;

@Service
public class UserServiceImpl implements UserService {

	Logger log = LogManager.getLogger(getClass());

	@Qualifier("dummyMailService")
	@Autowired
	private MailSender mailSender;

	@Autowired
	private UserDao userDao;
	// 트랜잭션 동기화 적용

	public UserServiceImpl() {

	}


	@Override
	public int doSave(UserDTO param) throws SQLException {
		if (null == param.getGrade()) {
			param.setGrade(Level.BASIC);
		}
		return userDao.doSave(param);
	}

	@Override
	public UserDTO doSelectOne(UserDTO param) throws SQLException {
		return userDao.doSelectOne(param);
	}

	@Override
	public int doUpdate(UserDTO param) {
		return userDao.doUpdate(param);
	}

	@Override
	public int doDelete(UserDTO param) {
		return userDao.doDelete(param);
	}

	private void sendUpgradeEmail(UserDTO user) {
		// 보내는 사람
		// 받는 사람
		// 제목
		// 내용

		try {

			SimpleMailMessage message = new SimpleMailMessage();
			// 보내는 사람
			message.setFrom("dlwhd0614@naver.com");

			// 받는 사람
			message.setTo(user.getEmail());

			// 제목: 등업 안내
			message.setSubject("등업 안내");

			// 내용: {}님의 등급이 {GOLD}로 등업되었습니다.
			String contents = user.getName() + "님의 등급이" + user.getGrade() + "로 등업 되었습니다.";

			log.debug(contents);
			message.setText(contents);

		} catch (Exception e) {

			log.debug("┌─────────────────────────┐");
			log.debug("│ *sendUpgradeEmail. Exception()* │" + e.getMessage());
			log.debug("└─────────────────────────┘");

		}

	}

	@Override
	public List<UserDTO> doretrieve(UserDTO param) {
		return userDao.doRetrieve(param);
	}

	private boolean canUpgradeLevel(UserDTO user) {
		Level currentLevel = user.getGrade();

		switch (currentLevel) {
		case BASIC:
			return (user.getLogin() >= MIN_LOGIN_COUNT_FOR_SILVER);
		case SILVER:
			return (user.getRecommand() >= MIN_RECOMMAND_FOR_GOLD);
		case GOLD:
			return false;
		default:
			throw new IllegalArgumentException("Unknown Level:" + currentLevel);
		}
	}

	protected void upgradeLevel(UserDTO user) {
		if (Level.BASIC == user.getGrade()) {
			user.setGrade(Level.SILVER);
		} else if (Level.SILVER == user.getGrade()) {
			user.setGrade(Level.GOLD);
		}

		userDao.doUpdate(user);

		sendUpgradeEmail(user);
	}

	// 전체 회원을 대상으로 등업
	@Override
	public void upgradeLevels() throws SQLException {

		// PlatformTransactionManager transactionManager = new
		// DataSourceTransactionManager(dataSource);

		List<UserDTO> users = userDao.getAll();
		for (UserDTO user : users) {

			if (canUpgradeLevel(user)) {
				upgradeLevel(user);
			}
		}

	}

}
