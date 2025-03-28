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
    <title>LCK 팀 순위</title>
    <link href="${pageContext.request.contextPath}/asset/css/output.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
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

        .lck-card {
            background-color: #101722;
            border: 1px solid #1a2136;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .card-header {
            background: linear-gradient(90deg, #0a1428 0%, #0a2354 100%);
            color: white;
            padding: 16px 20px;
            font-weight: bold;
            font-size: 1.1rem;
            border-bottom: 1px solid #1a2136;
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

        .badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 5px 10px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-blue {
            background-color: rgba(0, 80, 224, 0.15);
            color: #4e9fff;
            border: 1px solid rgba(0, 80, 224, 0.3);
        }

        .badge-green {
            background-color: rgba(4, 193, 102, 0.15);
            color: #04c166;
            border: 1px solid rgba(4, 193, 102, 0.3);
        }

        .badge-red {
            background-color: rgba(228, 38, 38, 0.15);
            color: #ff5c5c;
            border: 1px solid rgba(228, 38, 38, 0.3);
        }

        .badge-gray {
            background-color: rgba(142, 152, 174, 0.15);
            color: #8e98ae;
            border: 1px solid rgba(142, 152, 174, 0.3);
        }

        .team-name {
            font-weight: 600;
            font-size: 1rem;
            display: flex;
            align-items: center;
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

        .playoff-line {
            height: 2px;
            background: linear-gradient(90deg, rgba(78, 159, 255, 0.7) 0%, rgba(78, 159, 255, 0) 100%);
            margin: 0 16px;
            position: relative;
        }

        .playoff-indicator {
            position: absolute;
            top: -10px;
            left: 0;
            background-color: rgba(0, 80, 224, 0.2);
            border: 1px solid rgba(0, 80, 224, 0.5);
            color: #4e9fff;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 0.7rem;
        }

        .info-card {
            padding: 20px;
            color: #b0b8c8;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .info-item {
            background-color: #14192b;
            border-radius: 8px;
            padding: 16px;
            border: 1px solid #1a2136;
        }

        .info-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 12px;
        }

        /* Animation for highlighting top teams */
        @keyframes pulse-gold {
            0% { box-shadow: 0 0 0 0 rgba(255, 215, 0, 0.4); }
            70% { box-shadow: 0 0 0 10px rgba(255, 215, 0, 0); }
            100% { box-shadow: 0 0 0 0 rgba(255, 215, 0, 0); }
        }

        .pulse-gold {
            animation: pulse-gold 2s infinite;
        }
    </style>
</head>
<body class="hexagon-bg">
<!-- Navigation Bar -->
<nav class="bg-gradient-to-r from-gray-900 to-gray-800 shadow-lg">
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
                    <a href="/" class="nav-item">
                        <i class="fas fa-home mr-1"></i> 홈
                    </a>
                    <a href="/matches" class="nav-item">
                        <i class="fas fa-gamepad mr-1"></i> 경기 일정
                    </a>
                    <a href="/rankings" class="nav-item active">
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

<!-- Main Content -->
<div class="lck-container py-8">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-white flex items-center">
            <i class="fas fa-trophy mr-3 text-yellow-400"></i> LCK 2025 팀 순위
        </h1>
        <div class="text-gray-400 text-sm flex items-center">
            <i class="fas fa-sync-alt mr-1"></i> 최종 업데이트:
            <span class="text-white ml-1 font-medium"><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %></span>
        </div>
    </div>

    <!-- Team Rankings Table -->
    <div class="lck-card mb-8">
        <div class="card-header flex items-center">
            <i class="fas fa-list-ol mr-2 text-blue-400"></i>
            <span>팀 순위표</span>
        </div>
        <div class="overflow-x-auto">
            <table class="rank-table">
                <thead>
                <tr>
                    <th class="w-1/12">
                        <div class="flex items-center">
                            <i class="fas fa-hashtag mr-1 text-blue-400"></i> 순위
                        </div>
                    </th>
                    <th class="w-3/12">
                        <div class="flex items-center">
                            <i class="fas fa-users mr-1 text-blue-400"></i> 팀명
                        </div>
                    </th>
                    <th class="w-2/12 text-center">
                        <div class="flex items-center justify-center">
                            <i class="fas fa-gamepad mr-1 text-blue-400"></i> 승/패
                        </div>
                    </th>
                    <th class="w-2/12 text-center">
                        <div class="flex items-center justify-center">
                            <i class="fas fa-percentage mr-1 text-blue-400"></i> 승률
                        </div>
                    </th>
                    <th class="w-4/12 text-center hidden md:table-cell">
                        <div class="flex items-center justify-center">
                            <i class="fas fa-chart-bar mr-1 text-blue-400"></i> 그래프
                        </div>
                    </th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="stats" items="${teamStats}" varStatus="status">
                    <tr class="team-row ${status.index == 0 ? 'pulse-gold' : ''}">
                        <td>
                            <div class="flex items-center justify-center">
                                <div class="rank-number ${status.index == 0 ? 'rank-1' : status.index == 1 ? 'rank-2' : status.index == 2 ? 'rank-3' : 'rank-other'}">
                                        ${status.index + 1}
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="team-name">
                                <c:choose>
                                    <c:when test="${status.index < 3}">
                                        <span class="text-white">${stats.team().teamName()}</span>
                                        <c:if test="${status.index == 0}">
                                                    <span class="ml-2 text-yellow-400">
                                                        <i class="fas fa-crown"></i>
                                                    </span>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <span>${stats.team().teamName()}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </td>
                        <td class="text-center">
                            <div class="flex items-center justify-center space-x-2">
                                        <span class="stat-badge win-badge">
                                            ${stats.wins()}승
                                        </span>
                                <span class="stat-badge loss-badge">
                                            ${stats.losses()}패
                                        </span>
                            </div>
                        </td>
                        <td class="text-center">
                            <div class="win-rate-text
                                        ${stats.winRate() >= 80 ? 'progress-80-100' :
                                          stats.winRate() >= 60 ? 'progress-60-80' :
                                          stats.winRate() >= 40 ? 'progress-40-60' : 'progress-0-40'}">
                                <fmt:formatNumber value="${stats.winRate()}" pattern="#0.0" />%
                            </div>
                        </td>
                        <td class="hidden md:table-cell">
                            <div class="win-rate-bar">
                                <div class="win-rate-progress" style="width: ${stats.winRate()}%"></div>
                            </div>
                        </td>
                    </tr>

                    <!-- Playoff cutoff line after 6th team -->
                    <c:if test="${status.index == 5}">
                        <tr>
                            <td colspan="5" class="p-0">
                                <div class="playoff-line">
                                    <div class="playoff-indicator">
                                        플레이오프 진출선
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Playoff Information Card -->
    <div class="lck-card mb-8">
        <div class="card-header flex items-center">
            <i class="fas fa-info-circle mr-2 text-green-400"></i>
            <span>플레이오프 진출 안내</span>
        </div>
        <div class="info-card">
            <div class="flex items-center space-x-2 mb-4">
                <span class="inline-block w-4 h-4 bg-blue-900 rounded"></span>
                <span class="text-sm">플레이오프 진출권 (상위 6개팀)</span>
            </div>
            <div class="relative w-full h-6 bg-gray-800 rounded-lg overflow-hidden">
                <div class="h-full bg-gradient-to-r from-blue-800 to-blue-600" style="width: 60%"></div>
                <div class="absolute inset-0 flex items-center px-4 text-xs font-medium text-white">
                    상위 6개 팀 진출
                </div>
            </div>
            <p class="mt-4 text-sm text-gray-400">
                현재 정규 시즌이 진행 중입니다. 상위 6개 팀이 플레이오프에 진출하게 됩니다.
                플레이오프 대진표는 정규 시즌 종료 후 확정됩니다.
            </p>
        </div>
    </div>

    <!-- LCK Ranking System Information -->
    <div class="lck-card">
        <div class="card-header flex items-center">
            <i class="fas fa-question-circle mr-2 text-purple-400"></i>
            <span>LCK 순위 결정 방식</span>
        </div>
        <div class="info-card">
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-icon bg-blue-900 text-blue-400">
                        <i class="fas fa-sync"></i>
                    </div>
                    <h3 class="text-lg font-medium text-white mb-2">더블 라운드 로빈</h3>
                    <p class="text-gray-400 text-sm">정규 시즌은 더블 라운드 로빈 방식으로 진행됩니다. 각 팀은 다른 모든 팀과 2번씩, 총 18경기를 치릅니다.</p>
                </div>

                <div class="info-item">
                    <div class="info-icon bg-green-900 text-green-400">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3 class="text-lg font-medium text-white mb-2">플레이오프 진출</h3>
                    <p class="text-gray-400 text-sm">상위 6개 팀이 플레이오프에 진출합니다. 1-2위 팀은 자동으로 플레이오프 2라운드에 진출합니다.</p>
                </div>

                <div class="info-item">
                    <div class="info-icon bg-yellow-900 text-yellow-400">
                        <i class="fas fa-balance-scale"></i>
                    </div>
                    <h3 class="text-lg font-medium text-white mb-2">동률 규정</h3>
                    <p class="text-gray-400 text-sm">동일한 승률일 경우, 상대 전적을 먼저 고려하고, 그 후에 경기 시간을 고려합니다.</p>
                </div>

                <div class="info-item">
                    <div class="info-icon bg-red-900 text-red-400">
                        <i class="fas fa-trophy"></i>
                    </div>
                    <h3 class="text-lg font-medium text-white mb-2">챔피언십 포인트</h3>
                    <p class="text-gray-400 text-sm">스프링과 서머 시즌의 성적에 따라 월드 챔피언십 출전 자격이 결정됩니다.</p>
                </div>
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
</body>
</html>