<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

        @media (max-width: 768px) {
            .hero-section {
                min-height: auto !important;
                padding-bottom: 320px !important;
            }

            .hero-content {
                max-width: 100% !important;
                text-align: center;
            }

            .hero-section > div:last-child {
                top: auto !important;
                right: 50% !important;
                bottom: 40px !important;
                transform: translateX(50%) !important;
            }
        }
        /* 새로운 경기 카드 컨텐츠 레이아웃 */
        .match-content-new {
            padding: 20px;
            position: relative;
            height: 180px; /* 고정 높이 */
        }

        /* 팀 컨테이너 */
        .team-container {
            position: absolute;
            width: 40%;
            text-align: center;
        }

        /* 왼쪽 팀 */
        .team-left {
            top: 20px;
            left: 5%;
        }

        /* 오른쪽 팀 */
        .team-right {
            top: 20px;
            right: 5%;
        }

        /* 팀 로고 */
        .team-logo {
            width: 60px;
            height: 60px;
            background-color: #1a2136;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2rem;
            margin: 0 auto 10px;
        }

        /* 팀 이름 */
        .team-name {
            font-size: 0.9rem;
            font-weight: 500;
            max-width: 100%;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-align: center;
            height: 40px; /* 고정 높이 */
            margin: 0 auto;
        }

        /* VS 컨테이너 - 항상 중앙 고정 */
        .vs-container {
            position: absolute;
            top: 40px;
            left: 50%;
            transform: translateX(-50%);
            text-align: center;
        }

        /* VS 배지 */
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
            margin: 0 auto 5px;
        }

        /* VS 텍스트 (정규시즌) */
        .vs-text {
            font-size: 0.75rem;
            color: #8e98ae;
        }

        /* 예측 버튼 컨테이너 */
        .predict-button-container {
            position: absolute;
            bottom: 20px;
            left: 20px;
            right: 20px;
        }
        .rank-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        .rank-table th {
            background-color: #13192a;
            color: #9aa4b8;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-size: 0.75rem;
            padding: 12px 16px;
            text-align: left;
            border-bottom: 1px solid #1a2136;
        }

        .rank-table tr:nth-child(odd) {
            background-color: #0f1520;
        }

        .rank-table tr:nth-child(even) {
            background-color: #121927;
        }

        .rank-table tr:hover {
            background-color: #151b2e;
        }

        .rank-table td {
            padding: 16px;
            border-bottom: 1px solid #1a2136;
            vertical-align: middle;
        }

        .team-row {
            transition: transform 0.2s ease;
        }

        .team-row:hover {
            transform: translateX(5px);
        }

        .rank-number {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            font-weight: bold;
            margin-right: 12px;
        }

        .rank-1 {
            background: linear-gradient(135deg, #ffd700 0%, #e6b800 100%);
            color: #000;
            box-shadow: 0 0 10px rgba(255, 215, 0, 0.5);
        }

        .rank-2 {
            background: linear-gradient(135deg, #c0c0c0 0%, #a6a6a6 100%);
            color: #000;
        }

        .rank-3 {
            background: linear-gradient(135deg, #cd7f32 0%, #b36a1d 100%);
            color: #000;
        }

        .rank-other {
            background-color: #1a2136;
            color: #8e98ae;
        }

        .win-rate-bar {
            width: 100%;
            height: 10px;
            background-color: #1a2136;
            border-radius: 5px;
            overflow: hidden;
        }

        .win-rate-progress {
            height: 100%;
            border-radius: 5px;
            background: linear-gradient(90deg, #0050e0 0%, #0a6cff 100%);
        }

        .stat-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 500;
            margin-right: 4px;
        }

        .win-badge {
            background-color: rgba(4, 193, 102, 0.15);
            color: #04c166;
        }

        .loss-badge {
            background-color: rgba(228, 38, 38, 0.15);
            color: #ff5c5c;
        }

        .win-rate-text {
            font-weight: 600;
        }

        .progress-80-100 {
            color: #04c166;
        }

        .progress-60-80 {
            color: #4e9fff;
        }

        .progress-40-60 {
            color: #f9b529;
        }

        .progress-0-40 {
            color: #ff5c5c;
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
                                <sec:authentication property="principal.displayName" />
                            </span>
                        <span class="user-points">
                            <i class="fas fa-coins mr-1"></i>
                            <sec:authentication property="principal.point" /> P
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
    <div class="hero-section" data-aos="fade-up" style="position: relative; min-height: 500px;">
        <div class="hero-overlay"></div>

        <!-- 텍스트 영역 - 왼쪽에 배치, 너비 제한 -->
        <div class="hero-content p-8" style="max-width: 60%; position: relative; z-index: 10;">
            <h1 class="text-4xl sm:text-5xl lg:text-6xl font-bold text-white mb-6">
                LCK 경기 결과를<br>
                예측하고<br>
                <span class="text-blue-400">포인트</span>를 획득하세요!
            </h1>
            <p class="text-xl text-gray-300 mb-8 max-w-2xl">
                좋아하는 팀의 승리를 응원하고 정확한 예측으로 포인트를 쌓아보세요. <br>
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

        <!-- 이미지 영역 - 오른쪽에 절대 위치 지정 -->
        <div style="position: absolute; top: 50%; right: 40px; transform: translateY(-50%); z-index: 10;">
            <img src="/images/logo.png" alt="LCK" style="width: 500px; height: auto; object-fit: contain;">
        </div>
    </div>
</div>

<!-- 다가오는 경기 섹션 -->
<div class="lck-container py-12">
    <div class="text-center mb-10" data-aos="fade-up">
        <c:choose>
            <c:when test="${isToday}">
                <h2 class="section-title text-white">오늘의 LCK 매치업</h2>
                <p class="text-gray-400 max-w-2xl mx-auto">
                    오늘 펼쳐질 경기를 확인하고 승자를 예측해보세요.
                </p>
            </c:when>
            <c:when test="${hasMatches}">
                <h2 class="section-title text-white">다음 예정된 LCK 매치업</h2>
                <p class="text-gray-400 max-w-2xl mx-auto">
                        ${nextMatchDate}에 펼쳐질 경기를 확인하고 승자를 예측해보세요.
                </p>
            </c:when>
            <c:otherwise>
                <h2 class="section-title text-white">예정된 경기 정보</h2>
                <p class="text-gray-400 max-w-2xl mx-auto">
                    현재 예정된 경기가 없습니다. 경기 일정 페이지에서 업데이트를 확인해보세요.
                </p>
            </c:otherwise>
        </c:choose>
    </div>

    <c:choose>
        <c:when test="${hasMatches}">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6" data-aos="fade-up" data-aos-delay="200">
                <!-- 동적으로 경기 카드 생성 -->
                <c:forEach var="match" items="${todayMatches}">
                    <div class="match-card">
                        <div class="match-header">
                            <span class="flex items-center">
                                <i class="fas fa-calendar-day mr-2"></i>
                                <c:choose>
                                    <c:when test="${isToday}">오늘</c:when>
                                    <c:otherwise>
                                        <c:set var="matchDateStr" value="${match.match().match_date()}" />
                                        <c:out value="${matchDateStr}" />
                                    </c:otherwise>
                                </c:choose>
                            </span>
                            <span class="text-xs px-2 py-1 bg-blue-900 rounded-full">BO3</span>
                        </div>

                        <!-- 완전히 새로운 경기 컨텐츠 레이아웃 -->
                        <div class="match-content-new">
                            <!-- 팀1 -->
                            <div class="team-container team-left">
                                <div class="team-logo">
                                    <c:set var="team1Name" value="${match.team1().teamName()}" />
                                    <c:if test="${fn:length(team1Name) > 3}">
                                        <c:out value="${fn:substring(team1Name, 0, 2)}" />
                                    </c:if>
                                    <c:if test="${fn:length(team1Name) <= 3}">
                                        <c:out value="${team1Name}" />
                                    </c:if>
                                </div>
                                <div class="team-name">
                                    <c:out value="${match.team1().teamName()}" />
                                </div>
                            </div>

                            <!-- VS 중앙에 고정 -->
                            <div class="vs-container">
                                <div class="vs-badge">VS</div>
                                <div class="vs-text">정규시즌</div>
                            </div>

                            <!-- 팀2 -->
                            <div class="team-container team-right">
                                <div class="team-logo">
                                    <c:set var="team2Name" value="${match.team2().teamName()}" />
                                    <c:if test="${fn:length(team2Name) > 3}">
                                        <c:out value="${fn:substring(team2Name, 0, 2)}" />
                                    </c:if>
                                    <c:if test="${fn:length(team2Name) <= 3}">
                                        <c:out value="${team2Name}" />
                                    </c:if>
                                </div>
                                <div class="team-name">
                                    <c:out value="${match.team2().teamName()}" />
                                </div>
                            </div>

                            <!-- 예측 버튼 -->
                            <div class="predict-button-container">
                                <a href="/matches" class="btn btn-blue w-full">
                                    <i class="fas fa-chart-pie mr-1"></i> 예측하기
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <!-- 경기가 없을 때 표시할 내용 -->
            <div class="lck-card p-8 text-center" data-aos="fade-up" data-aos-delay="200">
                <i class="fas fa-calendar-times text-gray-400 text-6xl mb-4"></i>
                <h3 class="text-xl font-semibold text-white mb-2">현재 진행 중인 경기가 없습니다</h3>
                <p class="text-gray-400 mb-4">다음 경기 일정을 기다려주세요. 곧 새로운 경기가 업데이트될 예정입니다.</p>
                <a href="/matches" class="btn btn-blue inline-block">
                    <i class="fas fa-list mr-1"></i> 모든 경기 일정 보기
                </a>
            </div>
        </c:otherwise>
    </c:choose>

    <div class="text-center mt-8" data-aos="fade-up" data-aos-delay="300">
        <a href="/matches" class="inline-flex items-center text-blue-400 hover:text-blue-300">
            전체 일정 보기
            <i class="fas fa-arrow-right ml-2"></i>
        </a>
    </div>
</div>

<!-- LCK 팀 순위 섹션 -->
<div class="lck-container py-12">
    <div class="text-center mb-10" data-aos="fade-up">
        <h2 class="section-title text-white">LCK 팀 순위</h2>
        <p class="text-gray-400 max-w-2xl mx-auto">
            최신 업데이트된 LCK 팀들의 순위를 확인하세요.
        </p>
    </div>

    <!-- 순위표 카드 -->
    <div class="lck-card" data-aos="fade-up" data-aos-delay="200">
        <div class="card-header flex items-center">
            <i class="fas fa-trophy mr-2 text-yellow-400"></i>
            <span>LCK 팀 순위</span>
        </div>

        <div class="overflow-x-auto">
            <table class="rank-table w-full">
                <thead>
                <tr>
                    <th class="p-4 text-left">순위</th>
                    <th class="p-4 text-left">팀</th>
                    <th class="p-4 text-center">승/패</th>
                    <th class="p-4 text-center">승률</th>
                    <th class="p-4 text-center hidden md:table-cell">그래프</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="stats" items="${teams}" varStatus="status">
                    <tr class="team-row ${status.index == 0 ? 'pulse-gold' : ''}">
                        <td class="p-4">
                            <div class="flex items-center justify-center">
                                <div class="rank-number ${status.index == 0 ? 'rank-1' : status.index == 1 ? 'rank-2' : status.index == 2 ? 'rank-3' : 'rank-other'}">
                                        ${status.index + 1}
                                </div>
                            </div>
                        </td>
                        <td class="p-4">
                            <div class="team-name">
                                <c:choose>
                                    <c:when test="${status.index < 3}">
                                        <span class="text-white">${stats.teamName()}</span>
                                        <c:if test="${status.index == 0}">
                                                <span class="ml-2 text-yellow-400">
                                                    <i class="fas fa-crown"></i>
                                                </span>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <span>${stats.teamName()}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </td>
                        <td class="p-4 text-center">
                            <div class="flex items-center justify-center space-x-2">
                                    <span class="stat-badge win-badge">
                                        ${stats.wins()}승
                                    </span>
                                <span class="stat-badge loss-badge">
                                        ${stats.loses()}패
                                    </span>
                            </div>
                        </td>
                        <c:set var="winRate" value="${stats.wins() / (stats.wins()+stats.loses()) * 100}" />
                        <td class="p-4 text-center">
                            <div class="win-rate-text
                                        ${winRate >= 80 ? 'progress-80-100' :
                                          winRate >= 60 ? 'progress-60-80' :
                                          winRate >= 40 ? 'progress-40-60' : 'progress-0-40'}">
                                <fmt:formatNumber value="${winRate}" pattern="#0.0" />%
                            </div>
                        </td>
                        <td class="p-4 hidden md:table-cell">
                            <div class="win-rate-bar">
                                <div class="win-rate-progress" style="width: ${winRate}%"></div>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>


<!-- 주요 기능 소개 -->
<div class="lck-container py-12">
    <div class="text-center mb-10" data-aos="fade-up">
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