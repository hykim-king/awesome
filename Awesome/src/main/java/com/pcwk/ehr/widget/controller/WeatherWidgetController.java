package com.pcwk.ehr.widget.controller;

import java.io.IOException;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.pcwk.ehr.weather.domain.WeatherDTO;
import com.pcwk.ehr.weather.service.WeatherService;

@Controller
@RequestMapping("/widget")
public class WeatherWidgetController {

    Logger log = LogManager.getLogger(getClass());

    @Autowired
    WeatherService weatherService;

    @GetMapping("/weather")
    public String weatherWidget(Model model) {
        try {
            List<WeatherDTO> weatherList = weatherService.getWeatherForAllCities();
            model.addAttribute("weatherList", weatherList);
        } catch (IOException e) {
            log.warn("날씨 API 실패: {}", e.getMessage());
            model.addAttribute("weatherError", "날씨 정보를 가져올 수 없습니다.");
        }
        return "widget/weather"; // /WEB-INF/views/widget/weather.jsp
    }
}
