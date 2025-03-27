<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>회원가입</title>
</head>
<body>
<h2>회원가입</h2>

<form:form action="/signup" method="post" modelAttribute="signUpRequest">
  <div>
    <label>사용자명:</label>
    <form:input path="username" />
    <form:errors path="username" cssClass="error" />
  </div>

  <div>
    <label>이메일:</label>
    <form:input path="email" type="email" />
    <form:errors path="email" cssClass="error" />
  </div>

  <div>
    <label>비밀번호:</label>
    <form:input path="password" type="password" />
    <form:errors path="password" cssClass="error" />
  </div>

  <c:if test="${not empty error}">
    <div class="error">${error}</div>
  </c:if>

  <button type="submit">회원가입</button>
</form:form>
</body>
</html>