package com.pcwk.ehr.userKeyword.service;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import okhttp3.*;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.List;
import java.util.Map;

@Service
public class UserKeywordService {
	
	private final OkHttpClient client = new OkHttpClient();
    private final Gson gson = new Gson();
    // Python 서버의 주소. 실제 배포 환경에 맞게 변경해야 합니다.
    private static final String PYTHON_SERVER_URL = "http://localhost:5000/process_keyword";

    public void processArticleKeywords(String userId, String articleTitle) throws IOException {
        
        // 요청 본문(request body)을 JSON 형태로 생성
    	Map<String, String> requestData = new HashMap<>();
        requestData.put("user_id", userId);
        requestData.put("article_title", articleTitle);
        
        String jsonRequest = gson.toJson(requestData);
        RequestBody body = RequestBody.create(jsonRequest, MediaType.get("application/json; charset=utf-8"));


        Request request = new Request.Builder()
            .url(PYTHON_SERVER_URL)
            .post(body)
            .build();

        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("Unexpected response code " + response);
            }

            // Python 서버에서 반환된 JSON 응답 파싱
            String responseBody = response.body().string();
            System.out.println("Python Server Response: " + responseBody);

            Type listType = new TypeToken<List<String>>() {}.getType();
            List<String> keywords = gson.fromJson(responseBody, listType);

            // 키워드 처리 (예: DB에 저장)
            for (String keyword : keywords) {
                System.out.println("Processing keyword: " + keyword);
                // 이곳에 JDBC 또는 MyBatis를 사용해 DB에 키워드를 저장하는 로직을 구현합니다.
            }

        }
    }

}
