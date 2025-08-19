package com.pcwk.ehr.dict.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import com.pcwk.ehr.dict.domain.DictionaryDTO;

@Service
public class DictionaryService {
    @Value("${naver.client-id}")
    private String clientId;

    @Value("${naver.client-secret}")
    private String clientSecret;

    @Value("${naver.encyc.url}")
    private String apiUrl;

    private final RestTemplate rt;

    public DictionaryService(RestTemplate rt) {
        this.rt = rt;
    }

    public DictionaryDTO search(String query, int display, int start) {
        UriComponents uri = UriComponentsBuilder
            .fromHttpUrl(apiUrl)
            .queryParam("query", query)
            .queryParam("display", display)
            .queryParam("start", start)
            .build();

        HttpHeaders headers = new HttpHeaders();
        headers.set("X-Naver-Client-Id", clientId);
        headers.set("X-Naver-Client-Secret", clientSecret);

        HttpEntity<Void> request = new HttpEntity<>(headers);
        ResponseEntity<DictionaryDTO> resp = rt.exchange(
            uri.toUriString(), HttpMethod.GET, request, DictionaryDTO.class);
        return resp.getBody();
    }
}