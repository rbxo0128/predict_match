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
  <title>LCK 내 예측 기록</title>
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

    .stat-cards-container {
      display: flex;
      width: 100%;
      margin-bottom: 2rem;
    }

    .stat-card {
      flex: 1;
      background-color: #101722;
      border-radius: 8px;
      padding: 2rem;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      transition: transform 0.2s;
      margin: 0 0.5rem;
    }

    .stat-card:first-child {
      margin-left: 0;
    }

    .stat-card:last-child {
      margin-right: 0;
    }

    .stat-card:hover {
      transform: translateY(-5px);
    }

    .stat-card.blue {
      background: linear-gradient(135deg, #0a1428 0%, #102a5c 100%);
      border: 1px solid #1a3870;
    }

    .stat-card.green {
      background: linear-gradient(135deg, #0a281a 0%, #10462a 100%);
      border: 1px solid #1a5c3e;
    }

    .stat-card.purple {
      background: linear-gradient(135deg, #1f0a28 0%, #3a1046 100%);
      border: 1px solid #4e1a5c;
    }

    .stat-icon {
      width: 50px;
      height: 50px;
      border-radius: 50%;
      background-color: rgba(255, 255, 255, 0.1);
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 16px;
      font-size: 1.5rem;
    }

    .stat-title {
      color: #b0b8c8;
      font-size: 0.9rem;
      margin-bottom: 8px;
    }

    .stat-value {
      font-size: 2rem;
      font-weight: bold;
      margin-bottom: 4px;
    }

    .blue-text {
      color: #4e9fff;
    }

    .green-text {
      color: #04c166;
    }

    .purple-text {
      color: #a64eff;
    }

    .prediction-table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0;
    }

    .prediction-table th {
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

    .prediction-table tr:nth-child(odd) {
      background-color: #0f1520;
    }

    .prediction-table tr:nth-child(even) {
      background-color: #121927;
    }

    .prediction-table tr:hover {
      background-color: #151b2e;
    }

    .prediction-table td {
      padding: 16px;
      border-bottom: 1px solid #1a2136;
      vertical-align: middle;
    }

    .prediction-row {
      transition: transform 0.2s ease;
    }

    .prediction-row:hover {
      transform: translateX(5px);
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

    .badge-yellow {
      background-color: rgba(250, 204, 21, 0.15);
      color: #facc15;
      border: 1px solid rgba(250, 204, 21, 0.3);
    }

    .badge-gray {
      background-color: rgba(142, 152, 174, 0.15);
      color: #8e98ae;
      border: 1px solid rgba(142, 152, 174, 0.3);
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

    .empty-state {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 60px 20px;
      text-align: center;
    }

    .empty-icon {
      font-size: 4rem;
      color: #1a2136;
      margin-bottom: 20px;
    }

    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 8px 16px;
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
      transform: translateY(-1px);
      box-shadow: 0 4px 8px rgba(0, 65, 185, 0.5);
    }

    .ring-pulse-blue {
      border-radius: 50%;
      animation: ring-pulse-blue 1.5s infinite;
    }

    @keyframes ring-pulse-blue {
      0% {
        box-shadow: 0 0 0 0 rgba(78, 159, 255, 0.4);
      }
      70% {
        box-shadow: 0 0 0 10px rgba(78, 159, 255, 0);
      }
      100% {
        box-shadow: 0 0 0 0 rgba(78, 159, 255, 0);
      }
    }

    .ring-pulse-green {
      border-radius: 50%;
      animation: ring-pulse-green 1.5s infinite;
    }

    @keyframes ring-pulse-green {
      0% {
        box-shadow: 0 0 0 0 rgba(4, 193, 102, 0.4);
      }
      70% {
        box-shadow: 0 0 0 10px rgba(4, 193, 102, 0);
      }
      100% {
        box-shadow: 0 0 0 0 rgba(4, 193, 102, 0);
      }
    }

    .ring-pulse-purple {
      border-radius: 50%;
      animation: ring-pulse-purple 1.5s infinite;
    }

    @keyframes ring-pulse-purple {
      0% {
        box-shadow: 0 0 0 0 rgba(166, 78, 255, 0.4);
      }
      70% {
        box-shadow: 0 0 0 10px rgba(166, 78, 255, 0);
      }
      100% {
        box-shadow: 0 0 0 0 rgba(166, 78, 255, 0);
      }
    }

    /* Progress bar for accuracy */
    .accuracy-bar {
      width: 100%;
      height: 8px;
      background-color: #1a2136;
      border-radius: 4px;
      overflow: hidden;
      margin-top: 5px;
    }

    .accuracy-progress {
      height: 100%;
      border-radius: 4px;
    }

    .high-accuracy {
      background: linear-gradient(90deg, #00c853 0%, #69f0ae 100%);
    }

    .medium-accuracy {
      background: linear-gradient(90deg, #ffd600 0%, #ffff00 100%);
    }

    .low-accuracy {
      background: linear-gradient(90deg, #ff3d00 0%, #ff8a65 100%);
    }

    .vs-badge {
      background-color: #1a2136;
      border-radius: 50%;
      width: 24px;
      height: 24px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 0.7rem;
      color: #8e98ae;
    }

    .team-name {
      font-weight: 500;
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
          <a href="/rankings" class="nav-item">
            <i class="fas fa-trophy mr-1"></i> 순위표
          </a>
          <a href="/predictions" class="nav-item active">
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
                                <i class="fas fa-coins mr-1"></i> ${user.point()} P
                            </span>
          </div>
          <a href="/logout" class="ml-4 text-sm text-gray-300 hover:text-white flex items-center">
            <i class="fas fa-sign-out-alt mr-1"></i> 로그아웃
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
      <i class="fas fa-chart-line mr-3 text-blue-400"></i> 내 예측 기록
    </h1>
    <div class="text-gray-400 text-sm flex items-center">
      <i class="fas fa-user-check mr-1"></i> 예측 마스터:
      <span class="text-white ml-1 font-medium">${user.username()}</span>
    </div>
  </div>

  <!-- Prediction Statistics -->
  <div class="stat-cards-container">
    <div class="stat-card blue">
      <div class="stat-icon text-blue-400 ring-pulse-blue">
        <i class="fas fa-chart-line"></i>
      </div>
      <div class="stat-title">총 예측</div>
      <div class="stat-value blue-text">${predictions.size()}</div>
      <div class="text-gray-400 text-sm">참여한 전체 경기 수</div>
    </div>

    <div class="stat-card green">
      <div class="stat-icon text-green-400 ring-pulse-green">
        <i class="fas fa-check-circle"></i>
      </div>
      <div class="stat-title">정확한 예측</div>
      <div class="stat-value green-text">${correctPredictions} <span class="text-sm text-gray-400">/ ${totalFinishedMatches}</span></div>
      <div class="text-gray-400 text-sm">종료된 경기 중 맞춘 수</div>
    </div>

    <div class="stat-card purple">
      <div class="stat-icon text-purple-400 ring-pulse-purple">
        <i class="fas fa-percentage"></i>
      </div>
      <div class="stat-title">정확도</div>
      <div class="stat-value purple-text">
        <fmt:formatNumber value="${accuracyPercentage}" pattern="#0.0" />%
      </div>
      <div class="accuracy-bar">
        <div class="accuracy-progress ${accuracyPercentage >= 70 ? 'high-accuracy' : accuracyPercentage >= 40 ? 'medium-accuracy' : 'low-accuracy'}"
             style="width: ${accuracyPercentage}%"></div>
      </div>
    </div>
  </div>

  <!-- Prediction History -->
  <div class="lck-card">
    <div class="card-header flex items-center">
      <i class="fas fa-history mr-2 text-blue-400"></i>
      <span>예측 기록</span>
    </div>

    <c:choose>
      <c:when test="${empty predictions}">
        <div class="empty-state">
          <i class="fas fa-chart-bar empty-icon"></i>
          <p class="text-gray-400 mb-4">아직 예측한 경기가 없습니다.</p>
          <a href="/matches" class="btn btn-blue">
            <i class="fas fa-gamepad mr-2"></i> 경기 예측하러 가기
          </a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="overflow-x-auto">
          <table class="prediction-table">
            <thead>
            <tr>
              <th class="w-1/6">
                <i class="far fa-calendar-alt mr-1 text-blue-400"></i> 경기 일시
              </th>
              <th class="w-1/4 text-center">
                <i class="fas fa-gamepad mr-1 text-blue-400"></i> 매치업
              </th>
              <th class="w-1/6 text-center">
                <i class="fas fa-user-check mr-1 text-blue-400"></i> 내 예측
              </th>
              <th class="w-1/6 text-center">
                <i class="fas fa-trophy mr-1 text-blue-400"></i> 결과
              </th>
              <th class="w-1/6 text-center">
                <i class="fas fa-info-circle mr-1 text-blue-400"></i> 상태
              </th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="pred" items="${predictions}" varStatus="status">
              <tr class="prediction-row">
                <td>
                  <div class="text-white font-medium">${fn:substring(pred.match().match_date(), 0, 10)}</div>
                  <div class="text-xs text-gray-400 mt-1">${fn:substring(pred.match().match_date(), 11, 16)}</div>
                </td>
                <td>
                  <div class="flex items-center justify-center space-x-2">
                    <span class="team-name">${pred.team1().teamName()}</span>
                    <span class="vs-badge">VS</span>
                    <span class="team-name">${pred.team2().teamName()}</span>
                  </div>
                </td>
                <td class="text-center">
                                            <span class="badge ${pred.isCorrect() ? 'badge-green' : pred.match().is_finished() == 1 ? 'badge-red' : 'badge-blue'}">
                                                ${pred.predictedTeam().teamName()}
                                            </span>
                </td>
                <td class="text-center">
                  <c:choose>
                    <c:when test="${pred.match().is_finished() == 1}">
                      <c:choose>
                        <c:when test="${pred.match().winner_id() == pred.team1().teamId()}">
                          <span class="text-white">${pred.team1().teamName()} 승리</span>
                        </c:when>
                        <c:when test="${pred.match().winner_id() == pred.team2().teamId()}">
                          <span class="text-white">${pred.team2().teamName()} 승리</span>
                        </c:when>
                      </c:choose>
                    </c:when>
                    <c:otherwise>
                      <span class="text-gray-400">경기 예정</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td class="text-center">
                  <c:choose>
                    <c:when test="${pred.match().is_finished() == 0}">
                                                    <span class="badge badge-yellow">
                                                        <i class="fas fa-clock mr-1"></i> 진행중
                                                    </span>
                    </c:when>
                    <c:otherwise>
                      <c:choose>
                        <c:when test="${pred.isCorrect()}">
                                                            <span class="badge badge-green">
                                                                <i class="fas fa-plus-circle mr-1"></i> 정확 (+10P)
                                                            </span>
                        </c:when>
                        <c:otherwise>
                                                            <span class="badge badge-red">
                                                                <i class="fas fa-times-circle mr-1"></i> 오답
                                                            </span>
                        </c:otherwise>
                      </c:choose>
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </c:otherwise>
    </c:choose>
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