package com.pcwk.ehr.cmn;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

import com.google.common.base.Strings;

public class PcwkString {


		
	
	
	public static String getExt(String fileName) {
		String ext = "";
		
		if(fileName.lastIndexOf(".")>-1) {
			int dotWhich  =fileName.lastIndexOf(".");
			ext = fileName.substring(dotWhich+1);
		}
		
		return ext;
	}
	
	/**
	 * yyyyMMdd+UUID
	 * @param pattern
	 * @return String
	 */
	public static String getPK(String pattern) {
		return getCurrentDate(pattern)+"_"+getUUID();
	}
	
	/**
	 * UUID
	 * @return String
	 */
	public static String getUUID() {
		return UUID.randomUUID().toString();
	}
	
	
	/**
	 * 당일 기준 날짜 문자 생성
	 * @param pattern
	 * @return String(당일 기준 날짜)
	 */
	public static String getCurrentDate(String pattern) {
		pattern = nvlString(pattern,"yyyy/MM/dd");
		return LocalDateTime.now().format(DateTimeFormatter.ofPattern(pattern));
	}
	
	/**
	 * 
	 * @param maxNum : 총 글수
	 * @param currentPageNo: 현재 페이지번호
	 * @param rowPerPage : 페이지 사이즈 (10,20,...100)
	 * @param bottomCount: 10/5
	 * @param url : 서버 호출 URL   
	 * @param scriptName : 자바스크립트 함수명
	 * @return "html 텍스트"
	 */
	public static String renderingPager(int maxNum, int currentPageNo, int rowPerPage, int bottomCount, String url, String scriptName) {
		StringBuilder  html=new StringBuilder(2000);
		
 
		
		//maxNum : 총 글수 -> 21
		//currentPageNo = 1
		//rowPerPage : 10
		//bottomCount: 10
		
		int maxPageNo = (maxNum -1) / rowPerPage +1; //3
		int startPageNo = ((currentPageNo - 1)/bottomCount) * bottomCount +1;//1,11,21,31,...
		int endPageNo   = ((currentPageNo - 1)/bottomCount+1) * bottomCount;//10,20,30,40,...
		
		long nowBlockNo = ((currentPageNo - 1)/bottomCount)+1;//1
        long maxBlockNo = ((maxNum-1)/bottomCount)+1;//3				
		
		
        if(currentPageNo > maxPageNo) {
        	return "";
        }
        
		//«	<	1	2	3	4	5	>	»
		//a b           c           d   e
		//« : 1 page로 이동
		//< : 왼쪽으로 bottomCount--
		//1	2	3	4	5...10 : page번호
		//> : 오른쪽으로 bottomCount++
		//» : 마지막 페이지
        
        
        html.append("<div class=\"pagination\"> \n");
        
        //« : 1 page로 이동
        if(nowBlockNo > 1 && nowBlockNo <=maxBlockNo ) {
        	html.append("<a href=\"javascript:"+scriptName+"('"+url+"',1);\" class=\"prev \">&laquo;</a> \n");        	
        }

        //< : 왼쪽으로 bottomCount--
        if(startPageNo > bottomCount) {
        	html.append("<a href=\"javascript:"+scriptName+"('"+url+"',"+(startPageNo - bottomCount)+");\" >");
        	html.append("<span>&lt;</span>");
        	html.append("</a> \n");
        }
        
        //1	2	3	4	5...10 : page번호 
        int inx = 0;
        for(inx = startPageNo;inx<=maxPageNo && inx <=endPageNo; inx++) {
        	if(inx == currentPageNo) {//링크 없음
        		html.append("<a href=\"#\" title=\"현제 페이지 \" class=\"disabled\">");
        		html.append(inx);
        		html.append("</a>\n");
        	}else {
        		html.append("<a href=\"javascript:"+scriptName+"('"+url+"',"+(inx)+");\" >");
        		html.append(inx);
        		html.append("</a>\n");        		 
        	}
        }
        
        //> 오른쪽으로 bottomCount++
        if(maxPageNo > inx) {
        	html.append("<a href=\"javascript:"+scriptName+"('"+url+"',"+( (nowBlockNo * bottomCount)+1 )+");\" >");
        	html.append("<span>&gt;</span>");
        	html.append("</a> \n");        	
        }
        
        //» : 마지막 페이지
        if(maxPageNo > inx) {
        	
        	html.append("<a href=\"javascript:"+scriptName+"('"+url+"',"+( maxPageNo )+");\" >");
        	html.append("<span>&raquo;</span>");
        	html.append("</a> \n");           	
        	
        }
        

        html.append("</div>");
		
		
		return html.toString();
	}	

	/**
	 * null,"" 입력되면 default value로 변경
	 * @param value
	 * @param defaultValue
	 * @return String
	 */
	public static String nvlString(String value, String defaultValue) {
		if(Strings.isNullOrEmpty(value) == true) {
			return defaultValue;
		}
		
		return value;
	}
	
	
	/**
	 * value가 0이면 defaultValue 리턴
	 * @param value
	 * @param defaultValue
	 * @return int
	 */
	public static int nvlZero(int value, int defaultValue) {
		return (value==0)?defaultValue:value;
	}
	
	/**
	 * null 또는 빈 문자열인지 체크
	 * @param str
	 * @return true/false
	 */
	public static boolean isNullOrEmpty(String str) {
		return Strings.isNullOrEmpty(str);
	}
	

	/**
	 * null->빈문자열
	 * @param str
	 * @return ""
	 */
	public static String nullToEmpty(String str) {
		return Strings.nullToEmpty(str);
	}	
}
