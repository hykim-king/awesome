package com.pcwk.ehr.mapper;

import com.pcwk.ehr.article.domain.ArticleSearchDTO;
import com.pcwk.ehr.cmn.WorkDiv;
import com.pcwk.ehr.report.domain.ReportDTO;

public interface ReportMapper extends WorkDiv<ReportDTO> {

    int getCount();
    
    int getCountByFilter(ArticleSearchDTO param);
    
    int deleteAll();
    
    // 상태만 바꾸는 전용 메서드가 필요하면 유지
    int doUpdateStatus(ReportDTO param);
}
