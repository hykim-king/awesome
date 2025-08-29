package com.pcwk.ehr.weather.domain;


public class WeatherDTO {
    private String cityName;    // 도시명 (서울, 인천 등)
    private double temperature; // T1H: 기온 (℃)
    private int sky;            // SKY: 하늘 상태 코드 (1=맑음, 3=구름많음, 4=흐림)
    private int pty;            // PTY: 강수 형태 코드 (0=없음, 1=비, 2=비/눈, 3=눈, 5=빗방울, 6=빗방울/눈날림, 7=눈날림)

    
    
    public String getCityName() {
		return cityName;
	}

	public void setCityName(String cityName) {
		this.cityName = cityName;
	}

	public double getTemperature() {
		return temperature;
	}

	public void setTemperature(double temperature) {
		this.temperature = temperature;
	}

	public int getSky() {
		return sky;
	}

	public void setSky(int sky) {
		this.sky = sky;
	}

	public int getPty() {
		return pty;
	}

	public void setPty(int pty) {
		this.pty = pty;
	}

	public String getSkyText() {
        switch (sky) {
            case 1: return "☀️";
            case 3: return "⛅";
            case 4: return "☁️";
            default: return "알수없음";
        }
    }

    public String getPtyText() {
        switch (pty) {
            case 0: return "강수없음";
            case 1: return "🌧️";
            case 2: return "비/눈";
            case 3: return "눈";
            case 5: return "빗방울";
            case 6: return "빗방울/눈날림";
            case 7: return "눈날림";
            default: return "알수없음";
        }
    }

}