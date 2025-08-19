package com.pcwk.ehr.report.service;

import java.util.List;

import com.pcwk.ehr.report.domain.ReportDTO;
import com.pcwk.ehr.report.domain.ReportSearchDTO;

public interface ReportService {
	
	int doSave(ReportDTO dto) throws Exception;
	
	ReportDTO doSelectOne(int reportCode) throws Exception;
	
	List<ReportDTO> doRetrieve(ReportSearchDTO cond) throws Exception;
	
	int doUpdate(ReportDTO dto) throws Exception;
	
	int doUpdateStatus(int reportCode, int status) throws Exception;
	
	int doDelete(int reportCode) throws Exception;
	
	int deleteAll() throws Exception;
	
	int getCount(ReportSearchDTO cond) throws Exception;

}
