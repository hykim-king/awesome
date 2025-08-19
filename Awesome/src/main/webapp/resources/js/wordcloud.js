  window.onload = function() {
    // 하드코딩 키워드 데이터
    const list = [
      ['노로바이러스', 15],
      ['코로나', 20],
      ['독감', 10],
      ['파상풍', 8],
      ['감기', 25],
      ['폐렴', 12],
      ['원숭이', 4],
      ['바나나', 16],
      ['경제', 17],
      ['금리', 10],
      ['놀이동산', 19],
      ['아이', 18]
    ];

    WordCloud(document.getElementById('wordCloud'), {
      list: list,            // 단어, 크기
      gridSize: 8,          // 글자 간격
      weightFactor: 5,      // 글자 크기 비율
      fontFamily: 'Arial',
      color: 'random-dark',  // 랜덤 진한 색상
      backgroundColor: '#fff'
    });
  }