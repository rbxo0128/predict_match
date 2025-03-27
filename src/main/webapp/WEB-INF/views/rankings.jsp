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
            </div>
        </div>
    </div>
</nav>

<!-- 메인 컨텐츠 -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-gray-900 flex items-center">
            <i class="fas fa-trophy mr-3 text-yellow-500"></i> LCK 2025 팀 순위
        </h1>
        <div class="text-gray-500 text-sm">
            <i class="fas fa-sync-alt mr-1"></i> 최종 업데이트: <span class="font-medium"><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %></span>
        </div>
    </div>

    <!-- 팀 순위 테이블 -->
    <div class="bg-white shadow-lg overflow-hidden rounded-lg mb-8">
        <div class="bg-gradient-to-r from-blue-600 to-blue-500 text-white py-3 px-6 flex items-center">
            <i class="fas fa-list-ol mr-2"></i>
            <span class="font-bold">팀 순위표</span>
        </div>
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        <div class="flex items-center">
                            <i class="fas fa-hashtag mr-1"></i> 순위
                        </div>
                    </th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        <div class="flex items-center">
                            <i class="fas fa-users mr-1"></i> 팀명
                        </div>
                    </th>
                    <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                        <div class="flex items-center justify-center">
                            <i class="fas fa-gamepad mr-1"></i> 승/패
                        </div>
                    </th>
                    <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                        <div class="flex items-center justify-center">
                            <i class="fas fa-percentage mr-1"></i> 승률
                        </div>
                    </th>
                    <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider hidden md:table-cell">
                        <div class="flex items-center justify-center">
                            <i class="fas fa-chart-bar mr-1"></i> 그래프
                        </div>
                    </th>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                <c:forEach var="stats" items="${teamStats}" varStatus="status">
                    <tr class="${status.index < 3 ? 'bg-blue-50 hover:bg-blue-100' : 'hover:bg-gray-100'} transition-colors duration-150">
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm font-medium text-gray-900 flex items-center">
                                <c:choose>
                                    <c:when test="${status.index == 0}">
                                        <div class="flex items-center justify-center w-8 h-8 bg-yellow-100 text-yellow-800 rounded-full mr-2">
                                            <i class="fas fa-crown text-yellow-500"></i>
                                        </div>
                                    </c:when>
                                    <c:when test="${status.index == 1}">
                                        <div class="flex items-center justify-center w-8 h-8 bg-gray-200 text-gray-700 rounded-full mr-2">
                                            <i class="fas fa-medal text-gray-500"></i>
                                        </div>
                                    </c:when>
                                    <c:when test="${status.index == 2}">
                                        <div class="flex items-center justify-center w-8 h-8 bg-yellow-50 text-yellow-700 rounded-full mr-2">
                                            <i class="fas fa-medal text-yellow-700"></i>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="flex items-center justify-center w-8 h-8 bg-gray-100 text-gray-500 rounded-full mr-2">
                                                ${status.index + 1}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <span class="${status.index == 0 ? 'text-lg font-bold' : ''}">${status.index + 1}</span>
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm font-bold text-gray-900 ${status.index < 3 ? 'text-blue-800' : ''}">${stats.team().teamName()}</div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-center">
                            <div class="inline-flex items-center">
                                <span class="px-2 py-1 rounded-l-md bg-green-100 text-green-800 text-sm font-medium">
                                    <i class="fas fa-plus-circle mr-1"></i> ${stats.wins()}승
                                </span>
                                <span class="px-2 py-1 rounded-r-md bg-red-100 text-red-800 text-sm font-medium">
                                    <i class="fas fa-minus-circle mr-1"></i> ${stats.losses()}패
                                </span>
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-center">
                            <div class="text-sm font-bold ${stats.winRate() >= 70 ? 'text-blue-600' : stats.winRate() >= 50 ? 'text-green-600' : 'text-gray-900'}">
                                <fmt:formatNumber value="${stats.winRate()}" pattern="#0.0" />%
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-center hidden md:table-cell">
                            <div class="w-full bg-gray-200 rounded-full h-2.5 dark:bg-gray-700">
                                <div class="bg-blue-600 h-2.5 rounded-full" style="width: ${stats.winRate()}%"></div>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- 플레이오프 컷라인 표시 -->
    <div class="bg-white shadow-lg overflow-hidden rounded-lg mb-8">
        <div class="bg-gradient-to-r from-green-600 to-green-500 text-white py-3 px-6 flex items-center">
            <i class="fas fa-info-circle mr-2"></i>
            <span class="font-bold">플레이오프 진출 안내</span>
        </div>
        <div class="p-6">
            <div class="flex items-center space-x-2 mb-4">
                <span class="inline-block w-4 h-4 bg-blue-50 rounded"></span>
                <span class="text-sm text-gray-700">플레이오프 진출권 (상위 6개팀)</span>
            </div>
            <div class="w-full bg-gray-100 rounded-lg overflow-hidden">
                <div class="h-2 bg-blue-500 rounded-l-lg" style="width: 60%"></div>
            </div>
            <p class="mt-4 text-sm text-gray-600">
                현재 정규 시즌이 진행 중입니다. 상위 6개 팀이 플레이오프에 진출하게 됩니다.
                플레이오프 대진표는 정규 시즌 종료 후 확정됩니다.
            </p>
        </div>
    </div>

    <!-- 설명 섹션 -->
    <div class="bg-white shadow-lg overflow-hidden rounded-lg">
        <div class="bg-gradient-to-r from-purple-600 to-purple-500 text-white py-3 px-6 flex items-center">
            <i class="fas fa-question-circle mr-2"></i>
            <span class="font-bold">LCK 순위 결정 방식</span>
        </div>
        <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="flex items-start">
                    <div class="flex-shrink-0 h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                        <i class="fas fa-sync"></i>
                    </div>
                    <div class="ml-4">
                        <h3 class="text-lg font-medium text-gray-900">더블 라운드 로빈</h3>
                        <p class="mt-1 text-sm text-gray-500">정규 시즌은 더블 라운드 로빈 방식으로 진행됩니다. 각 팀은 다른 모든 팀과 2번씩, 총 18경기를 치릅니다.</p>
                    </div>
                </div>
                <div class="flex items-start">
                    <div class="flex-shrink-0 h-10 w-10 rounded-full bg-green-100 flex items-center justify-center text-green-600">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="ml-4">
                        <h3 class="text-lg font-medium text-gray-900">플레이오프 진출</h3>
                        <p class="mt-1 text-sm text-gray-500">상위 6개 팀이 플레이오프에 진출합니다. 1-2위 팀은 자동으로 플레이오프 2라운드에 진출합니다.</p>
                    </div>
                </div>
                <div class="flex items-start">
                    <div class="flex-shrink-0 h-10 w-10 rounded-full bg-yellow-100 flex items-center justify-center text-yellow-600">
                        <i class="fas fa-balance-scale"></i>
                    </div>
                    <div class="ml-4">
                        <h3 class="text-lg font-medium text-gray-900">동률 규정</h3>
                        <p class="mt-1 text-sm text-gray-500">동일한 승률일 경우, 상대 전적을 먼저 고려하고, 그 후에 경기 시간을 고려합니다.</p>
                    </div>
                </div>
                <div class="flex items-start">
                    <div class="flex-shrink-0 h-10 w-10 rounded-full bg-red-100 flex items-center justify-center text-red-600">
                        <i class="fas fa-trophy"></i>
                    </div>
                    <div class="ml-4">
                        <h3 class="text-lg font-medium text-gray-900">챔피언십 포인트</h3>
                        <p class="mt-1 text-sm text-gray-500">스프링과 서머 시즌의 성적에 따라 월드 챔피언십 출전 자격이 결정됩니다.</p>
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
</html>        <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
    <a href="/" class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
        <i class="fas fa-home mr-1"></i> 홈
    </a>
    <a href="/matches" class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
        <i class="fas fa-gamepad mr-1"></i> 경기 일정
    </a>
    <a href="/rankings" class="border-blue-500 text-gray-900 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
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