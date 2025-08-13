package com.pcwk.ehr.keyword.service;

import java.util.List;
import java.util.Arrays;
import org.springframework.stereotype.Service;
import com.pcwk.ehr.keyword.domain.KeywordLink;

@Service
public class KeywordServiceImpl implements KeywordService {
    @Override
    public List<KeywordLink> getTodayKeywords() {
        return Arrays.asList(
            new KeywordLink("정치키워드를 넣을꺼야", "/topic/list.do?keyword=정치"),
            new KeywordLink("키워드2를 넣는다", "/topic/list.do?keyword=경제"),
            new KeywordLink("사회적 이슈", "/topic/list.do?keyword=사회"),
            new KeywordLink("어느정도 길이가 될까", "/topic/list.do?keyword=문화"),
            new KeywordLink("연예연예", "/topic/list.do?keyword=연예"),
            new KeywordLink("스포츠~-", "/topic/list.do?keyword=스포츠")
        );
    }
}