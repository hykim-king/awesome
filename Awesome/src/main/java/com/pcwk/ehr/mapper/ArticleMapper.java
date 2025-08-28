package com.pcwk.ehr.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.pcwk.ehr.article.domain.ArticleDTO;
import com.pcwk.ehr.article.domain.ArticleSearchDTO;
import com.pcwk.ehr.cmn.WorkDiv;

public interface ArticleMapper extends WorkDiv<ArticleDTO> {
	
	//조회수 증가
	int updateReadCnt(ArticleDTO param);

	int saveAll();

	List<ArticleDTO> getAll();

	void deleteAll() throws SQLException;

	int getCount(ArticleSearchDTO param) throws SQLException;
	
	int getCountAll() throws Exception;
	
	int deleteMany(@Param("ids") List<Long> ids); //어드민용

	
	
	//가민경 메인사용
    ArticleDTO findTopByCategoryWithinDaysWithMin(Map<String, Object> params);
    ArticleDTO findLatestByCategory(int category);
    
    
	 // 챗봇용 기사 검색
	 List<ArticleDTO> doChatbotRetrieve(ArticleSearchDTO param) throws SQLException;
    
}
