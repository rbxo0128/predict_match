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
    <!-- Add Font Awesome for better icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
                    <a href="/" class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                        <i class="fas fa-home mr-1"></i> 홈
                    </a>
                    <a href="/matches" class="border-blue-500 text-gray-900 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
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
                    <a href="/signup" class="bg-blue-600 text-white hover:bg-blue-700 px-3 py-2 rounded-md text-sm font-medium ml-3 flex items-center">
                        <i class="fas fa-user-plus mr-1"></i> 회원가입
                    </a>
                </sec:authorize>
            </div>
        </div>
    </div>
</nav>

<!-- 메인 컨텐츠 -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-gray-900 flex items-center">
            <i class="fas fa-gamepad mr-3 text-blue-600"></i> LCK 경기 일정
        </h1>
        <div class="text-gray-500 text-sm">
            <i class="fas fa-info-circle mr-1"></i> 경기 시작 전까지 예측을 변경할 수 있습니다
        </div>
    </div>

    <!-- 알림 메시지 -->
    <c:if test="${not empty error}">
        <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded shadow-sm" role="alert">
            <div class="flex items-center">
                <i class="fas fa-exclamation-circle mr-2"></i>
                <span>${error}</span>
            </div>
        </div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded shadow-sm" role="alert">
            <div class="flex items-center">
                <i class="fas fa-check-circle mr-2"></i>
                <span>${success}</span>
            </div>
        </div>
    </c:if>

    <!-- 경기 목록 -->
    <div class="bg-white shadow overflow-hidden rounded-lg mb-8">
        <div class="bg-gradient-to-r from-blue-600 to-blue-500 text-white py-3 px-6 flex items-center">
            <i class="fas fa-calendar-alt mr-2"></i>
            <span class="font-bold">경기 일정 및 예측</span>
        </div>
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
            <tr>
                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    <i class="far fa-clock mr-1"></i> 경기 일시
                </th>
                <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                    <i class="fas fa-users mr-1"></i> 팀1
                </th>
                <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">VS</th>
                <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                    <i class="fas fa-users mr-1"></i> 팀2
                </th>
                <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                    <i class="fas fa-flag-checkered mr-1"></i> 결과
                </th>
                <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                    <i class="fas fa-chart-pie mr-1"></i> 내 예측
                </th>
            </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
            <c:forEach var="match" items="${matches}" varStatus="status">
                <tr class="${status.index % 2 == 0 ? 'bg-white' : 'bg-gray-50'}">
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm text-gray-900 font-medium">${fn:substring(match.match().match_date(), 0, 10)}</div>
                        <div class="text-xs text-gray-500">${fn:substring(match.match().match_date(), 11, 16)}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="flex items-center justify-center">
                            <span class="text-sm font-medium text-gray-900 bg-blue-50 px-3 py-1 rounded-full">
                                    ${match.team1().teamName()}
                            </span>
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-center text-sm text-gray-900 font-bold">
                        <c:choose>
                            <c:when test="${match.match().is_finished() == 1}">
                                <div class="px-3 py-1 bg-gray-100 rounded text-center inline-block min-w-[60px]">
                                        ${match.match().team1_score()} : ${match.match().team2_score()}
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-gray-400">VS</div>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="flex items-center justify-center">
                            <span class="text-sm font-medium text-gray-900 bg-blue-50 px-3 py-1 rounded-full">
                                    ${match.team2().teamName()}
                            </span>
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-center text-sm">
                        <c:choose>
                            <c:when test="${match.match().is_finished() == 1}">
                                <c:choose>
                                    <c:when test="${match.match().winner_id() == match.team1().teamId()}">
                                        <span class="px-2 py-1 rounded-full bg-blue-100 text-blue-800 font-medium flex items-center justify-center w-28 mx-auto">
                                            <i class="fas fa-trophy text-yellow-500 mr-1"></i>
                                            ${match.team1().teamName()} 승리
                                        </span>
                                    </c:when>
                                    <c:when test="${match.match().winner_id() == match.team2().teamId()}">
                                        <span class="px-2 py-1 rounded-full bg-blue-100 text-blue-800 font-medium flex items-center justify-center w-28 mx-auto">
                                            <i class="fas fa-trophy text-yellow-500 mr-1"></i>
                                            ${match.team2().teamName()} 승리
                                        </span>
                                    </c:when>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <span class="px-2 py-1 rounded-full bg-gray-100 text-gray-800 flex items-center justify-center w-20 mx-auto">
                                    <i class="far fa-clock mr-1"></i> 경기 예정
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-center text-sm">
                        <sec:authorize access="isAuthenticated()">
                            <c:choose>
                                <c:when test="${match.match().is_finished() == 1}">
                                    <!-- 이미 종료된 경기 -->
                                    <c:choose>
                                        <c:when test="${match.userPrediction() != null}">
                                            <c:choose>
                                                <c:when test="${match.userPrediction().predictedWinnerId() == match.team1().teamId()}">
                                                    <span class="${match.userPrediction().predictedWinnerId() == match.match().winner_id() ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'} px-2 py-1 rounded-full font-medium inline-flex items-center">
                                                        ${match.team1().teamName()} 예측
                                                        <c:if test="${match.userPrediction().predictedWinnerId() == match.match().winner_id()}">
                                                            <i class="fas fa-check ml-1 text-green-600"></i>
                                                        </c:if>
                                                        <c:if test="${match.userPrediction().predictedWinnerId() != match.match().winner_id()}">
                                                            <i class="fas fa-times ml-1 text-red-600"></i>
                                                        </c:if>
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="${match.userPrediction().predictedWinnerId() == match.match().winner_id() ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'} px-2 py-1 rounded-full font-medium inline-flex items-center">
                                                        ${match.team2().teamName()} 예측
                                                        <c:if test="${match.userPrediction().predictedWinnerId() == match.match().winner_id()}">
                                                            <i class="fas fa-check ml-1 text-green-600"></i>
                                                        </c:if>
                                                        <c:if test="${match.userPrediction().predictedWinnerId() != match.match().winner_id()}">
                                                            <i class="fas fa-times ml-1 text-red-600"></i>
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
                                    <div class="flex justify-center space-x-2">
                                        <form action="${pageContext.request.contextPath}/matches/predict" method="post" class="inline">
                                            <sec:csrfInput />
                                            <input type="hidden" name="matchId" value="${match.match().match_id()}">
                                            <input type="hidden" name="teamId" value="${match.team1().teamId()}">
                                            <button type="submit" class="${match.userPrediction() != null && match.userPrediction().predictedWinnerId() == match.team1().teamId() ? 'bg-blue-500 text-white' : 'bg-gray-200 text-gray-800'} px-3 py-1 rounded-full text-xs font-medium hover:bg-blue-600 hover:text-white transition-colors duration-200 flex items-center">
                                                <c:if test="${match.userPrediction() != null && match.userPrediction().predictedWinnerId() == match.team1().teamId()}">
                                                    <i class="fas fa-check-circle mr-1"></i>
                                                </c:if>
                                                    ${match.team1().teamName()}
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/matches/predict" method="post" class="inline">
                                            <sec:csrfInput />
                                            <input type="hidden" name="matchId" value="${match.match().match_id()}">
                                            <input type="hidden" name="teamId" value="${match.team2().teamId()}">
                                            <button type="submit" class="${match.userPrediction() != null && match.userPrediction().predictedWinnerId() == match.team2().teamId() ? 'bg-blue-500 text-white' : 'bg-gray-200 text-gray-800'} px-3 py-1 rounded-full text-xs font-medium hover:bg-blue-600 hover:text-white transition-colors duration-200 flex items-center">
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
                            <a href="/login" class="text-blue-600 hover:text-blue-800 text-sm flex items-center justify-center">
                                <i class="fas fa-sign-in-alt mr-1"></i> 로그인하여 예측
                            </a>
                        </sec:authorize>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- 규칙 섹션 -->
    <div class="mt-8 bg-white shadow overflow-hidden rounded-lg">
        <div class="bg-gradient-to-r from-blue-600 to-blue-500 text-white py-3 px-6 flex items-center">
            <i class="fas fa-info-circle mr-2"></i>
            <span class="font-bold">예측 규칙</span>
        </div>
        <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="flex items-start">
                    <div class="flex-shrink-0 h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="ml-4">
                        <h3 class="text-lg font-medium text-gray-900">예측 기간</h3>
                        <p class="mt-1 text-sm text-gray-500">경기 시작 전까지 예측을 변경할 수 있습니다. 경기가 시작되면 예측이 잠깁니다.</p>
                    </div>
                </div>
                <div class="flex items-start">
                    <div class="flex-shrink-0 h-10 w-10 rounded-full bg-green-100 flex items-center justify-center text-green-600">
                        <i class="fas fa-coins"></i>
                    </div>
                    <div class="ml-4">
                        <h3 class="text-lg font-medium text-gray-900">포인트 획득</h3>
                        <p class="mt-1 text-sm text-gray-500">정확한 예측 시 10 포인트를 획득합니다. 가능한 많은 경기를 예측해보세요!</p>
                    </div>
                </div>
                <div class="flex items-start">
                    <div class="flex-shrink-0 h-10 w-10 rounded-full bg-yellow-100 flex items-center justify-center text-yellow-600">
                        <i class="fas fa-trophy"></i>
                    </div>
                    <div class="ml-4">
                        <h3 class="text-lg font-medium text-gray-900">승률 계산</h3>
                        <p class="mt-1 text-sm text-gray-500">모든 예측은 당신의 개인 예측 승률에 반영됩니다. 예측 승률을 높게 유지하세요!</p>
                    </div>
                </div>
                <div class="flex items-start">
                    <div class="flex-shrink-0 h-10 w-10 rounded-full bg-red-100 flex items-center justify-center text-red-600">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div class="ml-4">
                        <h3 class="text-lg font-medium text-gray-900">변경 불가</h3>
                        <p class="mt-1 text-sm text-gray-500">경기가 종료된 후에는 예측을 변경할 수 없습니다. 신중하게 예측해주세요.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 푸터 -->
<footer class="bg-white mt-12">
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
</body>
</html>