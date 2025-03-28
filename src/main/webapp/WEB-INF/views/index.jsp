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
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <!-- Add AOS for scroll animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #0a0e13;
            color: #e6e6e6;
        }

        .hexagon-bg {
            background-color: #0a0e13;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='28' height='49' viewBox='0 0 28 49'%3E%3Cg fill-rule='evenodd'%3E%3Cg id='hexagons' fill='%231a2136' fill-opacity='0.15' fill-rule='nonzero'%3E%3Cpath d='M13.99 9.25l13 7.5v15l-13 7.5L1 31.75v-15l12.99-7.5zM3 17.9v12.7l10.99 6.34 11-6.35V17.9l-11-6.34L3 17.9zM0 15l12.98-7.5V0h-2v6.35L0 12.69v2.3zm0 18.5L12.98 41v8h-2v-6.85L0 35.81v-2.3zM15 0v7.5L27.99 15H28v-2.31h-.01L17 6.35V0h-2zm0 49v-8l12.99-7.5H28v2.31h-.01L17 42.15V49h-2z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
        }

        .lck-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .nav-item {
            color: #b0b8c8;
            padding: 8px 16px;
            transition: color 0.2s;
            border-bottom: 2px solid transparent;
        }

        .nav-item:hover {
            color: white;
        }

        .nav-item.active {
            color: white;
            border-bottom: 2px solid #0a6cff;
        }

        .user-profile {
            background-color: #1a2136;
            padding: 6px 12px;
            border-radius: 20px;
            display: flex;
            align-items: center;
        }

        .user-points {
            background: linear-gradient(90deg, #ffd700 0%, #f9b529 100%);
            color: #000;
            padding: 4px 8px;
            border-radius: 12px;
            margin-left: 8px;
            font-weight: 600;
            font-size: 0.75rem;
        }

        .hero-section {
            position: relative;
            padding: 100px 0;
            background: linear-gradient(135deg, #0a1428 0%, #0a2354 100%);
            background-size: cover;
            background-position: center;
            border-radius: 8px;
            overflow: hidden;
        }

        .hero-content {
            position: relative;
            z-index: 10;
            max-width: 800px;
        }

        .hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(10, 14, 19, 0.8) 0%, rgba(10, 14, 19, 0.4) 100%);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-blue {
            background: linear-gradient(135deg, #0050e0 0%, #003db5 100%);
            color: white;
            box-shadow: 0 2px 4px rgba(0, 65, 185, 0.3);
        }

        .btn-blue:hover {
            background: linear-gradient(135deg, #0046c7 0%, #00349b 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 65, 185, 0.5);
        }

        .btn-outline {
            background: transparent;
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
        }

        .btn-outline:hover {
            background-color: rgba(255, 255, 255, 0.1);
            transform: translateY(-2px);
        }

        .section-title {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 1rem;
            position: relative;
            display: inline-block;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 60px;
            height: 3px;
            background: linear-gradient(90deg, #0050e0 0%, #0a6cff 100%);
            border-radius: 3px;
        }

        .match-card {
            background-color: #101722;
            border: 1px solid #1a2136;
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .match-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
        }

        .match-header {
            background: linear-gradient(90deg, #0a1428 0%, #0a2354 100%);
            color: white;
            padding: 12px 16px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .match-content {
            padding: 20px;
        }

        .team-logo {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background-color: #1a2136;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2rem;
            margin-bottom: 10px;
        }

        .vs-badge {
            width: 40px;
            height: 40px;
            background-color: #1a2136;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            color: #8e98ae;
        }

        .feature-card {
            background-color: #101722;
            border: 1px solid #1a2136;
            border-radius: 8px;
            padding: 24px;
            transition: transform 0.3s;
        }

        .feature-card:hover {
            transform: translateY(-5px);
        }

        .feature-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #0a1428 0%, #0a2354 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
            font-size: 1.5rem;
            color: #4e9fff;
        }

        .cta-section {
            background: linear-gradient(135deg, #0a1428 0%, #0a2354 100%);
            border-radius: 8px;
            padding: 40px;
        }
    </style>
</head>
<body class="hexagon-bg">
<!-- Navigation Bar -->
<nav class="bg-gradient-to-r from-gray-900 to-gray-800 shadow-lg sticky top-0 z-10">
    <div class="lck-container mx-auto">
        <div class="flex justify-between items-center h-16">
            <div class="flex items-center">
                <a href="/" class="text-blue-400 font-bold text-xl flex items-center">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                    </svg>
                    LCK 예측
                </a>
                <div class="md:flex ml-10 space-x-2">
                    <a href="/" class="nav-item active">
                        <i class="fas fa-home mr-1"></i> 홈
                    </a>
                    <a href="/matches" class="nav-item">
                        <i class="fas fa-gamepad mr-1"></i> 경기 일정
                    </a>
                    <a href="/rankings" class="nav-item">
                        <i class="fas fa-trophy mr-1"></i> 순위표
                    </a>
                    <a href="/predictions" class="nav-item">
                        <i class="fas fa-chart-line mr-1"></i> 내 예측
                    </a>
                </div>
            </div>

            <div class="flex items-center">
                <sec:authorize access="isAuthenticated()">
                    <div class="user-profile">
                        <i class="fas fa-user text-blue-400 mr-2"></i>
                        <span class="text-sm text-white mr-2">
                                <sec:authentication property="principal.username" />
                            </span>
                        <span class="user-points">
                                <i class="fas fa-coins mr-1"></i> 0 P
                            </span>
                    </div>
                    <a href="/logout" class="ml-4 text-sm text-gray-300 hover:text-white flex items-center">
                        <i class="fas fa-sign-out-alt mr-1"></i> 로그아웃
                    </a>
                </sec:authorize>
                <sec:authorize access="isAnonymous()">
                    <a href="/login" class="text-gray-300 hover:text-white px-3 py-2 rounded-md text-sm font-medium flex items-center">
                        <i class="fas fa-sign-in-alt mr-1"></i> 로그인
                    </a>
                    <a href="/signup" class="ml-3 bg-blue-600 text-white hover:bg-blue-700 px-3 py-2 rounded-md text-sm font-medium flex items-center">
                        <i class="fas fa-user-plus mr-1"></i> 회원가입
                    </a>
                </sec:authorize>
            </div>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<div class="lck-container py-8">
    <div class="hero-section" data-aos="fade-up">
        <div class="hero-overlay"></div>
        <div class="hero-content p-8">
            <h1 class="text-4xl sm:text-5xl lg:text-6xl font-bold text-white mb-6">
                LCK 경기 결과를<br>
                예측하고<br>
                <span class="text-blue-400">포인트</span>를 획득하세요!
            </h1>
            <p class="text-xl text-gray-300 mb-8 max-w-2xl">
                좋아하는 팀의 승리를 응원하고 정확한 예측으로 포인트를 쌓아보세요.
                매주 업데이트되는 경기 일정과 실시간 순위표를 확인할 수 있습니다.
            </p>
            <div class="flex flex-wrap gap-4">
                <sec:authorize access="isAnonymous()">
                    <a href="/signup" class="btn btn-outline">
                        <i class="fas fa-user-plus mr-2"></i> 회원가입
                    </a>
                </sec:authorize>
                <a href="/matches" class="btn btn-blue">
                    <i class="fas fa-gamepad mr-2"></i> 경기 예측하기
                </a>
            </div>
        </div>
    </div>
</div>

<!-- 다가오는 경기 섹션 -->
<div class="lck-container py-12">
    <div class="text-center mb-10" data-aos="fade-up">
        <span class="text-blue-400 font-semibold uppercase tracking-wider">다가오는 경기</span>
        <h2 class="section-title text-white">오늘의 LCK 매치업</h2>
        <p class="text-gray-400 max-w-2xl mx-auto">
            오늘 펼쳐질 경기를 확인하고 승자를 예측해보세요.
        </p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6" data-aos="fade-up" data-aos-delay="200">
        <!-- 경기 카드 1 -->
        <div class="match-card">
            <div class="match-header">
                    <span class="flex items-center">
                        <i class="fas fa-calendar-day mr-2"></i> 오늘 18:00
                    </span>
                <span class="text-xs px-2 py-1 bg-blue-900 rounded-full">BO3</span>
            </div>
            <div class="match-content">
                <div class="flex items-center justify-between">
                    <div class="flex flex-col items-center w-5/12">
                        <div class="team-logo">T1</div>
                        <span class="font-medium">T1</span>
                    </div>
                    <div class="flex flex-col items-center w-2/12">
                        <span class="vs-badge">VS</span>
                        <span class="text-xs text-gray-500 mt-1">정규시즌</span>
                    </div>
                    <div class="flex flex-col items-center w-5/12">
                        <div class="team-logo">DK</div>
                        <span class="font-medium">DK</span>
                    </div>
                </div>
                <a href="/matches" class="btn btn-blue w-full mt-4">
                    <i class="fas fa-chart-pie mr-1"></i> 예측하기
                </a>
            </div>
        </div>

        <!-- 경기 카드 2 -->
        <div class="match-card">
            <div class="match-header">
                    <span class="flex items-center">
                        <i class="fas fa-calendar-day mr-2"></i> 오늘 20:00
                    </span>
                <span class="text-xs px-2 py-1 bg-blue-900 rounded-full">BO3</span>
            </div>
            <div class="match-content">
                <div class="flex items-center justify-between">
                    <div class="flex flex-col items-center w-5/12">
                        <div class="team-logo">GEN</div>
                        <span class="font-medium">젠지</span>
                    </div>
                    <div class="flex flex-col items-center w-2/12">
                        <span class="vs-badge">VS</span>
                        <span class="text-xs text-gray-500 mt-1">정규시즌</span>
                    </div>
                    <div class="flex flex-col items-center w-5/12">
                        <div class="team-logo">KT</div>
                        <span class="font-medium">KT</span>
                    </div>
                </div>
                <a href="/matches" class="btn btn-blue w-full mt-4">
                    <i class="fas fa-chart-pie mr-1"></i> 예측하기
                </a>
            </div>
        </div>

        <!-- 경기 카드 3 -->
        <div class="match-card">
            <div class="match-header">
                    <span class="flex items-center">
                        <i class="fas fa-calendar-day mr-2"></i> 내일 17:00
                    </span>
                <span class="text-xs px-2 py-1 bg-blue-900 rounded-full">BO3</span>
            </div>
            <div class="match-content">
                <div class="flex items-center justify-between">
                    <div class="flex flex-col items-center w-5/12">
                        <div class="team-logo">DRX</div>
                        <span class="font-medium">DRX</span>
                    </div>
                    <div class="flex flex-col items-center w-2/12">
                        <span class="vs-badge">VS</span>
                        <span class="text-xs text-gray-500 mt-1">정규시즌</span>
                    </div>
                    <div class="flex flex-col items-center w-5/12">
                        <div class="team-logo">NS</div>
                        <span class="font-medium">농심</span>
                    </div>
                </div>
                <a href="/matches" class="btn btn-blue w-full mt-4">
                    <i class="fas fa-chart-pie mr-1"></i> 예측하기
                </a>
            </div>
        </div>
    </div>

    <div class="text-center mt-8" data-aos="fade-up" data-aos-delay="300">
        <a href="/matches" class="inline-flex items-center text-blue-400 hover:text-blue-300">
            전체 일정 보기
            <i class="fas fa-arrow-right ml-2"></i>
        </a>
    </div>
</div>

<!-- 주요 기능 소개 -->
<div class="lck-container py-12">
    <div class="text-center mb-10" data-aos="fade-up">
        <span class="text-blue-400 font-semibold uppercase tracking-wider">LCK 예측</span>
        <h2 class="section-title text-white">전문가처럼 경기를 분석하고 예측하세요</h2>
        <p class="text-gray-400 max-w-2xl mx-auto">
            LCK 경기를 더 재미있게 즐기는 방법, 경기 결과를 예측하고 포인트를 획득하세요.
        </p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6" data-aos="fade-up" data-aos-delay="200">
        <div class="feature-card">
            <div class="feature-icon">
                <i class="fas fa-calendar-alt"></i>
            </div>
            <h3 class="text-lg font-medium text-white mb-2">실시간 경기 일정</h3>
            <p class="text-gray-400 text-sm">
                최신 LCK 경기 일정을 확인하고 경기 결과를 예측할 수 있습니다. 경기 시작 전까지 언제든지 예측을 변경할 수 있습니다.
            </p>
        </div>

        <div class="feature-card">
            <div class="feature-icon">
                <i class="fas fa-coins"></i>
            </div>
            <h3 class="text-lg font-medium text-white mb-2">포인트 시스템</h3>
            <p class="text-gray-400 text-sm">
                정확한 예측으로 포인트를 획득하고 랭킹에 도전하세요. 획득한 포인트는 다양한 혜택으로 교환할 수 있습니다.
            </p>
        </div>

        <div class="feature-card">
            <div class="feature-icon">
                <i class="fas fa-trophy"></i>
            </div>
            <h3 class="text-lg font-medium text-white mb-2">사용자 순위</h3>
            <p class="text-gray-400 text-sm">
                예측 정확도와 획득한 포인트를 기준으로 사용자 순위가 결정됩니다. 최고의 예측가에 도전하세요!
            </p>
        </div>

        <div class="feature-card">
            <div class="feature-icon">
                <i class="fas fa-users"></i>
            </div>
            <h3 class="text-lg font-medium text-white mb-2">커뮤니티</h3>
            <p class="text-gray-400 text-sm">
                다른 사용자들과 경기에 대한 의견을 공유하고 함께 LCK를 즐겨보세요. 경기에 대한 분석과 정보를 얻을 수 있습니다.
            </p>
        </div>
    </div>
</div>

<!-- CTA 섹션 -->
<div class="lck-container py-12">
    <div class="cta-section" data-aos="fade-up">
        <div class="lg:flex lg:items-center lg:justify-between">
            <div>
                <h2 class="text-3xl font-bold text-white mb-2">
                    준비되셨나요?
                </h2>
                <p class="text-xl text-blue-300">지금 바로 시작하세요.</p>
            </div>
            <div class="mt-8 lg:mt-0 flex space-x-4">
                <sec:authorize access="isAnonymous()">
                    <a href="/signup" class="btn btn-outline">
                        <i class="fas fa-user-plus mr-2"></i> 회원가입
                    </a>
                </sec:authorize>
                <a href="/matches" class="btn btn-blue">
                    <i class="fas fa-gamepad mr-2"></i> 경기 예측하기
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="bg-gray-900 mt-12 border-t border-gray-800">
    <div class="lck-container py-12">
        <div class="flex flex-wrap justify-center -mx-5 -my-2">
            <div class="px-5 py-2">
                <a href="#" class="text-gray-400 hover:text-white flex items-center">
                    <i class="fas fa-info-circle mr-1"></i> 서비스 소개
                </a>
            </div>
            <div class="px-5 py-2">
                <a href="#" class="text-gray-400 hover:text-white flex items-center">
                    <i class="fas fa-file-alt mr-1"></i> 이용약관
                </a>
            </div>
            <div class="px-5 py-2">
                <a href="#" class="text-gray-400 hover:text-white flex items-center">
                    <i class="fas fa-shield-alt mr-1"></i> 개인정보처리방침
                </a>
            </div>
            <div class="px-5 py-2">
                <a href="#" class="text-gray-400 hover:text-white flex items-center">
                    <i class="fas fa-bullhorn mr-1"></i> 공지사항
                </a>
            </div>
            <div class="px-5 py-2">
                <a href="#" class="text-gray-400 hover:text-white flex items-center">
                    <i class="fas fa-question-circle mr-1"></i> 문의하기
                </a>
            </div>
        </div>
        <div class="mt-8 flex justify-center space-x-6">
            <a href="#" class="text-gray-500 hover:text-gray-400">
                <i class="fab fa-facebook text-xl"></i>
            </a>
            <a href="#" class="text-gray-500 hover:text-gray-400">
                <i class="fab fa-instagram text-xl"></i>
            </a>
            <a href="#" class="text-gray-500 hover:text-gray-400">
                <i class="fab fa-twitter text-xl"></i>
            </a>
            <a href="#" class="text-gray-500 hover:text-gray-400">
                <i class="fab fa-youtube text-xl"></i>
            </a>
        </div>
        <p class="mt-8 text-center text-base text-gray-600">
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
    });
</script>
</body>
</html>