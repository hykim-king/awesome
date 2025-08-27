package com.pcwk.ehr.report.service;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

	// CREATE
	@Override
	@Transactional(rollbackFor = Exception.class) // db 작업 중 예외 발생 시 롤백
	public int doSave(ReportDTO dto) throws SQLException {

		// 기본 유효성 검증
		if (dto == null)
			throw new IllegalArgumentException("dto is null");
		if (dto.getChatCode() <= 0)
			throw new IllegalArgumentException("chatCode");
		if (dto.getUserId() == null || dto.getUserId().trim().isEmpty())
			throw new IllegalArgumentException("userId");
		if (dto.getReason() == null || dto.getReason().trim().isEmpty())
			throw new IllegalArgumentException("reason");
		if (dto.getStatus() == null || dto.getStatus().trim().isEmpty())
			dto.setStatus("접수");

		// mapper 호출 -> 실제 doSave 실행
		return mapper.doSave(dto);

	}

	// READ
	@Override
	public ReportDTO doSelectOne(int reportCode) {

		ReportDTO param = new ReportDTO();
		param.setReportCode(reportCode);

		return mapper.doSelectOne(param);
	}

	@Override
	public List<ReportDTO> doRetrieve(ReportSearchDTO cond) throws SQLException {

		if (cond == null)
			cond = new ReportSearchDTO(); // null 방지

		cond.recalc();

		return mapper.doRetrieve(cond);
	}

	@Override
	public int getCount(ReportSearchDTO cond) throws Exception {
		return mapper.getCount(cond);
	}

	// UPDATE
	@Override
	@Transactional(rollbackFor = Exception.class)
	public int doUpdate(ReportDTO dto) throws SQLException {
		if (dto == null || dto.getReportCode() <= 0)
			throw new IllegalArgumentException("reportCode");

		// mapper 호출 -> update 실행
		return mapper.doUpdate(dto);
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public int doUpdateStatus(int reportCode, String status) throws SQLException {

		if (reportCode <= 0)
			throw new IllegalArgumentException("reportCode is required");
		if (status == null || status.trim().isEmpty())
			throw new IllegalArgumentException("status is required");

		// 상태값만 바꿔서 전달할 DTO 생성
		ReportDTO dto = new ReportDTO();
		dto.setReportCode(reportCode);
		dto.setStatus(status);

		// Mapper 호출 → 상태 UPDATE 실행
		return mapper.doUpdateStatus(dto);
	}

	// Delete
	@Override
	@Transactional(rollbackFor = Exception.class)
	public int doDelete(int reportCode) throws SQLException {
		if (reportCode <= 0)
			throw new IllegalArgumentException("reportCode is required");

		ReportDTO dto = new ReportDTO();
		dto.setReportCode(reportCode);
		return mapper.doDelete(dto); // Mapper 호출 → DELETE 실행
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public int deleteAll() {
		return mapper.deleteAll();
	}

	@Override
	public int getCountById(String userId) {
		return mapper.getCountById(userId);
	}

}
