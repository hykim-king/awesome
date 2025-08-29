package com.pcwk.ehr.chatbot.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.pcwk.ehr.article.domain.ArticleDTO;
import com.pcwk.ehr.article.domain.ArticleSearchDTO;
import com.pcwk.ehr.mapper.ArticleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.stream.Collectors;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

@Service
public class OpenAiService {

    @Value("${openai.api.key}")
    private String openAIApiKey;

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private ArticleMapper articleMapper;

    private static final String API_URL = "https://api.openai.com/v1/chat/completions";
    private final ObjectMapper objectMapper = new ObjectMapper();
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy년 MM월 dd일 HH:mm:ss");

    // 검색에서 제외할 불필요한 단어들
    private static final Set<String> STOP_WORDS = new HashSet<>(Arrays.asList(
    		"오늘", "최신", "핫한", "뭐야", "알려줘", "있어", "뉴스", "기사", "추천해줘"
    ));

    public String getChatResponse(String userMessage) {
        try {
            // 1) 키워드/카테고리 추출 → DB 검색
            ArticleSearchDTO searchDto = extractSearchKeywords(userMessage);
            List<ArticleDTO> articles = articleMapper.doRetrieve(searchDto);
            if (articles.isEmpty()) {
                return "죄송합니다. 요청하신 내용과 관련된 기사를 찾을 수 없습니다. "
                     + "혹시 '오늘 정치 뉴스 알려줘' 또는 '최신 AI 기술 기사'처럼 구체적으로 질문해주시겠어요?";
            }

            // 2) 프롬프트용 기사 정보(원하면 제목만 보내도록 바꿔도 됨)
            String dbInfo = formatArticlesForPrompt(articles);

            // 3) OpenAI 요청 준비
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "Bearer " + openAIApiKey.trim());

            ObjectNode requestBody = objectMapper.createObjectNode();
            requestBody.put("model", "gpt-4o-mini");
            requestBody.put("max_tokens", 300);
            requestBody.put("temperature", 0.2);

            // ✅ 여기서 messages를 "반드시" 선언해야 함
            ArrayNode messages = objectMapper.createArrayNode();

            ObjectNode systemRole = objectMapper.createObjectNode();
            systemRole.put("role", "system");
            systemRole.put("content",
                "역할: 뉴스 추천 비서.\n"
              + "- 제공된 기사 목록 안에서만 선택할 것.\n"
              + "- 출력 형식: '제목'만 한 줄에 하나씩.\n"
              + "- 번호/불릿/설명/링크/언론사/날짜 금지. 제목 문자열만.\n"
              + "- 최대 5줄.\n"
              + "- 제목은 제공된 값 그대로 사용할 것."
            );
            messages.add(systemRole);

            ObjectNode dbInfoPrompt = objectMapper.createObjectNode();
            dbInfoPrompt.put("role", "system");
            dbInfoPrompt.put("content", dbInfo);
            messages.add(dbInfoPrompt);

            ObjectNode userMessageNode = objectMapper.createObjectNode();
            userMessageNode.put("role", "user");
            userMessageNode.put("content", userMessage);
            messages.add(userMessageNode);

            requestBody.set("messages", messages);

            HttpEntity<String> entity = new HttpEntity<>(requestBody.toString(), headers);

            // 4) 호출
            ResponseEntity<String> response =
                restTemplate.postForEntity(API_URL, entity, String.class);

            // 5) 응답 파싱 + "제목만" 후처리
            JsonNode rootNode = objectMapper.readTree(response.getBody());
            JsonNode choices = rootNode.path("choices");
            if (choices.isArray() && choices.size() > 0) {
                String content = choices.get(0).path("message").path("content").asText("");

                String titlesOnly = Arrays.stream(content.split("\\r?\\n"))
                    .map(s -> s.replaceAll("^\\s*[-*•]+\\s*", ""))   // 불릿 제거
                    .map(s -> s.replaceAll("^\\s*\\d+[.)]\\s*", "")) // 번호 제거 (1. / 1) 등)
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .distinct()
                    .limit(5)
                    .collect(Collectors.joining("\n"));

                return titlesOnly.isEmpty() ? "추천 결과가 없습니다." : titlesOnly;
            }

            return "챗봇 응답을 받지 못했습니다.";

        } catch (Exception e) {
            e.printStackTrace();
            return "API 통신 중 오류가 발생했습니다: " + e.getMessage();
        }
    }
    
    /**
     * 사용자 질문에서 검색에 사용할 키워드와 카테고리를 추출
     */
    private ArticleSearchDTO extractSearchKeywords(String userMessage) {
        ArticleSearchDTO searchDto = new ArticleSearchDTO();
        String lowerCaseMessage = userMessage.toLowerCase();

        // 1. 카테고리 설정
        if (lowerCaseMessage.contains("정치")) {
            searchDto.setCategory(10);
        } else if (lowerCaseMessage.contains("경제")) {
            searchDto.setCategory(20);
        } else if (lowerCaseMessage.contains("사회") || lowerCaseMessage.contains("문화")) {
            searchDto.setCategory(30);
        } else if (lowerCaseMessage.contains("스포츠")) {
            searchDto.setCategory(40);
        } else if (lowerCaseMessage.contains("연예")) {
            searchDto.setCategory(50);
        } else if (lowerCaseMessage.contains("it") || lowerCaseMessage.contains("과학")) {
            searchDto.setCategory(60);
        }

        // 2. 검색에 불필요한 단어 제거 (STOP_WORDS는 기존대로 사용)
        List<String> keywords = Arrays.stream(lowerCaseMessage.split("\\s+"))
                                    .filter(word -> !STOP_WORDS.contains(word))
                                    .collect(Collectors.toList());

        String keywordString = String.join(" ", keywords).trim();

        // 3. 검색어 설정
        //    keywordString이 비어있지 않은 경우에만 SUMMARY LIKE 조건을 사용합니다.
        if (!keywordString.isEmpty()) {
            searchDto.setSearchDiv("20");
            searchDto.setSearchWord(keywordString);
        } else {
            // 키워드가 없는 경우, searchDiv와 searchWord를 null로 설정합니다.
            // 이렇게 하면 SQL 쿼리에서 SUMMARY LIKE 조건이 제외됩니다.
            searchDto.setSearchDiv(null);
            searchDto.setSearchWord(null);
        }
        
        // 검색할 행 범위 설정
        searchDto.setStartRow(1);
        searchDto.setEndRow(5);

        return searchDto;
        
    }
    
    /**
     * 검색된 기사 목록을 OpenAI 프롬프트 형식에 맞게 포맷팅
     */
    private String formatArticlesForPrompt(List<ArticleDTO> articles) {
        StringBuilder sb = new StringBuilder("다음은 검색된 기사 정보입니다. 이 정보를 활용하여 답변해주세요.\n\n");
        for (ArticleDTO article : articles) {
            sb.append("제목: ").append(article.getTitle()).append("\n");
            sb.append("요약: ").append(article.getSummary()).append("\n");
            sb.append("언론사: ").append(article.getPress()).append("\n");
            if (article.getPublicDt() != null) {
                sb.append("게시일: ").append(dateFormat.format(article.getPublicDt())).append("\n");
            }
            sb.append("URL: ").append(article.getUrl()).append("\n\n");
        }
        return sb.toString();
    }
}