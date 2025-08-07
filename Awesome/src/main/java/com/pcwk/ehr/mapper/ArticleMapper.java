package com.pcwk.ehr.mapper;

import java.sql.SQLException;
import java.util.List;

import com.pcwk.ehr.article.domain.ArticleDTO;
import com.pcwk.ehr.cmn.WorkDiv;

public interface ArticleMapper extends WorkDiv<ArticleDTO> {

	int saveAll();

	List<ArticleDTO> getAll();

	void deleteAll() throws SQLException;

	int getCount() throws SQLException;
}
