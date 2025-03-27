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
  <!-- Add Font Awesome for better icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans">
<div class="min-h-screen flex flex-col md:flex-row">
  <!-- 왼쪽 이미지 섹션 (모바일에서는 숨김) -->
  <div class="hidden md:block md:w-1/2 bg-cover bg-center" style="background-image: url('https://images.contentstack.io/v3/assets/bltad9188aa9a70543a/blt711d7b66ed0d5efb/5e70728fc7e156403cf09bf2/lck-og-image-2020.jpg')">
    <div class="h-full bg-blue-900 bg-opacity-70 flex flex-col justify-center items-center text-white p-12">
      <div class="max-w-md">
        <h1 class="text-4xl font-bold mb-4">LCK 경기 예측</h1>
        <p class="text-xl mb-8">승부를 예측하고 포인트를 획득하세요!</p>
        <ul class="space-y-4">
          <li class="flex items-start">
            <div class="flex-shrink-0">
              <i class="fas fa-check-circle text-blue-400 mt-1"></i>
            </div>
            <p class="ml-3">실시간으로 업데이트되는 LCK 경기 일정을 확인하세요</p>
          </li>
          <li class="flex items-start">
            <div class="flex-shrink-0">
              <i class="fas fa-check-circle text-blue-400 mt-1"></i>
            </div>
            <p class="ml-3">정확한 예측으로 포인트를 획득하고 순위에 도전하세요</p>
          </li>
          <li class="flex items-start">
            <div class="flex-shrink-0">
              <i class="fas fa-check-circle text-blue-400 mt-1"></i>
            </div>
            <p class="ml-3">다른 팬들과 함께 e스포츠의 열기를 느껴보세요</p>
          </li>
        </ul>
      </div>
    </div>
  </div>

  <!-- 로그인 폼 섹션 -->
  <div class="w-full md:w-1/2 flex items-center justify-center p-6">
    <div class="w-full max-w-md">
      <!-- 로고 및 헤더 -->
      <div class="text-center mb-10">
        <a href="/" class="inline-block">
          <h1 class="text-3xl font-bold text-blue-600 flex items-center justify-center">
            <i class="fas fa-gamepad mr-2"></i> LCK 예측
          </h1>
        </a>
        <p class="mt-2 text-gray-600">계정에 로그인하고 경기 예측을 시작하세요</p>
      </div>

      <!-- 알림 메시지 -->
      <c:if test="${param.error != null}">
        <div class="mb-6 bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded shadow-sm" role="alert">
          <div class="flex items-center">
            <i class="fas fa-exclamation-circle mr-2"></i>
            <p>잘못된 이메일 또는 비밀번호입니다.</p>
          </div>
        </div>
      </c:if>

      <c:if test="${param.logout != null}">
        <div class="mb-6 bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded shadow-sm" role="alert">
          <div class="flex items-center">
            <i class="fas fa-check-circle mr-2"></i>
            <p>성공적으로 로그아웃되었습니다.</p>
          </div>
        </div>
      </c:if>

      <c:if test="${param.signup != null}">
        <div class="mb-6 bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded shadow-sm" role="alert">
          <div class="flex items-center">
            <i class="fas fa-check-circle mr-2"></i>
            <p>회원가입이 성공적으로 완료되었습니다. 로그인해주세요.</p>
          </div>
        </div>
      </c:if>

      <!-- 로그인 카드 -->
      <div class="bg-white p-8 rounded-lg shadow-lg">
        <form action="${pageContext.request.contextPath}/login-process" method="post" class="space-y-6">
          <sec:csrfInput />

          <div>
            <label for="username" class="block text-sm font-medium text-gray-700 mb-1">이메일</label>
            <div class="relative">
              <input id="username" name="username" type="email" required
                     class="pl-10 w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 shadow-sm"
                     placeholder="your@email.com">
            </div>
          </div>

          <div>
            <label for="password" class="block text-sm font-medium text-gray-700 mb-1">비밀번호</label>
            <div class="relative">
              <input id="password" name="password" type="password" required
                     class="pl-10 w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 shadow-sm"
                     placeholder="••••••••">
            </div>
          </div>

          <div class="flex items-center justify-between">
            <div class="flex items-center">
              <input id="remember-me" name="remember-me" type="checkbox" class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
              <label for="remember-me" class="ml-2 block text-sm text-gray-700">
                로그인 상태 유지
              </label>
            </div>
            <div class="text-sm">
              <a href="#" class="font-medium text-blue-600 hover:text-blue-500">
                비밀번호를 잊으셨나요?
              </a>
            </div>
          </div>

          <div>
            <button type="submit" class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors">
              <i class="fas fa-sign-in-alt mr-2"></i> 로그인
            </button>
          </div>
        </form>
      </div>

      <!-- 회원가입 링크 -->
      <div class="mt-6 text-center">
        <p class="text-sm text-gray-600">
          계정이 없으신가요?
          <a href="/signup" class="font-medium text-blue-600 hover:text-blue-500 inline-flex items-center">
            회원가입 <i class="fas fa-arrow-right ml-1"></i>
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
</body>
</html>