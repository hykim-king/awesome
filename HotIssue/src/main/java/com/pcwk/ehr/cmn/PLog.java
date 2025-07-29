/**
 * Package Name : com.pcwk.ehr.cmn <br/>
 * 파일명: PLog.java <br/>
 */
package com.pcwk.ehr.cmn;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public interface PLog {
	Logger log = LogManager.getLogger(PLog.class);


}
