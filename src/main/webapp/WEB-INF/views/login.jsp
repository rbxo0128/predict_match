<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>LCK 예측 - 로그인</title>
  <link href="${pageContext.request.contextPath}/asset/css/output.css" rel="stylesheet">
</head>
<body class="bg-gray-100 font-sans">
<div class="min-h-screen flex items-center justify-center">
  <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
    <h2 class="text-2xl font-bold text-lck-primary mb-6 text-center">LCK 예측 로그인</h2>

    <c:if test="${param.error != null}">
      <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
        잘못된 이메일 또는 비밀번호입니다.
      </div>
    </c:if>

    <c:if test="${param.logout != null}">
      <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
        성공적으로 로그아웃되었습니다.
      </div>
    </c:if>

    <c:if test="${param.signup != null}">
      <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
        회원가입이 성공적으로 완료되었습니다. 로그인해주세요.
      </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login-process" method="post" class="space-y-4">
      <sec:csrfInput />

      <div>
        <label for="username" class="block text-sm font-medium text-gray-700 mb-1">이메일</label>
        <input id="username" type="email" name="username" required
               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
      </div>

      <div>
        <label for="password" class="block text-sm font-medium text-gray-700 mb-1">비밀번호</label>
        <input id="password" type="password" name="password" required
               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
      </div>

      <button type="submit"
              class="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors">
        로그인
      </button>
    </form>

    <div class="mt-6 text-center text-sm">
      계정이 없으신가요? <a href="/signup" class="text-blue-600 hover:text-blue-800 font-medium">회원가입</a>
    </div>
  </div>
</div>
</body>
</html>