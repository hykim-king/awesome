package com.pcwk.ehr.weather.service;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import com.pcwk.ehr.weather.domain.WeatherDTO;

@Service
public class WeatherService {

    // ▼ 공공데이터포털 서비스키 (URL 인코딩 없이 원문 키를 쓰는 것을 권장)
    private static final String SERVICE_KEY = "t1hWD2FVXymDQt8Ur/+uD0/ioAUaTkOyscd0P/fiWmRrbDH4vQ+tmtrALLpuUfjNzZ92mAQUt2NSV6IN/otJMg==";

    // 초단기예보 엔드포인트
    private static final String ULTRA_SRT_FCST =
            "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst";

    // 주요 도시 격자 좌표
    private static final Map<String, int[]> CITY_COORDS = new LinkedHashMap<>();
    static {
        CITY_COORDS.put("서울", new int[]{60, 127});
        CITY_COORDS.put("인천", new int[]{55, 124});
        CITY_COORDS.put("대전", new int[]{67, 100});
        CITY_COORDS.put("대구", new int[]{89, 90});
        CITY_COORDS.put("부산", new int[]{98, 76});
        CITY_COORDS.put("광주", new int[]{58, 74});
        CITY_COORDS.put("울산", new int[]{102, 84});
        CITY_COORDS.put("세종", new int[]{66, 103});
        CITY_COORDS.put("춘천", new int[]{73, 134});
        CITY_COORDS.put("제주", new int[]{52, 38});
    }

    /**
     * 도시 10개 날씨(가장 가까운 예보시각의 T1H/SKY/PTY) 리스트
     */
    public List<WeatherDTO> getWeatherForAllCities() throws IOException {
        List<WeatherDTO> resultList = new ArrayList<>();

        for (Map.Entry<String, int[]> entry : CITY_COORDS.entrySet()) {
            String cityName = entry.getKey();
            int[] coords = entry.getValue();

            WeatherDTO dto = getForecastOneShot(coords[0], coords[1]);
            dto.setCityName(cityName); // ★ DTO에 도시명 세팅

            resultList.add(dto);
        }
        return resultList;
    }

    /**
     * 초단기예보에서 가장 가까운 예보시각(fcstDate+fcstTime)을 골라
     * 그 시각의 T1H/SKY/PTY를 DTO로 반환.
     */
    private WeatherDTO getForecastOneShot(int nx, int ny) throws IOException {
        String baseDate = getToday();
        String baseTime = getBaseTimeForFcst(); // 직전 HH30

        StringBuilder urlBuilder = new StringBuilder(ULTRA_SRT_FCST);
        urlBuilder.append("?").append(encode("serviceKey")).append("=").append(URLEncoder.encode(SERVICE_KEY, "UTF-8"));
        urlBuilder.append("&").append(encode("pageNo")).append("=1");
        urlBuilder.append("&").append(encode("numOfRows")).append("=1000");
        urlBuilder.append("&").append(encode("dataType")).append("=JSON");
        urlBuilder.append("&").append(encode("base_date")).append("=").append(baseDate);
        urlBuilder.append("&").append(encode("base_time")).append("=").append(baseTime);
        urlBuilder.append("&").append(encode("nx")).append("=").append(nx);
        urlBuilder.append("&").append(encode("ny")).append("=").append(ny);

        HttpURLConnection conn = (HttpURLConnection) new URL(urlBuilder.toString()).openConnection();
        conn.setRequestMethod("GET");

        BufferedReader rd = new BufferedReader(new InputStreamReader(
                (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 299)
                        ? conn.getInputStream()
                        : conn.getErrorStream(), "UTF-8")
        );

        StringBuilder sb = new StringBuilder();
        for (String line; (line = rd.readLine()) != null; ) sb.append(line);
        rd.close();
        conn.disconnect();

        String responseText = sb.toString().trim();
        if (!responseText.startsWith("{")) {
            throw new IOException("API 응답이 JSON이 아님:\n" + responseText);
        }

        JSONObject root = new JSONObject(responseText);
        JSONObject body = root.getJSONObject("response").getJSONObject("body");

        // 예보 아이템
        JSONArray items = body.getJSONObject("items").getJSONArray("item");

        // 1) 예보 시각별로 항목을 모은다: key = "yyyyMMddHHmm"
        Map<String, Map<String, String>> fcstByDateTime = new LinkedHashMap<>();

        for (int i = 0; i < items.length(); i++) {
            JSONObject it = items.getJSONObject(i);
            String fcstDate = it.getString("fcstDate"); // yyyyMMdd
            String fcstTime = it.getString("fcstTime"); // HHmm (예: "1430")
            String category = it.getString("category"); // T1H/SKY/PTY...
            String value = it.getString("fcstValue");

            String key = fcstDate + fcstTime;
            fcstByDateTime.computeIfAbsent(key, k -> new HashMap<>()).put(category, value);
        }

        // 2) 현재 시각 기준으로 가장 가까운 예보 시각 선택
        String targetKey = pickNearestForecastKey(fcstByDateTime.keySet());

        // 3) 해당 시각의 T1H/SKY/PTY 꺼내기
        Map<String, String> catMap = fcstByDateTime.getOrDefault(targetKey, Collections.emptyMap());

        double temperature = parseDoubleSafe(catMap.get("T1H"), Double.NaN);
        int sky = parseIntSafe(catMap.get("SKY"), -1);
        int pty = parseIntSafe(catMap.get("PTY"), -1);

        WeatherDTO dto = new WeatherDTO();
        dto.setTemperature(temperature);
        dto.setSky(sky);
        dto.setPty(pty);
        return dto;
    }

    // ----------------------- 유틸 -----------------------

    private static String encode(String s) throws IOException {
        return URLEncoder.encode(s, "UTF-8");
    }

    private String getToday() {
        return new SimpleDateFormat("yyyyMMdd").format(new Date());
    }

    /**
     * 초단기예보 base_time: 직전 HH30
     * (분이 30 미만이면 1시간 빼고 HH30, 아니면 해당시각 HH30)
     */
    private String getBaseTimeForFcst() {
        Calendar cal = Calendar.getInstance();
        int minute = cal.get(Calendar.MINUTE);
        if (minute < 30) {
            cal.add(Calendar.HOUR_OF_DAY, -1);
        }
        return new SimpleDateFormat("HH30").format(cal.getTime());
    }

    private static double parseDoubleSafe(String s, double def) {
        try { return s == null ? def : Double.parseDouble(s); }
        catch (Exception e) { return def; }
    }

    private static int parseIntSafe(String s, int def) {
        try { return s == null ? def : Integer.parseInt(s); }
        catch (Exception e) { return def; }
    }

    /**
     * 현재 시각(로컬 시간) 기준으로 가장 가까운 예보 시각 key(yyyyMMddHHmm)를 선택.
     * - 우선순위: 현재 시각 이후 중 가장 이른 것
     * - 없으면: 가장 늦은 것(가장 최신 예보)
     */
    private String pickNearestForecastKey(Set<String> keys) {
        if (keys.isEmpty()) return null;

        List<String> sorted = new ArrayList<>(keys);
        Collections.sort(sorted); // yyyyMMddHHmm 문자열 정렬 = 시간 오름차순

        String nowKey = new SimpleDateFormat("yyyyMMddHHmm").format(new Date());

        // now >= key? : 이후/이전에 따라 고르기
        for (String k : sorted) {
            if (k.compareTo(nowKey) >= 0) {
                return k; // 현재 이후 중 가장 빠른 예보
            }
        }
        // 전부 과거면 마지막(가장 최근 예보)
        return sorted.get(sorted.size() - 1);
    }
}