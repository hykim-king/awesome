/**
 * Package Name : com.pcwk.ehr.cmn.aspect <br/>
 * 파일명: PerformanceAdvice.java <br/>
 */
package com.pcwk.ehr.cmn.aspect;

import org.aspectj.lang.ProceedingJoinPoint;

import com.pcwk.ehr.cmn.PLog;

public class PerformanceAdvice implements PLog {

	public Object logExecutionTime(ProceedingJoinPoint pjp) throws Throwable {
		Object retObj = null;
		long start = System.currentTimeMillis();
		
		// 클래스 명
		String className = pjp.getTarget().getClass().getName();
		// 메소드 명
		String methodName = pjp.getSignature().getName();
			
		//대상 메소드 실행
		retObj = pjp.proceed();
		long end = System.currentTimeMillis();
		log.debug("│ ***className()***       │" + className);
		log.debug("│ ***methodName()***      │" + methodName);
		long executionTime = end - start;
		log.debug("^^^^^executiontime:"+executionTime+"ms");
		return retObj;

	}

}
