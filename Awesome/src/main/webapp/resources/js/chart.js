google.charts.load("current", {packages:["corechart"]});
google.charts.setOnLoadCallback(drawChart);

function drawChart() {
  console.log("fetch URL:", ctx + "/mypage/api/mypage/chart"); // 디버깅용

  fetch(ctx + "/mypage/api/mypage/chart")
    .then(response => response.json())
    .then(data => {
      if (data.length === 0) {
        // 데이터 없을 때 메시지 출력
        document.getElementById('piechart_3d').innerHTML =
          "이번주 읽은 기사가 없습니다.<br>핫이슈 '오늘의 토픽'을 살펴보세요!";
        return;
      }

      // 구글 차트 데이터 포맷으로 변환
      const chartData = [['카테고리', 'Frequency per Week']];
      data.forEach(item => {
        chartData.push([item.category, item.clickCount]);
      });

      // 구글 차트 그리기
      const dataTable = google.visualization.arrayToDataTable(chartData);

      const options = {
        title: '한 주간 읽은 카테고리',
        is3D: true
      };

      const chart = new google.visualization.PieChart(
        document.getElementById('piechart_3d')
      );
      chart.draw(dataTable, options);
    })
    .catch(error => {
      console.error("차트 데이터를 불러오는 중 오류 발생:", error);
      document.getElementById('piechart_3d').innerText =
        "차트 데이터를 불러올 수 없습니다.";
    });
}