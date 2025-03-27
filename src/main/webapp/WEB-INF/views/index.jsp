<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LCK 경기 예측</title>
    <link href="${pageContext.request.contextPath}/asset/css/output.css" rel="stylesheet">
</head>
<body class="bg-gray-100 font-sans">
<!-- 네비게이션 바 -->
<nav class="bg-white shadow-md">
    <div class="max-w-7xl mx-auto px-4">
        <div class="flex justify-between h-16">
            <div class="flex">
                <div class="flex-shrink-0 flex items-center">
                    <img class="h-16 w-auto" src="/images/logo.png" alt="LCK Logo">
                    <span class="ml-2 font-bold text-xl text-gray-800">LCK 예측</span>
                </div>
                <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                    <a href="/" class="border-blue-500 text-gray-900 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
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
            <div class="flex items-center">
                <%
                    // 로그인 상태 확인 (실제 구현은 Spring Security에 맞게 조정 필요)
                    boolean isAuthenticated = request.getUserPrincipal() != null;
                    if (isAuthenticated) {
                %>
                <span class="text-sm text-gray-700 mr-4">
              <%= request.getUserPrincipal().getName() %> 님
              <span class="ml-1 text-blue-600 font-medium">
                0 P <!-- 실제 포인트로 대체 필요 -->
              </span>
            </span>
                <a href="/logout" class="text-sm text-gray-700 hover:text-gray-900 font-medium">로그아웃</a>
                <% } else { %>
                <a href="/login" class="text-gray-700 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">로그인</a>
                <a href="/signup" class="bg-blue-600 text-white hover:bg-blue-700 px-3 py-2 rounded-md text-sm font-medium ml-3">회원가입</a>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<!-- 히어로 섹션 -->
<div class="relative bg-gray-800">
    <div class="absolute inset-0">
        <img class="w-full h-full object-cover" src="https://images.contentstack.io/v3/assets/bltad9188aa9a70543a/blte9d0e5fb99851053/5e707279d8b3c6293f421faf/LCK_SPRING_PLAYOFFS_2020_HEADER.jpg" alt="LCK">
        <div class="absolute inset-0 bg-gray-800 opacity-75"></div>
    </div>
    <div class="relative max-w-7xl mx-auto py-24 px-4 sm:py-32 sm:px-6 lg:px-8">
        <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl">LCK 경기 결과를 예측하고<br>포인트를 획득하세요!</h1>
        <p class="mt-6 text-xl text-gray-300 max-w-3xl">
            좋아하는 팀의 승리를 응원하고 정확한 예측으로 포인트를 쌓아보세요.
            매주 업데이트되는 경기 일정과 실시간 순위표를 확인할 수 있습니다.
        </p>
        <div class="mt-10">
            <a href="/matches" class="inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700">
                경기 예측하기
            </a>
        </div>
    </div>
</div>

<!-- 주요 기능 소개 -->
<div class="py-12 bg-white">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="lg:text-center">
            <h2 class="text-base text-blue-600 font-semibold tracking-wide uppercase">LCK 예측</h2>
            <p class="mt-2 text-3xl leading-8 font-extrabold tracking-tight text-gray-900 sm:text-4xl">
                전문가처럼 경기를 분석하고 예측하세요
            </p>
            <p class="mt-4 max-w-2xl text-xl text-gray-500 lg:mx-auto">
                LCK 경기를 더 재미있게 즐기는 방법, 경기 결과를 예측하고 포인트를 획득하세요.
            </p>
        </div>

        <div class="mt-10">
            <dl class="space-y-10 md:space-y-0 md:grid md:grid-cols-2 md:gap-x-8 md:gap-y-10">
                <div class="relative">
                    <dt>
                        <div class="absolute flex items-center justify-center h-12 w-12 rounded-md bg-blue-500 text-white">
                            <!-- 아이콘 자리 -->
                            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                            </svg>
                        </div>
                        <p class="ml-16 text-lg leading-6 font-medium text-gray-900">실시간 경기 일정</p>
                    </dt>
                    <dd class="mt-2 ml-16 text-base text-gray-500">
                        최신 LCK 경기 일정을 확인하고 경기 결과를 예측할 수 있습니다. 경기 시작 전까지 언제든지 예측을 변경할 수 있습니다.
                    </dd>
                </div>

                <div class="relative">
                    <dt>
                        <div class="absolute flex items-center justify-center h-12 w-12 rounded-md bg-blue-500 text-white">
                            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                            </svg>
                        </div>
                        <p class="ml-16 text-lg leading-6 font-medium text-gray-900">포인트 시스템</p>
                    </dt>
                    <dd class="mt-2 ml-16 text-base text-gray-500">
                        정확한 예측으로 포인트를 획득하고 랭킹에 도전하세요. 획득한 포인트는 다양한 혜택으로 교환할 수 있습니다.
                    </dd>
                </div>

                <div class="relative">
                    <dt>
                        <div class="absolute flex items-center justify-center h-12 w-12 rounded-md bg-blue-500 text-white">
                            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                            </svg>
                        </div>
                        <p class="ml-16 text-lg leading-6 font-medium text-gray-900">사용자 순위</p>
                    </dt>
                    <dd class="mt-2 ml-16 text-base text-gray-500">
                        예측 정확도와 획득한 포인트를 기준으로 사용자 순위가 결정됩니다. 최고의 예측가에 도전하세요!
                    </dd>
                </div>

                <div class="relative">
                    <dt>
                        <div class="absolute flex items-center justify-center h-12 w-12 rounded-md bg-blue-500 text-white">
                            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 8h10M7 12h4m1 8l-4-4H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-3l-4 4z" />
                            </svg>
                        </div>
                        <p class="ml-16 text-lg leading-6 font-medium text-gray-900">커뮤니티</p>
                    </dt>
                    <dd class="mt-2 ml-16 text-base text-gray-500">
                        다른 사용자들과 경기에 대한 의견을 공유하고 함께 LCK를 즐겨보세요. 경기에 대한 분석과 정보를 얻을 수 있습니다.
                    </dd>
                </div>
            </dl>
        </div>
    </div>
</div>

<!-- 푸터 -->
<footer class="bg-white">
    <div class="max-w-7xl mx-auto py-12 px-4 overflow-hidden sm:px-6 lg:px-8">
        <nav class="flex flex-wrap justify-center">
            <div class="px-5 py-2">
                <a href="#" class="text-base text-gray-500 hover:text-gray-900">
                    서비스 소개
                </a>
            </div>
            <div class="px-5 py-2">
                <a href="#" class="text-base text-gray-500 hover:text-gray-900">
                    이용약관
                </a>
            </div>
            <div class="px-5 py-2">
                <a href="#" class="text-base text-gray-500 hover:text-gray-900">
                    개인정보처리방침
                </a>
            </div>
            <div class="px-5 py-2">
                <a href="#" class="text-base text-gray-500 hover:text-gray-900">
                    공지사항
                </a>
            </div>
            <div class="px-5 py-2">
                <a href="#" class="text-base text-gray-500 hover:text-gray-900">
                    문의하기
                </a>
            </div>
        </nav>
        <p class="mt-8 text-center text-base text-gray-400">
            &copy; 2025 LCK 경기 예측. All rights reserved.
        </p>
    </div>
</footer>
</body>
</html>