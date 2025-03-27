<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LCK 경기 예측 - 정확한 예측으로 포인트를 획득하세요</title>
    <meta name="description" content="LCK 경기 결과를 예측하고 정확도에 따라 포인트를 획득할 수 있는 서비스입니다.">
    <link href="${pageContext.request.contextPath}/asset/css/output.css" rel="stylesheet">
    <!-- Add Font Awesome for better icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Add AOS for scroll animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
</head>
<body class="bg-gray-100 font-sans">
<!-- 네비게이션 바 -->
<nav class="bg-white shadow-md sticky top-0 z-10">
    <div class="max-w-7xl mx-auto px-4">
        <div class="flex justify-between h-16">
            <div class="flex">
                <div class="flex-shrink-0 flex items-center">
                    <span class="font-bold text-xl text-blue-600">LCK 예측</span>
                </div>
                <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
                    <a href="/" class="border-blue-500 text-gray-900 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                        <i class="fas fa-home mr-1"></i> 홈
                    </a>
                    <a href="/matches" class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                        <i class="fas fa-gamepad mr-1"></i> 경기 일정
                    </a>
                    <a href="/rankings" class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                        <i class="fas fa-trophy mr-1"></i> 순위표
                    </a>
                    <a href="/predictions" class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                        <i class="fas fa-chart-line mr-1"></i> 내 예측
                    </a>
                </div>
            </div>
            <div class="flex items-center">
                <sec:authorize access="isAuthenticated()">
                    <div class="flex items-center bg-gray-100 px-3 py-1 rounded-full">
                        <span class="text-sm text-gray-700 mr-2">
                            <i class="fas fa-user mr-1"></i> <sec:authentication property="principal.username" />
                        </span>
                        <span class="text-blue-600 font-medium flex items-center">
                            <i class="fas fa-coins mr-1 text-yellow-500"></i> 0 P
                        </span>
                    </div>
                    <a href="/logout" class="ml-4 text-sm text-gray-700 hover:text-red-600 font-medium flex items-center">
                        <i class="fas fa-sign-out-alt mr-1"></i> 로그아웃
                    </a>
                </sec:authorize>
                <sec:authorize access="isAnonymous()">
                    <a href="/login" class="text-gray-700 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium flex items-center">
                        <i class="fas fa-sign-in-alt mr-1"></i> 로그인
                    </a>
                    <a href="/signup" class="bg-blue-600 text-white hover:bg-blue-700 px-3 py-2 rounded-md text-sm font-medium ml-3 flex items-center transition-colors">
                        <i class="fas fa-user-plus mr-1"></i> 회원가입
                    </a>
                </sec:authorize>
            </div>
        </div>
    </div>
    <!-- 모바일 메뉴 (접혀있음) -->
    <div class="sm:hidden bg-white border-t" id="mobile-menu" style="display: none;">
        <div class="pt-2 pb-3 space-y-1">
            <a href="/" class="bg-blue-50 border-blue-500 text-blue-700 block pl-3 pr-4 py-2 border-l-4 text-base font-medium">
                <i class="fas fa-home mr-2"></i> 홈
            </a>
            <a href="/matches" class="border-transparent text-gray-500 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-700 block pl-3 pr-4 py-2 border-l-4 text-base font-medium">
                <i class="fas fa-gamepad mr-2"></i> 경기 일정
            </a>
            <a href="/rankings" class="border-transparent text-gray-500 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-700 block pl-3 pr-4 py-2 border-l-4 text-base font-medium">
                <i class="fas fa-trophy mr-2"></i> 순위표
            </a>
            <a href="/predictions" class="border-transparent text-gray-500 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-700 block pl-3 pr-4 py-2 border-l-4 text-base font-medium">
                <i class="fas fa-chart-line mr-2"></i> 내 예측
            </a>
        </div>
        <div class="pt-4 pb-3 border-t border-gray-200">
            <sec:authorize access="isAuthenticated()">
                <div class="flex items-center px-4">
                    <div class="flex-shrink-0">
                        <div class="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                            <i class="fas fa-user"></i>
                        </div>
                    </div>
                    <div class="ml-3">
                        <div class="text-base font-medium text-gray-800"><sec:authentication property="principal.username" /></div>
                        <div class="text-sm font-medium text-blue-600 flex items-center">
                            <i class="fas fa-coins mr-1 text-yellow-500"></i> 0 P
                        </div>
                    </div>
                </div>
                <div class="mt-3 space-y-1">
                    <a href="/logout" class="block px-4 py-2 text-base font-medium text-gray-500 hover:text-gray-800 hover:bg-gray-100">
                        <i class="fas fa-sign-out-alt mr-2"></i> 로그아웃
                    </a>
                </div>
            </sec:authorize>
        </div>
    </div>
</nav>

<!-- 모바일 메뉴 토글 버튼 -->
<div class="sm:hidden hidden fixed bottom-4 right-4 z-20">
    <button id="mobile-menu-button" class="bg-blue-600 text-white p-3 rounded-full shadow-lg flex items-center justify-center focus:outline-none">
        <i class="fas fa-bars"></i>
    </button>
</div>

<!-- 히어로 섹션 -->
<div class="relative bg-gray-800">
    <div class="absolute inset-0">
        <div class="absolute inset-0 bg-gradient-to-r from-gray-900 via-gray-800 opacity-75"></div>
    </div>
    <div class="relative max-w-7xl mx-auto py-24 px-4 sm:py-32 sm:px-6 lg:px-8">
        <div data-aos="fade-right" data-aos-duration="1000">
            <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl">
                LCK 경기 결과를<br class="hidden sm:block"> 예측하고<br>
                <span class="text-blue-400">포인트</span>를 획득하세요!
            </h1>
            <p class="mt-6 text-xl text-gray-300 max-w-3xl">
                좋아하는 팀의 승리를 응원하고 정확한 예측으로 포인트를 쌓아보세요.
                매주 업데이트되는 경기 일정과 실시간 순위표를 확인할 수 있습니다.
            </p>
            <div class="mt-10 flex flex-wrap gap-4">
                <sec:authorize access="isAnonymous()">
                    <a href="/signup" class="inline-flex items-center justify-center px-5 py-3 border border-white text-base font-medium rounded-md text-white hover:bg-white hover:bg-opacity-20 transition-colors">
                        <i class="fas fa-user-plus mr-2"></i> 회원가입
                    </a>
                </sec:authorize>
                <a href="/matches" class="inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 transition-colors shadow-lg">
                    <i class="fas fa-gamepad mr-2"></i> 경기 예측하기
                </a>

            </div>
        </div>
    </div>
</div>

<!-- 다가오는 경기 섹션 (샘플 데이터) -->
<div class="py-12 bg-white">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center">
            <h2 class="text-base text-blue-600 font-semibold tracking-wide uppercase">
                다가오는 경기
            </h2>
            <p class="mt-2 text-3xl leading-8 font-extrabold tracking-tight text-gray-900 sm:text-4xl">
                오늘의 LCK 매치업
            </p>
            <p class="mt-4 max-w-2xl text-xl text-gray-500 lg:mx-auto">
                오늘 펼쳐질 경기를 확인하고 승자를 예측해보세요.
            </p>
        </div>

        <div class="mt-10" data-aos="fade-up" data-aos-duration="800">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- 경기 카드 1 -->
                <div class="bg-white overflow-hidden shadow-lg rounded-lg border border-gray-200 hover:shadow-xl transition-shadow duration-300">
                    <div class="bg-blue-600 px-4 py-2 text-white font-medium flex items-center justify-between">
                        <span class="flex items-center">
                            <i class="fas fa-calendar-day mr-2"></i> 오늘 18:00
                        </span>
                        <span class="text-xs text-white-800 px-2 py-1 rounded-full">BO3</span>
                    </div>
                    <div class="p-5">
                        <div class="flex items-center justify-between mb-4">
                            <div class="flex flex-col items-center justify-center w-5/12">
                                <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mb-2">
                                    <span class="text-2xl font-bold text-blue-600">T1</span>
                                </div>
                                <span class="text-sm font-medium text-gray-900">T1</span>
                            </div>
                            <div class="flex flex-col items-center justify-center w-2/12">
                                <span class="text-2xl font-bold text-gray-400 mb-2">VS</span>
                                <span class="text-xs text-gray-500">정규시즌</span>
                            </div>
                            <div class="flex flex-col items-center justify-center w-5/12">
                                <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mb-2">
                                    <span class="text-2xl font-bold text-blue-600">DK</span>
                                </div>
                                <span class="text-sm font-medium text-gray-900">DK</span>
                            </div>
                        </div>
                        <a href="/matches" class="block w-full text-center bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-md transition-colors">
                            <i class="fas fa-chart-pie mr-1"></i> 예측하기
                        </a>
                    </div>
                </div>

                <!-- 경기 카드 2 -->
                <div class="bg-white overflow-hidden shadow-lg rounded-lg border border-gray-200 hover:shadow-xl transition-shadow duration-300">
                    <div class="bg-blue-600 px-4 py-2 text-white font-medium flex items-center justify-between">
                        <span class="flex items-center">
                            <i class="fas fa-calendar-day mr-2"></i> 오늘 20:00
                        </span>
                        <span class="text-xs text-white-800 px-2 py-1 rounded-full">BO3</span>
                    </div>
                    <div class="p-5">
                        <div class="flex items-center justify-between mb-4">
                            <div class="flex flex-col items-center justify-center w-5/12">
                                <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mb-2">
                                    <span class="text-2xl font-bold text-blue-600">GEN</span>
                                </div>
                                <span class="text-sm font-medium text-gray-900">젠지</span>
                            </div>
                            <div class="flex flex-col items-center justify-center w-2/12">
                                <span class="text-2xl font-bold text-gray-400 mb-2">VS</span>
                                <span class="text-xs text-gray-500">정규시즌</span>
                            </div>
                            <div class="flex flex-col items-center justify-center w-5/12">
                                <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mb-2">
                                    <span class="text-2xl font-bold text-blue-600">KT</span>
                                </div>
                                <span class="text-sm font-medium text-gray-900">KT</span>
                            </div>
                        </div>
                        <a href="/matches" class="block w-full text-center bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-md transition-colors">
                            <i class="fas fa-chart-pie mr-1"></i> 예측하기
                        </a>
                    </div>
                </div>

                <!-- 경기 카드 3 -->
                <div class="bg-white overflow-hidden shadow-lg rounded-lg border border-gray-200 hover:shadow-xl transition-shadow duration-300">
                    <div class="bg-blue-600 px-4 py-2 text-white font-medium flex items-center justify-between">
                        <span class="flex items-center">
                            <i class="fas fa-calendar-tomorrow mr-2"></i> 내일 17:00
                        </span>
                        <span class="text-xs text-white-800 px-2 py-1 rounded-full">BO3</span>
                    </div>
                    <div class="p-5">
                        <div class="flex items-center justify-between mb-4">
                            <div class="flex flex-col items-center justify-center w-5/12">
                                <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mb-2">
                                    <span class="text-2xl font-bold text-blue-600">DRX</span>
                                </div>
                                <span class="text-sm font-medium text-gray-900">DRX</span>
                            </div>
                            <div class="flex flex-col items-center justify-center w-2/12">
                                <span class="text-2xl font-bold text-gray-400 mb-2">VS</span>
                                <span class="text-xs text-gray-500">정규시즌</span>
                            </div>
                            <div class="flex flex-col items-center justify-center w-5/12">
                                <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mb-2">
                                    <span class="text-2xl font-bold text-blue-600">BRO</span>
                                </div>
                                <span class="text-sm font-medium text-gray-900">농심</span>
                            </div>
                        </div>
                        <a href="/matches" class="block w-full text-center bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-md transition-colors">
                            <i class="fas fa-chart-pie mr-1"></i> 예측하기
                        </a>
                    </div>
                </div>
            </div>
            <div class="mt-6 text-center" data-aos="fade-up" data-aos-delay="200">
                <a href="/matches" class="inline-flex items-center text-blue-600 hover:text-blue-800">
                    전체 일정 보기
                    <i class="fas fa-arrow-right ml-2"></i>
                </a>
            </div>
        </div>
    </div>
</div>

<!-- 주요 기능 소개 -->
<div class="py-12 bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="lg:text-center" data-aos="fade-up">
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
                <div class="relative" data-aos="fade-up" data-aos-delay="100">
                    <dt>
                        <div class="absolute flex items-center justify-center h-12 w-12 rounded-md bg-blue-500 text-white">
                            <i class="fas fa-calendar-alt text-lg"></i>
                        </div>
                        <p class="ml-16 text-lg leading-6 font-medium text-gray-900">실시간 경기 일정</p>
                    </dt>
                    <dd class="mt-2 ml-16 text-base text-gray-500">
                        최신 LCK 경기 일정을 확인하고 경기 결과를 예측할 수 있습니다. 경기 시작 전까지 언제든지 예측을 변경할 수 있습니다.
                    </dd>
                </div>

                <div class="relative" data-aos="fade-up" data-aos-delay="200">
                    <dt>
                        <div class="absolute flex items-center justify-center h-12 w-12 rounded-md bg-blue-500 text-white">
                            <i class="fas fa-coins text-lg"></i>
                        </div>
                        <p class="ml-16 text-lg leading-6 font-medium text-gray-900">포인트 시스템</p>
                    </dt>
                    <dd class="mt-2 ml-16 text-base text-gray-500">
                        정확한 예측으로 포인트를 획득하고 랭킹에 도전하세요. 획득한 포인트는 다양한 혜택으로 교환할 수 있습니다.
                    </dd>
                </div>

                <div class="relative" data-aos="fade-up" data-aos-delay="300">
                    <dt>
                        <div class="absolute flex items-center justify-center h-12 w-12 rounded-md bg-blue-500 text-white">
                            <i class="fas fa-trophy text-lg"></i>
                        </div>
                        <p class="ml-16 text-lg leading-6 font-medium text-gray-900">사용자 순위</p>
                    </dt>
                    <dd class="mt-2 ml-16 text-base text-gray-500">
                        예측 정확도와 획득한 포인트를 기준으로 사용자 순위가 결정됩니다. 최고의 예측가에 도전하세요!
                    </dd>
                </div>

                <div class="relative" data-aos="fade-up" data-aos-delay="400">
                    <dt>
                        <div class="absolute flex items-center justify-center h-12 w-12 rounded-md bg-blue-500 text-white">
                            <i class="fas fa-users text-lg"></i>
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

<!-- CTA 섹션 -->
<div class="bg-gray-800" data-aos="fade">
    <div class="max-w-7xl mx-auto px-4 py-12 sm:px-6 lg:px-8 lg:py-16">
        <div class="lg:flex lg:items-center lg:justify-between">
            <h2 class="text-3xl font-extrabold tracking-tight text-white sm:text-4xl">
                <span class="block">준비되셨나요?</span>
                <span class="block text-blue-200">지금 바로 시작하세요.</span>
            </h2>
            <div class="mt-8 flex lg:mt-0 lg:flex-shrink-0">
                <sec:authorize access="isAnonymous()">
                    <a href="/signup" class="inline-flex items-center justify-center px-5 py-3 border border-white text-base font-medium rounded-md text-white hover:bg-white hover:bg-opacity-20 transition-colors">
                        <i class="fas fa-user-plus mr-2"></i> 회원가입
                    </a>
                </sec:authorize>
                <a href="/matches" class="inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 transition-colors shadow-lg">
                    <i class="fas fa-gamepad mr-2"></i> 경기 예측하기
                </a>
            </div>
        </div>
    </div>
</div>

<!-- 푸터 -->
<footer class="bg-white">
    <div class="max-w-7xl mx-auto py-12 px-4 overflow-hidden sm:px-6 lg:px-8">
        <nav class="flex flex-wrap justify-center -mx-5 -my-2">
            <div class="px-5 py-2">
                <a href="#" class="text-base text-gray-500 hover:text-gray-900 flex items-center">
                    <i class="fas fa-info-circle mr-1"></i> 서비스 소개
                </a>
            </div>
            <div class="px-5 py-2">
                <a href="#" class="text-base text-gray-500 hover:text-gray-900 flex items-center">
                    <i class="fas fa-file-alt mr-1"></i> 이용약관
                </a>
            </div>
            <div class="px-5 py-2">
                <a href="#" class="text-base text-gray-500 hover:text-gray-900 flex items-center">
                    <i class="fas fa-shield-alt mr-1"></i> 개인정보처리방침
                </a>
            </div>
            <div class="px-5 py-2">
                <a href="#" class="text-base text-gray-500 hover:text-gray-900 flex items-center">
                    <i class="fas fa-bullhorn mr-1"></i> 공지사항
                </a>
            </div>
            <div class="px-5 py-2">
                <a href="#" class="text-base text-gray-500 hover:text-gray-900 flex items-center">
                    <i class="fas fa-question-circle mr-1"></i> 문의하기
                </a>
            </div>
        </nav>
        <div class="mt-8 flex justify-center space-x-6">
            <a href="#" class="text-gray-400 hover:text-gray-500">
                <i class="fab fa-facebook text-xl"></i>
            </a>
            <a href="#" class="text-gray-400 hover:text-gray-500">
                <i class="fab fa-instagram text-xl"></i>
            </a>
            <a href="#" class="text-gray-400 hover:text-gray-500">
                <i class="fab fa-twitter text-xl"></i>
            </a>
            <a href="#" class="text-gray-400 hover:text-gray-500">
                <i class="fab fa-youtube text-xl"></i>
            </a>
        </div>
        <p class="mt-8 text-center text-base text-gray-400">
            &copy; 2025 LCK 경기 예측. All rights reserved.
        </p>
    </div>
</footer>

<!-- 자바스크립트 -->
<script>
    // AOS 애니메이션 초기화
    document.addEventListener('DOMContentLoaded', function() {
        AOS.init({
            once: true,
            disable: 'mobile'
        });

        // 모바일 메뉴 토글
        const mobileMenuButton = document.getElementById('mobile-menu-button');
        const mobileMenu = document.getElementById('mobile-menu');

        if(mobileMenuButton && mobileMenu) {
            mobileMenuButton.addEventListener('click', function() {
                if(mobileMenu.style.display === 'none') {
                    mobileMenu.style.display = 'block';
                    mobileMenuButton.innerHTML = '<i class="fas fa-times"></i>';
                } else {
                    mobileMenu.style.display = 'none';
                    mobileMenuButton.innerHTML = '<i class="fas fa-bars"></i>';
                }
            });
        }
    });
</script>
</body>
</html>