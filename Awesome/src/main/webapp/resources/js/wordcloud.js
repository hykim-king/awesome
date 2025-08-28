fetch('/ehr/mypage/wordcloud', { headers:{'Accept':'application/json'} })
  .then(r => r.json())
  .then(data => {
    const list = Array.isArray(data?.list) ? data.list : [];
    WordCloud(document.getElementById('wordCloud'), {
      list: list,            // 단어, 크기
      gridSize: 8,          // 글자 간격
      weightFactor: 5,      // 글자 크기 비율
      fontFamily: 'Arial',
      color: 'random-dark',  // 랜덤 진한 색상
      backgroundColor: '#fff'
    });
  });