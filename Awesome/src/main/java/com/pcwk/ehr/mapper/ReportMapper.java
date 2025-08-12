package com.pcwk.ehr.mapper;

import java.util.List;

import com.pcwk.ehr.cmn.WorkDiv;
import com.pcwk.ehr.report.domain.ReportDTO;
import com.pcwk.ehr.report.domain.ReportSearchDTO;

public interface ReportMapper extends WorkDiv<ReportDTO> {

    int getCount();
        
    int deleteAll();
    
    // 상태만 바꾸는 전용 메서드가 필요하면 유지
    int doUpdateStatus(ReportDTO param);

	List<ReportDTO> doRetrieve(ReportSearchDTO cond);
}
