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
                    <a href="/rankings" class="border-blue-500 text-gray-900 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                        순위표
                    </a>
                    <a href="/predictions" class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                        내 예측
                    </a>
                </div>
            </div>
            <div class="flex items-center">
                <sec:authorize access="isAuthenticated()">
                        <span class="text-sm text-gray-700 mr-4">
                            <sec:authentication property="principal.username" /> 님
                            <span class="ml-1 text-blue-600 font-medium">
                                0 P
                            </span>
                        </span>
                    <a href="/logout" class="text-sm text-gray-700 hover:text-gray-900 font-medium">로그아웃</a>
                </sec:authorize>
                <sec:authorize access="isAnonymous()">
                    <a href="/login" class="text-gray-700 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">로그인</a>
                    <a href="/signup" class="bg-blue-600 text-white hover:bg-blue-700 px-3 py-2 rounded-md text-sm font-medium ml-3">회원가입</a>
                </sec:authorize>
            </div>
        </div>
    </div>
</nav>

<!-- 메인 컨텐츠 -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <div class="flex justify-between items-center mb-8">
        <h1 class="text-3xl font-bold text-gray-900">LCK 2025 팀 순위</h1>
    </div>

    <!-- 팀 순위 테이블 -->
    <div class="bg-white shadow overflow-hidden rounded-lg">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
            <tr>
                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">순위</th>
                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">팀명</th>
                <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">승/패</th>
                <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">승률</th>
            </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
            <c:forEach var="stats" items="${teamStats}" varStatus="status">
                <tr class="${status.index < 3 ? 'bg-blue-50' : ''}">
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm font-medium text-gray-900">${status.index + 1}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm font-medium text-gray-900">${stats.team().teamName()}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-center">
                        <div class="text-sm text-gray-900">${stats.wins()}승 ${stats.losses()}패</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-center">
                        <div class="text-sm text-gray-900">
                            <fmt:formatNumber value="${stats.winRate()}" pattern="#0.0" />%
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- 설명 섹션 -->
    <div class="mt-8 bg-white shadow overflow-hidden rounded-lg p-6">
        <h2 class="text-xl font-bold text-gray-900 mb-4">LCK 순위 결정 방식</h2>
        <ul class="list-disc pl-5 space-y-2 text-gray-700">
            <li>정규 시즌은 더블 라운드 로빈 방식으로 진행됩니다.</li>
            <li>각 팀은 다른 모든 팀과 2번씩, 총 18경기를 치릅니다.</li>
            <li>상위 6개 팀이 플레이오프에 진출합니다.</li>
            <li>동일한 승률일 경우, 상대 전적을 먼저 고려하고, 그 후에 경기 시간을 고려합니다.</li>
        </ul>
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