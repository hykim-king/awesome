document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".keyword-chip").forEach(chip => {
    chip.addEventListener("click", () => {
      console.log("키워드 클릭:", chip.textContent);
      // 필요 시 서버에 클릭 로그 전송 가능
    });
  });
});