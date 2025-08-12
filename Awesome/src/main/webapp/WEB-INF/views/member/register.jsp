<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>회원가입</title>
</head>
<body>
<h2>회원가입</h2>

<form action="<c:url value='/member/register.do'/>" method="post" id="joinForm">
  아이디* <input type="text" name="userId" id="userId" required>
  <button type="button" id="btnIdCheck">중복확인</button><br>

  비밀번호* <input type="password" name="pwd" id="pwd" minlength="8" maxlength="20" required><br>
  비밀번호 확인* <input type="password" id="pwd2" required><br>

  이름 <input type="text" name="userNm"><br>
  닉네임 <input type="text" name="nickNm"><button type="button" id="btnNickCheck">중복확인</button><br>

  생년월일 <input type="text" name="birthDt" placeholder="YYYYMMDD" pattern="[0-9]{8}"><br>

  이메일* <input type="email" name="mailAddr" id="mailAddr" required>
  <button type="button" id="btnSendCode">인증코드 받기</button><br>

  인증번호 <input type="text" id="emailCode">
  <button type="button" id="btnVerifyCode">인증확인</button><br>

  <label><input type="checkbox" id="agreeAll"> 아래 약관에 모두 동의합니다.</label><br>
  <label><input type="checkbox" class="agree" required> 이용약관 동의</label><br>
  <label><input type="checkbox" class="agree"> 마케팅 정보 수신 동의(선택)</label><br>

  <input type="hidden" name="emailAuthYn" id="emailAuthYn" value="N">
  <input type="hidden" name="emailAuthToken" id="emailAuthToken" value="">
  <input type="hidden" name="userGradeCd" value="1">

  <button type="submit" id="btnSubmit">회원가입 완료</button>
</form>

<script>
const $ = (sel)=>document.querySelector(sel);

$("#agreeAll").addEventListener("change", e=>{
  document.querySelectorAll(".agree").forEach(ch=>ch.checked=e.target.checked);
});

$("#btnIdCheck").onclick = async ()=>{
  const url = '/ehr/member/checkId?userId=' + encodeURIComponent($("#userId").value);
  const res = await fetch(url);
  alert((await res.text()) === "OK" ? "사용 가능한 아이디입니다" : "이미 사용 중입니다");
};

$("#btnSendCode").onclick = async ()=>{
  const body = 'mailAddr=' + encodeURIComponent($("#mailAddr").value);
  const res = await fetch('/ehr/member/sendEmailCode', {
    method: 'POST',
    headers: {'Content-Type':'application/x-www-form-urlencoded'},
    body
  });
  const token = await res.text(); // 서버에서 토큰 반환(또는 세션 저장)
  $("#emailAuthToken").value = token;
  alert("이메일로 인증코드를 보냈습니다");
};

$("#btnVerifyCode").onclick = async ()=>{
  const body =
    'token=' + encodeURIComponent($("#emailAuthToken").value) +
    '&code=' + encodeURIComponent($("#emailCode").value);
  const res = await fetch('/ehr/member/verifyEmailCode', {
    method: 'POST',
    headers: {'Content-Type':'application/x-www-form-urlencoded'},
    body
  });
  const ok = (await res.text()) === "OK";
  $("#emailAuthYn").value = ok ? "Y" : "N";
  alert(ok ? "인증 완료" : "인증 실패");
};

$("#joinForm").onsubmit = ()=>{
  if ($("#pwd").value !== $("#pwd2").value) { alert("비밀번호가 일치하지 않습니다"); return false; }
  if ($("#emailAuthYn").value !== "Y") { alert("이메일 인증을 완료하세요"); return false; }
};
</script>
</body>
</html>
