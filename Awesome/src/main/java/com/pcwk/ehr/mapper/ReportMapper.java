package com.pcwk.ehr.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.pcwk.ehr.cmn.WorkDiv;
import com.pcwk.ehr.report.domain.ReportDTO;
import com.pcwk.ehr.report.domain.ReportSearchDTO;
@Mapper
public interface ReportMapper extends WorkDiv<ReportDTO> {

    int getCount(ReportSearchDTO cond);
        
    int deleteAll();
    
    // 상태만 바꾸는 전용 메서드가 필요하면 유지
    int doUpdateStatus(ReportDTO dto);
    
    //어드민 신고관리용
    int doUpdateStatus(@Param("reportCode") int reportCode,
            @Param("status") String status);

	List<ReportDTO> doRetrieve(ReportSearchDTO cond);
	

	 // 어드민: 신고코드 -> 채팅코드
    Integer getChatCodeByReport(@Param("reportCode") int reportCode);
    
   
	
	

	int getCountById(String userId);

	
	
}
