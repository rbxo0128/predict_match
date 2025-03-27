<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>로그인</title>
</head>
<body>
<h2>로그인</h2>

<% if (request.getParameter("error") != null) { %>
<div class="error">
  잘못된 이메일 또는 비밀번호입니다.
</div>
<% } %>

<% if (request.getParameter("logout") != null) { %>
<div class="success">
  성공적으로 로그아웃되었습니다.
</div>
<% } %>

<% if (request.getParameter("signup") != null) { %>
<div class="success">
  회원가입이 성공적으로 완료되었습니다. 로그인해주세요.
</div>
<% } %>

<form action="/login" method="post">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

  <div>
    <label>이메일:</label>
    <input type="email" name="username" required>
  </div>

  <div>
    <label>비밀번호:</label>
    <input type="password" name="password" required>
  </div>

  <button type="submit">로그인</button>
</form>

<p>계정이 없으신가요? <a href="/signup">회원가입</a></p>
</body>
</html>