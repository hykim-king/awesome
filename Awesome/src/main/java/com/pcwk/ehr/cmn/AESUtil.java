package com.pcwk.ehr.cmn;

/**
 *대칭 키 알고리즘(Advanced Encyption Standard)
 *대칭 키 알고리즘은 **암호화와 복호화 과정에서 동일한 키를 사용하는 암호화 방식**입니다. 
 *즉, 정보를 암호화할 때 사용한 키와 동일한 키를 사용하여 암호문을 다시 평문으로 복호화할 수 있습니다. 
 *이 방식은 속도가 빠르다는 장점이 있지만, 키 관리가 중요하며, **키 교환 과정에서 보안에 유의**해야 합니다.
 *
 * @author user
 *
 */

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Base64;

public class AESUtil {
	Logger log = LogManager.getLogger(getClass());

	private static final String ALGORITHM = "AES";

	@Value("${aes.secret.key}")
	private String secretKey;

	/**
	 * 테스트용: 실 서비스에서는 삭제 할것
	 * 
	 * @return the secretKey
	 */
	public String getSecretKey() {
		return secretKey;
	}

	/**
	 * 복호화
	 * 
	 * @param encryptedTest
	 * @return String(복호화 문자열)
	 * @throws Exception
	 */
	public String decrypt(String encryptedTest) throws Exception {
		// 바이트 배열로 부터 AES용 키 객체 생성
		SecretKeySpec key = new SecretKeySpec(secretKey.getBytes(), ALGORITHM);
		Cipher cipher = Cipher.getInstance(ALGORITHM);// "AES" 알고리즘의 암호화 객체 생성
		cipher.init(Cipher.DECRYPT_MODE, key);// 복호화 모드로 초기화

		byte[] decoded = Base64.getDecoder().decode(encryptedTest);
		byte[] decrypted = cipher.doFinal(decoded);

		return new String(decrypted, "UTF-8");
	}

	/**
	 * 암호화
	 * 
	 * @param plainText(평문)
	 * @return String(암호화 String)
	 * @throws Exception
	 */
	public String encrypt(String plainText) throws Exception {
		// 바이트 배열로 부터 AES용 키 객체 생성
		SecretKeySpec key = new SecretKeySpec(secretKey.getBytes(), ALGORITHM);
		Cipher cipher = Cipher.getInstance(ALGORITHM);// "AES" 알고리즘의 암호화 객체 생성
		cipher.init(Cipher.ENCRYPT_MODE, key);// 암호화 모드로 초기화

		// plainText를 암호화
		// 입력 문자열을 UTF-8로 바이트 변환 ->AES 암호화
		byte[] encrypted = cipher.doFinal(plainText.getBytes("UTF-8"));
		// encrypted 결과는 바이너리이므로, Base64로 인코딩하여 문자열로 반환
		String encryptedBase64String = Base64.getEncoder().encodeToString(encrypted);
		// log.debug("plainText:"+plainText);
		log.debug("plainText.length:" + plainText.length());

		// log.debug("encrypted:"+encrypted);
		// log.debug("encryptedBase64String:"+encryptedBase64String);
		log.debug("encryptedBase64String.length():" + encryptedBase64String.length());
		return encryptedBase64String;

	}

}
