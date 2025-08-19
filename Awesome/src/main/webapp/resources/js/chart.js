google.charts.load("current", {packages:["corechart"]});
google.charts.setOnLoadCallback(drawChart);

function drawChart() {
  var data = google.visualization.arrayToDataTable([
    ['category', 'Frequency per Week'],
    ['정치', 1], ['경제', 2], ['사회/문화', 3],
    ['스포츠', 4], ['연예', 5], ['IT/과학', 6]
  ]);

  var options = { title: '한 주간 읽은 카테고리', is3D: true };
  var chart = new google.visualization.PieChart(document.getElementById('piechart_3d'));
  chart.draw(data, options);
}