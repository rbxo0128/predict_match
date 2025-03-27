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
                    <a href="/matches" class="border-blue-500 text-gray-900 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
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
        <h1 class="text-3xl font-bold text-gray-900">LCK 경기 일정</h1>
    </div>

    <!-- 알림 메시지 -->
    <c:if test="${not empty error}">
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
            <span class="block sm:inline">${error}</span>
        </div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4" role="alert">
            <span class="block sm:inline">${success}</span>
        </div>
    </c:if>

    <!-- 경기 목록 -->
    <div class="bg-white shadow overflow-hidden rounded-lg">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
            <tr>
                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">경기 일시</th>
                <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">팀1</th>
                <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">VS</th>
                <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">팀2</th>
                <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">결과</th>
                <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">내 예측</th>
            </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
            <c:forEach var="match" items="${matches}">
                <tr>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            ${match.match().match_date()}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="flex items-center justify-center">
                            <span class="text-sm font-medium text-gray-900">${match.team1().teamName()}</span>
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-center text-sm text-gray-900 font-bold">
                        <c:choose>
                            <c:when test="${match.match().is_finished() == 1}">
                                ${match.match().team1_score()} : ${match.match().team2_score()}
                            </c:when>
                            <c:otherwise>
                                VS
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="flex items-center justify-center">
                            <span class="text-sm font-medium text-gray-900">${match.team2().teamName()}</span>
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-center text-sm">
                        <c:choose>
                            <c:when test="${match.match().is_finished() == 1}">
                                <c:choose>
                                    <c:when test="${match.match().winner_id() == match.team1().teamId()}">
                                                <span class="px-2 py-1 rounded-full bg-blue-100 text-blue-800 font-medium">
                                                    ${match.team1().teamName()} 승리
                                                </span>
                                    </c:when>
                                    <c:when test="${match.match().winner_id() == match.team2().teamId()}">
                                                <span class="px-2 py-1 rounded-full bg-blue-100 text-blue-800 font-medium">
                                                    ${match.team2().teamName()} 승리
                                                </span>
                                    </c:when>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                        <span class="px-2 py-1 rounded-full bg-gray-100 text-gray-800">
                                            경기 예정
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
                                                            <span class="${match.userPrediction().predictedWinnerId() == match.match().winner_id() ? 'text-green-600 font-bold' : 'text-red-600'}">
                                                                ${match.team1().teamName()} 예측
                                                                <c:if test="${match.userPrediction().predictedWinnerId() == match.match().winner_id()}">✓</c:if>
                                                                <c:if test="${match.userPrediction().predictedWinnerId() != match.match().winner_id()}">✗</c:if>
                                                            </span>
                                                </c:when>
                                                <c:otherwise>
                                                            <span class="${match.userPrediction().predictedWinnerId() == match.match().winner_id() ? 'text-green-600 font-bold' : 'text-red-600'}">
                                                                ${match.team2().teamName()} 예측
                                                                <c:if test="${match.userPrediction().predictedWinnerId() == match.match().winner_id()}">✓</c:if>
                                                                <c:if test="${match.userPrediction().predictedWinnerId() != match.match().winner_id()}">✗</c:if>
                                                            </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-gray-500">예측 없음</span>
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
                                            <button type="submit" class="${match.userPrediction() != null && match.userPrediction().predictedWinnerId() == match.team1().teamId() ? 'bg-blue-500 text-white' : 'bg-gray-200 text-gray-800'} px-3 py-1 rounded text-xs font-medium">
                                                    ${match.team1().teamName()}
                                            </button>
                                        </form>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </sec:authorize>
                        <sec:authorize access="isAnonymous()">
                            <a href="/login" class="text-blue-600 hover:text-blue-800 text-sm">로그인하여 예측</a>
                        </sec:authorize>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- 규칙 섹션 -->
    <div class="mt-8 bg-white shadow overflow-hidden rounded-lg p-6">
        <h2 class="text-xl font-bold text-gray-900 mb-4">예측 규칙</h2>
        <ul class="list-disc pl-5 space-y-2 text-gray-700">
            <li>경기 시작 전까지 예측을 변경할 수 있습니다.</li>
            <li>정확한 예측 시 10 포인트를 획득합니다.</li>
            <li>경기가 종료된 후에는 예측을 변경할 수 없습니다.</li>
            <li>획득한 포인트는 사이트 내 다양한 혜택으로 교환할 수 있습니다.</li>
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
</html></form>
<form action="${pageContext.request.contextPath}/
matches/predict" method="post" class="inline">
    <sec:csrfInput />
    <input type="hidden" name="matchId" value="${match.match().match_id()}">
    <input type="hidden" name="teamId" value="${match.team2().teamId()}">
    <button type="submit" class="${match.userPrediction() != null && match.userPrediction().predictedWinnerId() == match.team2().teamId() ? 'bg-blue-500 text-white' : 'bg-gray-200 text-gray-800'} px-3 py-1 rounded text-xs font-medium">
        ${match.team2().teamName()}
    </button>