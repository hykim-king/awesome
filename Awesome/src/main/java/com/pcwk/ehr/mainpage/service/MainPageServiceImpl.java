package com.pcwk.ehr.mainpage.service;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pcwk.ehr.keyword.domain.KeywordDTO;
import com.pcwk.ehr.mapper.KeywordMapper;
import com.pcwk.ehr.mapper.ArticleMapper;
import com.pcwk.ehr.mapper.UserLogMapper;
import com.pcwk.ehr.article.domain.ArticleDTO;
import java.util.List;

import com.pcwk.ehr.keyword.domain.KeywordDTO;

@Service
public class MainPageServiceImpl implements MainPageService {
	 private final Logger log = LogManager.getLogger(getClass());

	    @Autowired(required = false)
	    private KeywordMapper keywordMapper;

	    // @Autowired(required = false)
	    // private ArticleMapper articleMapper;

	    // @Autowired(required = false)
	    // private UserLogMapper userLogMapper;

	    // @Autowired(required = false)
	    // private WeatherService weatherService;

	    @Override
	    public List<KeywordDTO> getTodayTopics(String updatePeriod) {
	        if (keywordMapper == null) {
	            log.debug("KeywordMapper not wired yet -> return empty list");
	            return Collections.emptyList();
	        }

	        List<KeywordDTO> all = keywordMapper.doRetrieve();
	        if (all == null || all.isEmpty()) return Collections.emptyList();

	        return all.stream()
	                .filter(k -> updatePeriod == null || Objects.equals(k.getUpdatePeriod(), updatePeriod))
	                .sorted(Comparator
	                        .comparing(KeywordDTO::getDkDt).reversed()
	                        .thenComparing(KeywordDTO::getUpdatePeriod)
	                )
	                .collect(Collectors.toList());
	    }

	    @Override
	    public List<Object> getHotTop3() {
	        //  Arrays.asList로 더미 리스트 생성
	        return Arrays.asList(
	            "인기) 정치: 국회 본회의 쟁점 정리",
	            "인기) 스포츠: 주말 경기 하이라이트",
	            "인기) IT: 보안 업데이트 권고"
	        );
	    }

	    @Override
	    public List<Object> getRecommendTop3(String userId) {
	        if (userId == null) return Collections.emptyList();

	        return Arrays.asList(
	            "추천) 경제: 환율 급등 해설",
	            "추천) IT: 생성형 AI 도입 사례",
	            "추천) 사회: 전력수급 이슈"
	        );
	    }

	    @Override
	    public String getWeatherSummary() {
	        return "서울 28℃, 구름 조금";
	    }
	}