<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>LCK 예측 - 회원가입</title>
  <link href="${pageContext.request.contextPath}/asset/css/output.css" rel="stylesheet">
</head>
<body class="bg-gray-100 font-sans">
<div class="min-h-screen flex items-center justify-center p-4">
  <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
    <div class="flex justify-center mb-6">
      <img src="https://lolesports.com/darkroom/500/27/95607e1d8b9df962dd15696a82154330:6a9d2e1df970dff0d0a0d97365018ddf" alt="LCK Logo" class="h-16">
    </div>

    <h2 class="text-2xl font-bold text-center text-gray-800 mb-6">LCK 예측 회원가입</h2>

    <% if (request.getAttribute("error") != null) { %>
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
      <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <form action="/signup" method="post" class="space-y-4">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

      <div>
        <label for="username" class="block text-sm font-medium text-gray-700 mb-1">사용자명</label>
        <input type="text" id="username" name="username" required
               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" />
        <% if (request.getAttribute("usernameError") != null) { %>
        <p class="text-red-500 text-xs mt-1"><%= request.getAttribute("usernameError") %></p>
        <% } %>
      </div>

      <div>
        <label for="email" class="block text-sm font-medium text-gray-700 mb-1">이메일</label>
        <input type="email" id="email" name="email" required
               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" />
        <% if (request.getAttribute("emailError") != null) { %>
        <p class="text-red-500 text-xs mt-1"><%= request.getAttribute("emailError") %></p>
        <% } %>
      </div>

      <div>
        <label for="password" class="block text-sm font-medium text-gray-700 mb-1">비밀번호</label>
        <input type="password" id="password" name="password" required
               class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" />
        <% if (request.getAttribute("passwordError") != null) { %>
        <p class="text-red-500 text-xs mt-1"><%= request.getAttribute("passwordError") %></p>
        <% } %>
        <p class="text-xs text-gray-500 mt-1">비밀번호는 최소 8자 이상이어야 합니다.</p>
      </div>

      <button type="submit"
              class="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors">
        회원가입
      </button>
    </form>

    <div class="mt-6 text-center text-sm">
      이미 계정이 있으신가요? <a href="/login" class="text-blue-600 hover:text-blue-800 font-medium">로그인</a>
    </div>
  </div>
</div>
</body>
</html>