<script>
  window.addEventListener("DOMContentLoaded", () => {
    // 키워드 박스 요소 가져오기
    const leftBox = document.querySelector(".keywords-left");
    const rightBox = document.querySelector(".keywords-right");

    // 약간의 딜레이 후 활성화 (자연스럽게 보이게)
    setTimeout(() => {
      leftBox.classList.add("active");
      rightBox.classList.add("active");
    }, 200); // 0.2초 뒤 시작
  });
</script>