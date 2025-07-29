/**
 * Package Name : com.pcwk.ehr.user <br/>
 * 파일명: UserServiceTest.java <br/>
 */
package com.pcwk.ehr.user;

import static com.pcwk.ehr.user.service.UserService.MIN_LOGIN_COUNT_FOR_SILVER;
import static com.pcwk.ehr.user.service.UserService.MIN_RECOMMAND_FOR_GOLD;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import javax.sql.DataSource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationContext;
import org.springframework.mail.MailSender;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.PlatformTransactionManager;

import com.pcwk.ehr.user.dao.UserDao;
import com.pcwk.ehr.user.domain.Level;
import com.pcwk.ehr.user.domain.UserDTO;
import com.pcwk.ehr.user.service.TestUserService;
import com.pcwk.ehr.user.service.UserService;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml"
		,"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
class UserServiceTest {
	Logger log = LogManager.getLogger(getClass());

	@Autowired
	ApplicationContext context;

	@Autowired
	UserService userService;

	@Autowired
	UserDao userDao;

	List<UserDTO> users;

	@Autowired
	DataSource dataSource;

	@Autowired
	PlatformTransactionManager transactionManager;

	@Qualifier("dummyMailService")
	@Autowired
	MailSender mailSender;

//	@Autowired
//	TestUserService testUserService;

	@BeforeEach
	void setUp() throws Exception {
		log.debug("┌─────────────────────────────────────────────────────────┐");
		log.debug("│ setUp()                                                 │");
		log.debug("└─────────────────────────────────────────────────────────┘");

		users = Arrays.asList(
				// BASIC 그대로
				// BASIC -> SILVER
				// SILVER 그대로
				// SILVER -> GOLD
				// GOLD 그대로
				new UserDTO("pcwk01", "이상무01", "4321a", "사용안함", MIN_LOGIN_COUNT_FOR_SILVER - 1, 0, Level.BASIC,
						"dlwhd0614@naver.com"),
				new UserDTO("pcwk02", "이상무02", "4321b", "BASIC -> SILVER", MIN_LOGIN_COUNT_FOR_SILVER, 0, Level.BASIC,
						"dlwhd0614@naver.com"),
				new UserDTO("pcwk03", "이상무03", "4321c", "사용안함", MIN_LOGIN_COUNT_FOR_SILVER + 10,
						MIN_RECOMMAND_FOR_GOLD - 1, Level.SILVER, "dlwhd0614@naver.com"),
				new UserDTO("pcwk04", "이상무04", "4321d", "SILBER -> GOLD", 60, MIN_RECOMMAND_FOR_GOLD, Level.SILVER,
						"dlwhd0614@naver.com"),
				new UserDTO("pcwk05", "이상무05", "4321e", "사용안함", MIN_LOGIN_COUNT_FOR_SILVER + 40,
						MIN_RECOMMAND_FOR_GOLD + 7, Level.GOLD, "dlwhd0614@naver.com"));
	}

	@AfterEach
	void tearDown() throws Exception {
		log.debug("┌─────────────────────────────────────────────────────────┐");
		log.debug("│ tearDown()                                              │");
		log.debug("└─────────────────────────────────────────────────────────┘");
	}

	@Disabled
	@Test
	void updateAllOrNothing() throws SQLException {
		log.debug("┌─────────────────────────────────────────────────────────┐");
		log.debug("│ *updateAllOrNothing()*                                  │");
		log.debug("└─────────────────────────────────────────────────────────┘");


		try {
			userDao.deleteAll();
			assertEquals(0, userDao.getCount());

			for (UserDTO dto : users) {
				userDao.doSave(dto);
			}

			assertEquals(5, userDao.getCount());

			//testUserService.upgradeLevels();

		} catch (Exception e) {
			log.debug("┌─────────────────────────────────────────────────────────┐");
			log.debug("│ *Exception*                                             │" + e.getMessage());
			log.debug("└─────────────────────────────────────────────────────────┘");
		}
		checkLevel(users.get(1), false);

	}

	//@Disabled
	@Test
	public void doSave() throws SQLException {

		log.debug("┌─────────────────────────────────────────────────────────┐");
		log.debug("│ *doSave()*                                              │");
		log.debug("└─────────────────────────────────────────────────────────┘");

		userDao.deleteAll();
		assertEquals(0, userDao.getCount());

		UserDTO userWithLevel = users.get(4);
		userService.doSave(userWithLevel);
		assertEquals(1, userDao.getCount());

		UserDTO userWithOutLevel = users.get(0);
		userWithOutLevel.setGrade(null);
		userService.doSave(userWithOutLevel);
		assertEquals(2, userDao.getCount());

		UserDTO userGold = userDao.doSelectOne(userWithLevel);
		UserDTO userBasic = userDao.doSelectOne(userWithOutLevel);

		assertEquals(userGold.getGrade(), Level.GOLD);
		assertEquals(userBasic.getGrade(), Level.BASIC);
	}

	//@Disabled
	@Test
	void upgradeLevels() throws SQLException {

		log.debug("┌─────────────────────────────────────────────────────────┐");
		log.debug("│ *upgradeLevels()*                                       │");
		log.debug("└─────────────────────────────────────────────────────────┘");

		userDao.deleteAll();
		assertEquals(0, userDao.getCount());

		for (UserDTO dto : users) {
			userDao.doSave(dto);
		}

		assertEquals(5, userDao.getCount());

		userService.upgradeLevels();

		userService.doSelectOne(users.get(0));
		checkLevel(users.get(0), false);
		checkLevel(users.get(1), true);
		checkLevel(users.get(2), false);
		checkLevel(users.get(3), true);
		checkLevel(users.get(4), false);
	}

	private void checkLevel(UserDTO user, boolean upgraded) throws SQLException {
		UserDTO upgradeUser = userDao.doSelectOne(user);

		if (true == upgraded) {
			assertEquals(upgradeUser.getGrade(), user.getGrade().getNextLevel());
		} else {
			assertEquals(upgradeUser.getGrade(), user.getGrade());
		}

	}

	@Test
	void beans() {
		assertNotNull(userDao);
		assertNotNull(context);
		assertNotNull(userService);
		assertNotNull(dataSource);
		// assertNotNull(transactionManager);
		assertNotNull(mailSender);

		log.debug("context:" + context);
		log.debug("userService:" + userService);
		log.debug("userDao:" + userDao);
		log.debug("dataSource:" + dataSource);
		// log.debug("transactionManager:" + transactionManager);
		log.debug("mailSender:" + mailSender);
	}

}
