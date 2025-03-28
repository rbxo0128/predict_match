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
    <title>LCK 경기 일정 및 예측</title>
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

        .match-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        .match-table th {
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

        .match-table tr:nth-child(even) {
            background-color: #0f1520;
        }

        .match-table tr:hover {
            background-color: #151b2e;
        }

        .match-table td {
            padding: 16px;
            border-bottom: 1px solid #1a2136;
            vertical-align: middle;
        }

        .team-tag {
            display: inline-block;
            padding: 6px 12px;
            background-color: #1a2332;
            border-radius: 4px;
            font-weight: 500;
            color: #e6e6e6;
            min-width: 70px;
            text-align: center;
        }

        .match-score {
            background-color: #112036;
            font-weight: bold;
            padding: 5px 12px;
            border-radius: 4px;
            display: inline-block;
            min-width: 60px;
            text-align: center;
        }

        .vs-tag {
            color: #768197;
            font-weight: bold;
        }

        .btn-predict {
            padding: 8px 14px;
            font-size: 0.875rem;
            border-radius: 4px;
            font-weight: 500;
            transition: all 0.2s ease;
            border: none;
            cursor: pointer;
            min-width: 120px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-blue {
            background: linear-gradient(135deg, #0050e0 0%, #003db5 100%);
            color: white;
            box-shadow: 0 2px 4px rgba(0, 65, 185, 0.3);
        }

        .btn-blue:hover {
            background: linear-gradient(135deg, #0046c7 0%, #00349b 100%);
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0, 65, 185, 0.5);
        }

        .btn-gray {
            background: linear-gradient(135deg, #2a3142 0%, #212736 100%);
            color: #b0b8c8;
        }

        .btn-gray:hover {
            background: linear-gradient(135deg, #323b52 0%, #293040 100%);
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
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

        .rules-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }

        .rule-card {
            background-color: #14192b;
            border-radius: 8px;
            padding: 16px;
            border: 1px solid #1a2136;
        }

        .rule-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 12px;
        }

        .result-badge {
            min-width: 100px;
            text-align: center;
        }

        .prediction-status {
            min-width: 100px;
            text-align: center;
        }

        /* Animation */
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(0, 106, 255, 0.4); }
            70% { box-shadow: 0 0 0 10px rgba(0, 106, 255, 0); }
            100% { box-shadow: 0 0 0 0 rgba(0, 106, 255, 0); }
        }

        .animate-pulse {
            animation: pulse 2s infinite;
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
                    <a href="/matches" class="nav-item active">
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

<!-- Main Content -->
<div class="lck-container py-8">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-white flex items-center">
            <i class="fas fa-gamepad mr-3 text-blue-400"></i> LCK 경기 일정
        </h1>
        <div class="text-gray-400 text-sm">
            <i class="fas fa-info-circle mr-1"></i> 경기 시작 전까지 예측을 변경할 수 있습니다
        </div>
    </div>

    <!-- Alert Messages -->
    <c:if test="${not empty error}">
        <div class="bg-gradient-to-r from-red-900 to-red-800 border border-red-700 text-white p-4 mb-6 rounded-md shadow-md flex items-center" role="alert">
            <i class="fas fa-exclamation-circle text-xl mr-3"></i>
            <span>${error}</span>
        </div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="bg-gradient-to-r from-green-900 to-green-800 border border-green-700 text-white p-4 mb-6 rounded-md shadow-md flex items-center" role="alert">
            <i class="fas fa-check-circle text-xl mr-3"></i>
            <span>${success}</span>
        </div>
    </c:if>

    <!-- Match List -->
    <div class="lck-card mb-8">
        <div class="card-header flex items-center">
            <i class="fas fa-calendar-alt mr-2 text-blue-400"></i>
            <span>경기 일정 및 예측</span>
        </div>
        <div class="overflow-x-auto">
            <table class="match-table">
                <thead>
                <tr>
                    <th class="w-1/6 text-center p-2">
                        <div class="flex items-center">
                            <i class="far fa-clock mr-2 text-blue-400"></i>
                            <span>경기 일시</span>
                        </div>
                    </th>
                    <th class="w-1/5 text-center p-2">
                        <div class="flex items-center justify-center">
                            <i class="fas fa-users mr-2 text-blue-400"></i>
                            <span>팀1</span>
                        </div>
                    </th>
                    <th class="w-1/12 text-center p-2">VS</th>
                    <th class="w-1/5 text-center p-2">
                        <div class="flex items-center justify-center">
                            <i class="fas fa-users mr-2 text-blue-400"></i>
                            <span>팀2</span>
                        </div>
                    </th>
                    <th class="w-1/6 text-center p-2">
                        <div class="flex items-center justify-center">
                            <i class="fas fa-flag-checkered mr-2 text-blue-400"></i>
                            <span>결과</span>
                        </div>
                    </th>
                    <th class="w-1/4 text-center p-2">
                        <div class="flex items-center justify-center">
                            <i class="fas fa-chart-pie mr-2 text-blue-400"></i>
                            <span>내 예측</span>
                        </div>
                    </th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="match" items="${matches}" varStatus="status">
                    <tr>
                        <td>
                            <div class="text-white font-medium">${fn:substring(match.match().match_date(), 0, 11)}</div>
                            <div class="text-xs text-gray-400 mt-1">${fn:substring(match.match().match_date(), 11, 17)}</div>
                        </td>
                        <td class="text-center">
                            <div class="flex items-center justify-center">
                                        <span class="team-tag">
                                                ${match.team1().teamName()}
                                        </span>
                            </div>
                        </td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${match.match().is_finished() == 1}">
                                    <div class="match-score">
                                            ${match.match().team1_score()} : ${match.match().team2_score()}
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="vs-tag">VS</div>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <div class="flex items-center justify-center">
                                        <span class="team-tag">
                                                ${match.team2().teamName()}
                                        </span>
                            </div>
                        </td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${match.match().is_finished() == 1}">
                                    <c:choose>
                                        <c:when test="${match.match().winner_id() == match.team1().teamId()}">
                                                    <span class="badge badge-blue result-badge">
                                                        <i class="fas fa-trophy text-yellow-400 mr-1"></i>
                                                        ${match.team1().teamName()} 승리
                                                    </span>
                                        </c:when>
                                        <c:when test="${match.match().winner_id() == match.team2().teamId()}">
                                                    <span class="badge badge-blue result-badge">
                                                        <i class="fas fa-trophy text-yellow-400 mr-1"></i>
                                                        ${match.team2().teamName()} 승리
                                                    </span>
                                        </c:when>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                            <span class="badge badge-gray result-badge">
                                                <i class="far fa-clock mr-1"></i> 경기 예정
                                            </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <sec:authorize access="isAuthenticated()">
                                <c:choose>
                                    <c:when test="${match.match().is_finished() == 1}">
                                        <!-- 이미 종료된 경기 -->
                                        <c:choose>
                                            <c:when test="${match.userPrediction() != null}">
                                                <c:choose>
                                                    <c:when test="${match.userPrediction().predictedWinnerId() == match.team1().teamId()}">
                                                                <span class="${match.userPrediction().predictedWinnerId() == match.match().winner_id() ? 'badge badge-green' : 'badge badge-red'} prediction-status">
                                                                    ${match.team1().teamName()} 예측
                                                                    <c:if test="${match.userPrediction().predictedWinnerId() == match.match().winner_id()}">
                                                                        <i class="fas fa-check ml-1"></i>
                                                                    </c:if>
                                                                    <c:if test="${match.userPrediction().predictedWinnerId() != match.match().winner_id()}">
                                                                        <i class="fas fa-times ml-1"></i>
                                                                    </c:if>
                                                                </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                                <span class="${match.userPrediction().predictedWinnerId() == match.match().winner_id() ? 'badge badge-green' : 'badge badge-red'} prediction-status">
                                                                    ${match.team2().teamName()} 예측
                                                                    <c:if test="${match.userPrediction().predictedWinnerId() == match.match().winner_id()}">
                                                                        <i class="fas fa-check ml-1"></i>
                                                                    </c:if>
                                                                    <c:if test="${match.userPrediction().predictedWinnerId() != match.match().winner_id()}">
                                                                        <i class="fas fa-times ml-1"></i>
                                                                    </c:if>
                                                                </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                        <span class="text-gray-500 flex items-center justify-center">
                                                            <i class="fas fa-minus-circle mr-1"></i> 예측 없음
                                                        </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- 예정된 경기 -->
                                        <div class="flex justify-center space-x-3">
                                            <form action="${pageContext.request.contextPath}/matches/predict" method="post" class="inline" data-team-name="${match.team1().teamName()}">
                                                <sec:csrfInput />
                                                <input type="hidden" name="matchId" value="${match.match().match_id()}">
                                                <input type="hidden" name="teamId" value="${match.team1().teamId()}">
                                                <button type="submit" class="${match.userPrediction() != null && match.userPrediction().predictedWinnerId() == match.team1().teamId() ? 'btn-predict btn-blue' : 'btn-predict btn-gray'} ${match.userPrediction() != null && match.userPrediction().predictedWinnerId() == match.team1().teamId() ? 'animate-pulse' : ''}">
                                                    <c:if test="${match.userPrediction() != null && match.userPrediction().predictedWinnerId() == match.team1().teamId()}">
                                                        <i class="fas fa-check-circle mr-1"></i>
                                                    </c:if>
                                                        ${match.team1().teamName()}
                                                </button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/matches/predict" method="post" class="inline" data-team-name="${match.team2().teamName()}">
                                                <sec:csrfInput />
                                                <input type="hidden" name="matchId" value="${match.match().match_id()}">
                                                <input type="hidden" name="teamId" value="${match.team2().teamId()}">
                                                <button type="submit" class="${match.userPrediction() != null && match.userPrediction().predictedWinnerId() == match.team2().teamId() ? 'btn-predict btn-blue' : 'btn-predict btn-gray'} ${match.userPrediction() != null && match.userPrediction().predictedWinnerId() == match.team2().teamId() ? 'animate-pulse' : ''}">
                                                    <c:if test="${match.userPrediction() != null && match.userPrediction().predictedWinnerId() == match.team2().teamId()}">
                                                        <i class="fas fa-check-circle mr-1"></i>
                                                    </c:if>
                                                        ${match.team2().teamName()}
                                                </button>
                                            </form>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </sec:authorize>
                            <sec:authorize access="isAnonymous()">
                                <a href="/login" class="text-blue-400 hover:text-blue-300 text-sm flex items-center justify-center">
                                    <i class="fas fa-sign-in-alt mr-1"></i> 로그인하여 예측
                                </a>
                            </sec:authorize>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Rules Section -->
    <div class="lck-card mt-8">
        <div class="card-header flex items-center">
            <i class="fas fa-info-circle mr-2 text-blue-400"></i>
            <span>예측 규칙</span>
        </div>
        <div class="p-6">
            <div class="rules-grid">
                <div class="rule-card">
                    <div class="rule-icon bg-blue-900 text-blue-400">
                        <i class="fas fa-clock"></i>
                    </div>
                    <h3 class="text-lg font-medium text-white mb-2">예측 기간</h3>
                    <p class="text-gray-400 text-sm">경기 시작 전까지 예측을 변경할 수 있습니다. 경기가 시작되면 예측이 잠깁니다.</p>
                </div>

                <div class="rule-card">
                    <div class="rule-icon bg-green-900 text-green-400">
                        <i class="fas fa-coins"></i>
                    </div>
                    <h3 class="text-lg font-medium text-white mb-2">포인트 획득</h3>
                    <p class="text-gray-400 text-sm">정확한 예측 시 10 포인트를 획득합니다. 가능한 많은 경기를 예측해보세요!</p>
                </div>

                <div class="rule-card">
                    <div class="rule-icon bg-yellow-900 text-yellow-400">
                        <i class="fas fa-trophy"></i>
                    </div>
                    <h3 class="text-lg font-medium text-white mb-2">승률 계산</h3>
                    <p class="text-gray-400 text-sm">모든 예측은 당신의 개인 예측 승률에 반영됩니다. 예측 승률을 높게 유지하세요!</p>
                </div>

                <div class="rule-card">
                    <div class="rule-icon bg-red-900 text-red-400">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <h3 class="text-lg font-medium text-white mb-2">변경 불가</h3>
                    <p class="text-gray-400 text-sm">경기가 종료된 후에는 예측을 변경할 수 없습니다. 신중하게 예측해주세요.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 푸터 -->
<!-- Footer -->
<footer class="bg-gray-900 mt-12 border-t border-gray-800">
    <div class="lck-container py-12">
        <div class="flex flex-wrap justify-center -mx-5 -my-2">
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
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // CSRF 토큰 가져오기
        const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content')
            || document.querySelector('input[name="_csrf"]')?.value;
        const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content')
            || "${_csrf.headerName}";

        // 모든 예측 폼에 이벤트 리스너 추가
        const predictionForms = document.querySelectorAll('form[action*="/matches/predict"]');

        predictionForms.forEach(form => {
            form.addEventListener('submit', function(e) {
                e.preventDefault(); // 폼의 기본 제출 동작 방지

                // 폼 데이터 가져오기
                const matchIdInput = this.querySelector('input[name="matchId"]');
                const teamIdInput = this.querySelector('input[name="teamId"]');

                if (!matchIdInput || !teamIdInput) {
                    console.error('matchId 또는 teamId 입력이 없습니다');
                    return;
                }

                const matchId = matchIdInput.value;
                const teamId = teamIdInput.value;

                // 버튼과 원래 팀 이름 저장
                const button = this.querySelector('button');
                const originalButtonHTML = button.innerHTML; // 원본 HTML 저장

                // 로딩 표시
                button.innerHTML = '<i class="fas fa-spinner fa-spin mr-1"></i> 처리중...';
                button.disabled = true;

                // FormData 객체 생성
                const formData = new FormData();
                formData.append('matchId', matchId);
                formData.append('teamId', teamId);
                formData.append('${_csrf.parameterName}', csrfToken);

                // AJAX 요청
                fetch('${pageContext.request.contextPath}/matches/predict', {
                    method: 'POST',
                    headers: {
                        [csrfHeader]: csrfToken
                    },
                    body: new URLSearchParams(formData)
                })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('서버 응답 오류: ' + response.status);
                        }
                        console.log('서버 응답 성공');
                        return response.json();
                    })
                    .then(data => {
                        console.log('받은 데이터:', data);
                        if (data.success) {
                            // 성공 메시지 표시
                            showMessage(true, data.message || '예측이 성공적으로 저장되었습니다.');

                            // 현재 경기의 모든 팀 버튼 업데이트
                            updatePredictionButtons(matchId, teamId);
                        } else {
                            // 오류 메시지 표시
                            showMessage(false, data.error || '예측 저장 실패');

                            // 버튼 원래 상태로 복원
                            button.innerHTML = originalButtonHTML;
                            button.disabled = false;
                        }
                    })
                    .catch(error => {
                        console.error('예측 처리 중 오류:', error);
                        showMessage(false, '예측 처리 중 오류가 발생했습니다.');

                        // 버튼 원래 상태로 복원
                        button.innerHTML = originalButtonHTML;
                        button.disabled = false;
                    });
            });
        });

        // 메시지 표시 함수
        function showMessage(isSuccess, message) {
            // 기존 메시지 요소 제거
            console.log(`안녕하세요 ${message}`)
            const existingMessages = document.querySelectorAll('.alert-message');
            existingMessages.forEach(el => el.remove());

            // 새 메시지 요소 생성
            const messageDiv = document.createElement('div');
            messageDiv.className = isSuccess
                ? 'bg-gradient-to-r from-green-900 to-green-800 border border-green-700 text-white p-4 rounded-md shadow-md flex items-center alert-message'
                : 'bg-gradient-to-r from-red-900 to-red-800 border border-red-700 text-white p-4 rounded-md shadow-md flex items-center alert-message';

            messageDiv.innerHTML = `
                <i class="fas fa-\${isSuccess ? 'check' : 'exclamation'}-circle text-xl mr-3"></i>
                <span>\${message}</span>
            `;

            // 토스트 스타일 적용
            Object.assign(messageDiv.style, {
                position: 'fixed',
                top: '20px',
                left: '50%',
                transform: 'translateX(-50%) translateY(50px)',
                transition: 'opacity 0.5s ease, transform 0.5s ease',
                opacity: '0',
                zIndex: '1000',
            });

            document.body.appendChild(messageDiv);

            // 0.1초 후 애니메이션으로 나타나게 설정
            setTimeout(() => {
                messageDiv.style.opacity = '1';
                messageDiv.style.transform = 'translateX(-50%) translateY(0)';
            }, 100);

            // 5초 후 메시지 사라짐
            setTimeout(() => {
                messageDiv.style.opacity = '0';
                messageDiv.style.transform = 'translateX(-50%) translateY(50px)';
                setTimeout(() => messageDiv.remove(), 500);
            }, 5000);
        }

        // 예측 버튼 업데이트 함수
        function updatePredictionButtons(matchId, selectedTeamId) {
            console.log('버튼 업데이트: 매치 ID =', matchId, '선택된 팀 ID =', selectedTeamId);

            // 문자열로 변환
            matchId = String(matchId);
            selectedTeamId = String(selectedTeamId);

            // 모든 예측 폼을 스캔
            const allForms = document.querySelectorAll('form[action*="/matches/predict"]');
            console.log('전체 예측 폼 수:', allForms.length);

            let matchFormsCount = 0;

            allForms.forEach(form => {
                const matchIdInput = form.querySelector('input[name="matchId"]');
                const teamIdInput = form.querySelector('input[name="teamId"]');
                const button = form.querySelector('button');

                if (!matchIdInput || !teamIdInput || !button) return;

                const currentMatchId = matchIdInput.value;
                const currentTeamId = teamIdInput.value;

                // 현재 폼이 업데이트할 매치에 해당하는지 확인
                if (currentMatchId === matchId) {
                    matchFormsCount++;
                    console.log('매치 ID 일치 폼 발견:', currentMatchId, '팀 ID:', currentTeamId);

                    // 원래 팀 이름 가져오기
                    const teamNameText = form.getAttribute('data-team-name');

                    if (currentTeamId === selectedTeamId) {
                        console.log('선택된 팀 버튼:', teamNameText);
                        // 선택된 팀 버튼 업데이트
                        button.className = 'btn-predict btn-blue animate-pulse';
                        button.disabled = false;

                        // 체크 아이콘과 팀 이름으로 내용 설정
                        button.innerHTML = '<i class="fas fa-check-circle mr-1"></i>' + teamNameText;
                    } else {
                        console.log('선택되지 않은 팀 버튼:', teamNameText);
                        // 선택되지 않은 팀 버튼 업데이트
                        button.className = 'btn-predict btn-gray';
                        button.disabled = false;

                        // 팀 이름만 표시
                        button.innerHTML = teamNameText;
                    }
                }
            });

            console.log('업데이트된 매치 폼 수:', matchFormsCount);
        }
    });
</script>
</body>
</html>