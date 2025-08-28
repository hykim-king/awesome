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

    public String getChatResponse(String userMessage) {
        try {
            String dbInfo = "";
            String lowerCaseMessage = userMessage.toLowerCase();

            ArticleSearchDTO searchDto = new ArticleSearchDTO();
            
            // 사용자 질문에 따라 카테고리 설정
            if (lowerCaseMessage.contains("정치")) {
                searchDto.setCategory(10);
            } else if (lowerCaseMessage.contains("경제")) {
                searchDto.setCategory(20);
            } else if (lowerCaseMessage.contains("사회")) {
                searchDto.setCategory(30);
            } else if (lowerCaseMessage.contains("스포츠")) {
                searchDto.setCategory(40);
            } else if (lowerCaseMessage.contains("연예")) {
                searchDto.setCategory(50);
            } else if (lowerCaseMessage.contains("it") || lowerCaseMessage.contains("과학")) {
                searchDto.setCategory(60);
            }
            
            searchDto.setSearchDiv("20"); // '요약 본문' 검색
            searchDto.setSearchWord(userMessage);
            searchDto.setStartRow(1);
            searchDto.setEndRow(5); // 최신 기사 5개만 조회

            List<ArticleDTO> articles = articleMapper.doRetrieve(searchDto);
            dbInfo = formatArticlesForPrompt(articles);
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(openAIApiKey);

            ObjectNode requestBody = objectMapper.createObjectNode();
            requestBody.put("model", "gpt-3.5-turbo");

            ArrayNode messages = objectMapper.createArrayNode();
            
            ObjectNode systemRole = objectMapper.createObjectNode();
            systemRole.put("role", "system");
            systemRole.put("content", "당신은 제공된 기사 정보를 활용하여 사용자의 질문에 답변하는 챗봇입니다. 제공된 정보 외의 내용에 대해서는 '모른다'고 답하세요.");
            messages.add(systemRole);

            if (!dbInfo.isEmpty()) {
                ObjectNode dbInfoPrompt = objectMapper.createObjectNode();
                dbInfoPrompt.put("role", "system");
                dbInfoPrompt.put("content", dbInfo);
                messages.add(dbInfoPrompt);
            }
            
            ObjectNode userMessageNode = objectMapper.createObjectNode();
            userMessageNode.put("role", "user");
            userMessageNode.put("content", userMessage);
            messages.add(userMessageNode);

            requestBody.set("messages", messages);
            requestBody.put("temperature", 0.7);

            HttpEntity<String> entity = new HttpEntity<>(requestBody.toString(), headers);

            ResponseEntity<String> response = restTemplate.postForEntity(API_URL, entity, String.class);
            JsonNode rootNode = objectMapper.readTree(response.getBody());
            JsonNode choices = rootNode.path("choices");

            if (choices.isArray() && choices.size() > 0) {
                String content = choices.get(0).path("message").path("content").asText();
                return content.trim();
            }

            return "챗봇 응답을 받지 못했습니다.";

        } catch (Exception e) {
            e.printStackTrace();
            return "API 통신 중 오류가 발생했습니다: " + e.getMessage();
        }
    }
    
    private String formatArticlesForPrompt(List<ArticleDTO> articles) {
        if (articles == null || articles.isEmpty()) {
            return "요청하신 기사 정보가 없습니다.";
        }
        
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
