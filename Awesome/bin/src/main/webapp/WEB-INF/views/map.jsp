<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>카카오 지도</title>
  <style>
    #map { width:100%; height:100vh; }
    #staticMap{width:600px; height:400px;}
  </style>
</head>
<body>
  <!-- html 파일과 js 파일 연결 시 script 사\ -->
  <script src = " /map.js"></script>
  <div id="map"></div>
  <!-- <div id = "staticMap"></div> -->
  <!-- kakao SDK 불러오기 (onload에서 위 함수 호출) -->
  <script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=b442e080c0a64cb3d347d6158376d1da&autoload=false"
          onload="loadKakaoMap()"></script>
          
</body>
</html>