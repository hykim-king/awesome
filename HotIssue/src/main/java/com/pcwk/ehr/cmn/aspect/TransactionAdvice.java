package com.pcwk.ehr.cmn.aspect;

import org.aspectj.lang.ProceedingJoinPoint;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import com.pcwk.ehr.cmn.PLog;

public class TransactionAdvice implements PLog{
	private PlatformTransactionManager transactionManager;
	
	
	public void setTransactionManager(PlatformTransactionManager transactionManager) {
		this.transactionManager = transactionManager;
	}



	public Object manageTransaction(ProceedingJoinPoint pjp) throws Throwable {
		Object retObj = null;
		TransactionStatus status = transactionManager.getTransaction(new DefaultTransactionDefinition());
		try {
			// 클래스 명
			String className = pjp.getTarget().getClass().getName();
			// 메소드 명
			String methodName = pjp.getSignature().getName();
			
			log.debug("│ ***className()***       │" + className);
			log.debug("│ ***methodName()***      │" + methodName);
			
			//대상 메소드 실행
			retObj = pjp.proceed();
			transactionManager.commit(status);
		}catch(Throwable e){
			transactionManager.rollback(status);
			throw e;
		}

		
		return retObj;
	}

}
