<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>LCK 예측 - 오류</title>
  <link href="${pageContext.request.contextPath}/asset/css/output.css" rel="stylesheet">
</head>
<body class="bg-gray-100 font-sans">
<!-- 네비게이션 바 -->
<nav class="bg-white shadow-md">
  <div class="max-w-7xl mx-auto px-4">
    <div class="flex justify-between h-16">
      <div class="flex">
        <div class="flex-shrink-0 flex items-center">
          <span class="font-bold text-xl text-gray-800">LCK 예측</span>
        </div>
        <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
          <a href="/" class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
            홈
          </a>
          <a href="/matches" class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
            경기 일정
          </a>
          <a href="/rankings" class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
            순위표
          </a>
          <a href="/predictions" class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
            내 예측
          </a>
        </div>
      </div>
    </div>
  </div>
</nav>

<!-- 메인 컨텐츠 -->
<div class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
  <div class="max-w-md w-full space-y-8 bg-white p-10 rounded-lg shadow-md">
    <div>
      <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
        오류가 발생했습니다
      </h2>
      <p class="mt-2 text-center text-sm text-gray-600">
        요청하신 작업을 처리하는 중 문제가 발생했습니다.
      </p>
    </div>
    <div class="bg-red-50 border-l-4 border-red-400 p-4">
      <div class="flex">
        <div class="flex-shrink-0">
          <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
          </svg>
        </div>
        <div class="ml-3">
          <p class="text-sm text-red-700">
            ${error}
          </p>
        </div>
      </div>
    </div>
    <div class="flex items-center justify-center">
      <a href="/" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
        홈으로 돌아가기
      </a>
    </div>
  </div>
</div>

<!-- 푸터 -->
<footer class="bg-white">
  <div class="max-w-7xl mx-auto py-12 px-4 overflow-hidden sm:px-6 lg:px-8">
    <nav class="flex flex-wrap justify-center">
      <div class="px-5 py-2">
        <a href="#" class="text-base text-gray-500 hover:text-gray-900">서비스 소개</a>
      </div>
      <div class="px-5 py-2">
        <a href="#" class="text-base text-gray-500 hover:text-gray-900">이용약관</a>
      </div>
      <div class="px-5 py-2">
        <a href="#" class="text-base text-gray-500 hover:text-gray-900">개인정보처리방침</a>
      </div>
      <div class="px-5 py-2">
        <a href="#" class="text-base text-gray-500 hover:text-gray-900">공지사항</a>
      </div>
      <div class="px-5 py-2">
        <a href="#" class="text-base text-gray-500 hover:text-gray-900">문의하기</a>
      </div>
    </nav>
    <p class="mt-8 text-center text-base text-gray-400">
      &copy; 2025 LCK 경기 예측. All rights reserved.
    </p>
  </div>
</footer>
</body>
</html>