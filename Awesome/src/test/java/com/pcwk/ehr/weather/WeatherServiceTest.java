package com.pcwk.ehr.weather;

import com.pcwk.ehr.weather.domain.WeatherDTO;
import com.pcwk.ehr.weather.service.WeatherService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.io.IOException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {
        "file:src/main/webapp/WEB-INF/spring/root-context.xml",
        "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
class WeatherServiceTest {

    @Autowired
    private WeatherService weatherService;

    @Test
    @DisplayName("주요 10개 도시: 초단기예보(T1H/SKY/PTY) 조회")
    void testGetWeatherForAllCities() throws IOException {
        List<WeatherDTO> weatherList = weatherService.getWeatherForAllCities();

        // 1) 리스트 검사
        assertNotNull(weatherList, "결과 리스트가 null이면 안 됨");
        assertEquals(10, weatherList.size(), "도시 개수는 10개여야 함");

        for (WeatherDTO dto : weatherList) {
            // 2) 도시명
            assertNotNull(dto.getCityName(), "도시명이 null이면 안 됨");
            assertFalse(dto.getCityName().trim().isEmpty(), "도시명이 비어 있으면 안 됨");

            // 3) 기온(T1H): double 이므로 null 검사는 불가 → NaN/무한대 여부 확인
            assertFalse(Double.isNaN(dto.getTemperature()),
                    dto.getCityName() + " 기온이 NaN이면 안 됨");
            assertFalse(Double.isInfinite(dto.getTemperature()),
                    dto.getCityName() + " 기온이 Infinite이면 안 됨");

            // 4) 하늘 상태(SKY): 1,3,4 중 하나(없으면 -1로 들어오지 않도록 서비스가 세팅되어야 함)
            int sky = dto.getSky();
            assertTrue(sky == 1 || sky == 3 || sky == 4,
                    dto.getCityName() + " SKY는 1/3/4 여야 함. actual=" + sky);

            // 5) 강수 형태(PTY): 0,1,2,3,5,6,7 중 하나
            int pty = dto.getPty();
            assertTrue(pty == 0 || pty == 1 || pty == 2 || pty == 3 || pty == 5 || pty == 6 || pty == 7,
                    dto.getCityName() + " PTY는 0/1/2/3/5/6/7 여야 함. actual=" + pty);

            // 콘솔 출력 (디버깅용)
            System.out.println(String.format("%s: %.1f℃, SKY=%d(%s), PTY=%d(%s)",
                    dto.getCityName(),
                    dto.getTemperature(),
                    dto.getSky(), dto.getSkyText(),
                    dto.getPty(), dto.getPtyText()));
        }
    }
}