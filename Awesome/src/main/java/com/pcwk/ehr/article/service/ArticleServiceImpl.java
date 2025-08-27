package com.pcwk.ehr.article.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pcwk.ehr.article.domain.ArticleDTO;
import com.pcwk.ehr.article.domain.ArticleSearchDTO;
import com.pcwk.ehr.mapper.ArticleMapper;

@Service
public class ArticleServiceImpl implements ArticleService {

//	이하 두줄 가민경 사용
    private static final int WINDOW_DAYS = 3; // 최근 N일
    private static final int MIN_CLICKS   = 3; // 최소 클릭수

	Logger log = LogManager.getLogger(getClass());

	@Autowired
	private ArticleMapper mapper;
	
	 @Autowired 
	 private ArticleMapper articleMapper;




	public ArticleServiceImpl() {

	}

	@Override
	public int doSave(ArticleDTO dto) throws Exception {

		Date now = new Date();
		dto.setRegDt(now);
		dto.setModDt(now);		

		int result = mapper.doSave(dto);

		if(result > 0) {
			ArticleDTO saved = mapper.doSelectOne(dto);
			dto.setRegDt(saved.getRegDt());
			dto.setModDt(saved.getModDt());
		}

		return result;
	}

	@Override
	public ArticleDTO doSelectOne(ArticleDTO dto) throws Exception {


		return mapper.doSelectOne(dto);
	}

	@Override
	public int doDelete(long articleCode) {

		ArticleDTO dto = new ArticleDTO();
		dto.setArticleCode(articleCode);

		return mapper.doDelete(dto);
	}
	
	
	@Override
	public int deleteMany(List<Long> ids) {
	    if (ids == null || ids.isEmpty()) return 0;
	    return articleMapper.deleteMany(ids);
	}

	
	
	@Override
	public List<ArticleDTO> doRetrieve(ArticleSearchDTO param) throws Exception {

		return mapper.doRetrieve(param);
	}

	@Override
	public int getCount(ArticleSearchDTO param) throws Exception {
		return mapper.getCount(param);
	}

	@Override
	public int getCountAll() throws Exception {
		return mapper.getCountAll();
	}

	@Override
	public int updateReadCnt(ArticleDTO param) throws Exception {
		return mapper.updateReadCnt(param);
	}


    // === 가민경 메인 사용 ===
    // 카테고리별 Top1(최근 N일 + 최소 클릭수), 없으면 최신 기사 fallback
    @Override
    public ArticleDTO getTopArticleByCategory(int category) {
        Map<String, Object> params = new HashMap<>();
        params.put("category", category);
        params.put("windowDays", WINDOW_DAYS);
        params.put("minClicks",  MIN_CLICKS);

        ArticleDTO top = mapper.findTopByCategoryWithinDaysWithMin(params);
        if (top == null) {
            top = mapper.findLatestByCategory(category); // fallback
        }
        return top;
    }

    @Override
    public List<ArticleDTO> getPopularTop1PerCategory() {
        int[] cats = {10, 20, 30, 40, 50, 60};
        List<ArticleDTO> list = new ArrayList<>(cats.length);
        for (int c : cats) {
            list.add(getTopArticleByCategory(c));
        }
        return list;
    }
}