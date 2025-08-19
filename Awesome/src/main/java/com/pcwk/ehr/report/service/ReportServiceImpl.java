package com.pcwk.ehr.report.service;

import java.util.Date;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pcwk.ehr.mapper.ReportMapper;
import com.pcwk.ehr.report.domain.ReportDTO;
import com.pcwk.ehr.report.domain.ReportSearchDTO;

@Service
public class ReportServiceImpl implements ReportService {

	Logger log = LogManager.getLogger(getClass());
	
	@Autowired
	private ReportMapper mapper;
	
	public ReportServiceImpl() {
	}

	@Override
	public int doSave(ReportDTO dto) {
		
		Date now = new Date();
		dto.setRegDt(now);
		
		int flag = mapper.doSave(dto);
		log.debug("flag = {}",flag);
		
		if(flag >0) {
			ReportDTO saved = mapper.doSelectOne(dto);
			dto.setRegDt(saved.getRegDt());
		}
		return flag;
	}

	@Override
	public ReportDTO doSelectOne(int reportCode) {
		
		ReportDTO param = new ReportDTO();
		param.setReportCode(reportCode);
		
		return mapper.doSelectOne(param);
	}

	@Override
	public List<ReportDTO> doRetrieve(ReportSearchDTO cond) {
		cond.recalc();
		
		return mapper.doRetrieve(cond);
	}

	@Override
	public int doUpdate(ReportDTO dto) {
		return mapper.doUpdate(dto);
	}

	@Override
	public int doUpdateStatus(int reportCode, int status) {
		
		ReportDTO param = new ReportDTO();
		param.setReportCode(reportCode);
		
		return mapper.doUpdateStatus(param);
	}

	@Override
	public int doDelete(int reportCode) {
		ReportDTO param = new ReportDTO();
		param.setReportCode(reportCode);
		return mapper.doDelete(param);
	}

	@Override
	public int deleteAll() {
		return mapper.deleteAll();
	}

	@Override
	public int getCount() {
		return mapper.getCount();
	}

}
