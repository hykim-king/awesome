package com.pcwk.ehr.dict.service;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

import com.pcwk.ehr.dict.domain.DictionaryDTO;
import com.pcwk.ehr.dict.domain.DictionaryDTO.Item;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {
        "file:src/main/webapp/WEB-INF/spring/root-context.xml",
        "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
public class DictionaryServiceTest {

    private final Logger log = LogManager.getLogger(getClass());

    @Autowired
    DictionaryService dictionaryService;

    @Test
    void testSearch() {
        String query = "진주"; // 원하는 검색어
        int display = 5;
        int start = 1;

        DictionaryDTO result = dictionaryService.search(query, display, start);
        assertNotNull(result, "API 결과가 null이면 안 됩니다.");
        log.debug("총 검색 결과 수: {}", result.getTotal());

        List<Item> items = result.getItems();
        assertNotNull(items, "items는 null이면 안 됩니다.");
        assertTrue(items.size() > 0, "검색 결과가 1개 이상 있어야 합니다.");

        for (Item item : items) {
            log.debug("제목: {}", item.getTitle());
            log.debug("요약: {}", item.getDescription());
            log.debug("링크: {}", item.getLink());
            log.debug("썸네일: {}", item.getThumbnail());
            log.debug("------------");
        }
    }
}