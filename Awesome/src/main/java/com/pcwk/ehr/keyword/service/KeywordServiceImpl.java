package com.pcwk.ehr.keyword.service;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pcwk.ehr.keyword.domain.KeywordDTO;
import com.pcwk.ehr.keyword.domain.KeywordLink;
import com.pcwk.ehr.mapper.KeywordMapper;

@Service
public class KeywordServiceImpl implements KeywordService {

	private final KeywordMapper keywordMapper;

	@Autowired
	public KeywordServiceImpl(KeywordMapper keywordMapper) {
		this.keywordMapper = keywordMapper;
	}

	@Override
	public List<KeywordLink> getTodayKeywords() {
// 1) 카테고리별 최신 키워드 조회
		List<KeywordDTO> latestKeywords = keywordMapper.findLatestPerCategory();

// 2) 키워드별 등장 횟수 집계
		Map<String, Long> keywordCount = latestKeywords.stream()
				.collect(Collectors.groupingBy(KeywordDTO::getKeyword, Collectors.counting()));

// 3) Link 객체 생성: 중복 키워드는 카테고리명 추가
		return latestKeywords.stream().map(dto -> toLink(dto, keywordCount)).collect(Collectors.toList());
	}

	private KeywordLink toLink(KeywordDTO dto, Map<String, Long> keywordCount) {
		String original = dto.getKeyword();
		String display = original;
		long count = keywordCount.getOrDefault(original, 0L);

		if (count > 1) {
			display += " (" + categoryName(dto.getCategory()) + ")";
		}

		String url = buildUrl(dto);
		return new KeywordLink(display, url);
	}

	private String buildUrl(KeywordDTO dto) {
	    return "/article/list.do?category=" + dto.getCategory();
	}

	private String urlEncode(String input) {
		try {
			return URLEncoder.encode(input, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			return input;
		}
	}

	private String categoryName(int code) {
		switch (code) {
		case 10:
			return "정치";
		case 20:
			return "경제";
		case 30:
			return "사회";
		case 40:
			return "스포츠";
		case 50:
			return "연예";
		case 60:
			return "IT/과학";
		default:
			return String.valueOf(code);
		}
	}
}