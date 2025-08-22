package com.pcwk.ehr.report.service;

import java.util.List;

import com.pcwk.ehr.report.domain.ReportDTO;
import com.pcwk.ehr.report.domain.ReportSearchDTO;

public interface ReportService {

	//C
	int doSave(ReportDTO dto) throws Exception;

	//R
	ReportDTO doSelectOne(int reportCode) throws Exception;
	List<ReportDTO> doRetrieve(ReportSearchDTO cond) throws Exception;
	int getCount(ReportSearchDTO cond) throws Exception;

	//U
	int doUpdate(ReportDTO dto) throws Exception; //동적 수정
	int doUpdateStatus(int reportCode, String status) throws Exception; //상태만 변경

	//D
	int doDelete(int reportCode) throws Exception;

	int deleteAll();

}
