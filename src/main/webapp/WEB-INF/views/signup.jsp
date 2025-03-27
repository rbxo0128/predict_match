<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>LCK 예측 - 회원가입</title>
  <link href="${pageContext.request.contextPath}/asset/css/output.css" rel="stylesheet">
  <!-- Add Font Awesome for better icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans">
<div class="min-h-screen flex flex-col md:flex-row">
  <!-- 왼쪽 이미지 섹션 (모바일에서는 숨김) -->
  <div class="hidden md:block md:w-1/2 bg-cover bg-center" style="background-image: url('https://images.contentstack.io/v3/assets/bltad9188aa9a70543a/blt77f17a28f5fa2e40/5e707272cb94665422c45593/lck-spring-2018.jpg')">
    <div class="h-full bg-blue-900 bg-opacity-70 flex flex-col justify-center items-center text-white p-12">
      <div class="max-w-md">
        <h1 class="text-4xl font-bold mb-4">LCK 경기 예측</h1>
        <p class="text-xl mb-8">회원가입하고 즐겁게 예측에 참여하세요!</p>
        <ul class="space-y-4">
          <li class="flex items-start">
            <div class="flex-shrink-0">
              <i class="fas fa-check-circle text-blue-400 mt-1"></i>
            </div>
            <p class="ml-3">무료 가입 후 바로 예측 시작</p>
          </li>
          <li class="flex items-start">
            <div class="flex-shrink-0">
              <i class="fas fa-check-circle text-blue-400 mt-1"></i>
            </div>
            <p class="ml-3">정확한 예측으로 포인트 획득</p>
          </li>
          <li class="flex items-start">
            <div class="flex-shrink-0">
              <i class="fas fa-check-circle text-blue-400 mt-1"></i>
            </div>
            <p class="ml-3">열정적인 e스포츠 팬들과 함께하세요</p>
          </li>
        </ul>
      </div>
    </div>
  </div>

  <!-- 회원가입 폼 섹션 -->
  <div class="w-full md:w-1/2 flex items-center justify-center p-6">
    <div class="w-full max-w-md">
      <!-- 로고 및 헤더 -->
      <div class="text-center mb-8">
        <a href="/" class="inline-block">
          <h1 class="text-3xl font-bold text-blue-600 flex items-center justify-center">
            <i class="fas fa-gamepad mr-2"></i> LCK 예측
          </h1>
        </a>
        <p class="mt-2 text-gray-600">새 계정을 만들고 경기 예측을 시작하세요</p>
      </div>

      <!-- 알림 메시지 -->
      <% if (request.getAttribute("error") != null) { %>
      <div class="mb-6 bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded shadow-sm" role="alert">
        <div class="flex items-center">
          <i class="fas fa-exclamation-circle mr-2"></i>
          <p><%= request.getAttribute("error") %></p>
        </div>
      </div>
      <% } %>

      <!-- 회원가입 카드 -->
      <div class="bg-white p-8 rounded-lg shadow-lg">
        <form action="/signup" method="post" class="space-y-6">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

          <div>
            <label for="username" class="block text-sm font-medium text-gray-700 mb-1">사용자명</label>
            <div class="relative">
              <input type="text" id="username" name="username" required
                     class="pl-10 w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 shadow-sm"
                     placeholder="닉네임 (3-50자)">
            </div>
            <% if (request.getAttribute("usernameError") != null) { %>
            <p class="mt-1 text-sm text-red-600"><%= request.getAttribute("usernameError") %></p>
            <% } else { %>
            <p class="mt-1 text-xs text-gray-500">다른 사용자에게 표시되는 이름입니다</p>
            <% } %>
          </div>

          <div>
            <label for="email" class="block text-sm font-medium text-gray-700 mb-1">이메일</label>
            <div class="relative">
              <input type="email" id="email" name="email" required
                     class="pl-10 w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 shadow-sm"
                     placeholder="your@email.com">
            </div>
            <% if (request.getAttribute("emailError") != null) { %>
            <p class="mt-1 text-sm text-red-600"><%= request.getAttribute("emailError") %></p>
            <% } else { %>
            <p class="mt-1 text-xs text-gray-500">로그인 및 알림에 사용됩니다</p>
            <% } %>
          </div>

          <div>
            <label for="password" class="block text-sm font-medium text-gray-700 mb-1">비밀번호</label>
            <div class="relative">
              <input type="password" id="password" name="password" required
                     class="pl-10 w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 shadow-sm"
                     placeholder="••••••••">
            </div>
            <% if (request.getAttribute("passwordError") != null) { %>
            <p class="mt-1 text-sm text-red-600"><%= request.getAttribute("passwordError") %></p>
            <% } else { %>
            <p class="mt-1 text-xs text-gray-500">비밀번호는 최소 8자 이상이어야 합니다</p>
            <% } %>
          </div>

          <div class="flex items-center">
            <input id="terms" name="terms" type="checkbox" required
                   class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
            <label for="terms" class="ml-2 block text-sm text-gray-700">
                <span class="text-gray-700">
                  <a href="#" class="text-blue-600 hover:text-blue-500">이용약관</a>과
                  <a href="#" class="text-blue-600 hover:text-blue-500">개인정보처리방침</a>에 동의합니다
                </span>
            </label>
          </div>

          <div>
            <button type="submit"
                    class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors">
              <i class="fas fa-user-plus mr-2"></i> 회원가입
            </button>
          </div>
        </form>

      </div>

      <!-- 로그인 링크 -->
      <div class="mt-6 text-center">
        <p class="text-sm text-gray-600">
          이미 계정이 있으신가요?
          <a href="/login" class="font-medium text-blue-600 hover:text-blue-500 inline-flex items-center">
            로그인 <i class="fas fa-arrow-right ml-1"></i>
          </a>
        </p>
      </div>

      <!-- 홈으로 돌아가기 -->
      <div class="mt-8 text-center">
        <a href="/" class="inline-flex items-center text-sm text-gray-500 hover:text-gray-700">
          <i class="fas fa-arrow-left mr-1"></i> 홈으로 돌아가기
        </a>
      </div>
    </div>
  </div>
</div>

<!-- 비밀번호 유효성 검사 스크립트 -->
<script>
  document.addEventListener('DOMContentLoaded', function() {
    const passwordInput = document.getElementById('password');

    passwordInput.addEventListener('input', function() {
      const password = this.value;
      const minLength = 8;

      if (password.length < minLength) {
        this.setCustomValidity(`비밀번호는 최소 ${minLength}자 이상이어야 합니다.`);
      } else {
        this.setCustomValidity('');
      }
    });
  });
</script>
</body>
</html>