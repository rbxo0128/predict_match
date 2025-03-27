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
          <a href="/rankings" class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
            순위표
          </a>
          <a href="/predictions" class="border-blue-500 text-gray-900 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
            내 예측
          </a>
        </div>
      </div>
      <div class="flex items-center">
        <sec:authorize access="isAuthenticated()">
                        <span class="text-sm text-gray-700 mr-4">
                            <sec:authentication property="principal.username" /> 님
                            <span class="ml-1 text-blue-600 font-medium">
                                ${user.point()} P
                            </span>
                        </span>
          <a href="/logout" class="text-sm text-gray-700 hover:text-gray-900 font-medium">로그아웃</a>
        </sec:authorize>
      </div>
    </div>
  </div>
</nav>

<!-- 메인 컨텐츠 -->
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
  <div class="flex justify-between items-center mb-8">
    <h1 class="text-3xl font-bold text-gray-900">내 예측 기록</h1>
  </div>

  <!-- 예측 통계 -->
  <div class="bg-white shadow overflow-hidden rounded-lg mb-8">
    <div class="p-6">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div class="bg-blue-50 p-4 rounded-lg text-center">
          <h3 class="text-lg font-medium text-gray-900">총 예측</h3>
          <p class="text-3xl font-bold text-blue-600">${predictions.size()}</p>
        </div>
        <div class="bg-green-50 p-4 rounded-lg text-center">
          <h3 class="text-lg font-medium text-gray-900">정확한 예측</h3>
          <p class="text-3xl font-bold text-green-600">${correctPredictions} / ${totalFinishedMatches}</p>
        </div>
        <div class="bg-purple-50 p-4 rounded-lg text-center">
          <h3 class="text-lg font-medium text-gray-900">정확도</h3>
          <p class="text-3xl font-bold text-purple-600">
            <fmt:formatNumber value="${accuracyPercentage}" pattern="#0.0" />%
          </p>
        </div>
      </div>
    </div>
  </div>

  <!-- 예측 목록 -->
  <div class="bg-white shadow overflow-hidden rounded-lg">
    <c:choose>
      <c:when test="${empty predictions}">
        <div class="p-6 text-center text-gray-500">
          <p>아직 예측한 경기가 없습니다.</p>
          <a href="/matches" class="mt-4 inline-block bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 text-sm font-medium">경기 예측하러 가기</a>
        </div>
      </c:when>
      <c:otherwise>
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
          <tr>
            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">경기 일시</th>
            <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">매치업</th>
            <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">내 예측</th>
            <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">결과</th>
            <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">상태</th>
          </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
          <c:forEach var="pred" items="${predictions}">
            <tr>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  ${pred.match().match_date()}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-center">
                <div class="flex items-center justify-center space-x-2">
                  <span class="text-sm font-medium text-gray-900">${pred.team1().teamName()}</span>
                  <span class="text-sm text-gray-500">vs</span>
                  <span class="text-sm font-medium text-gray-900">${pred.team2().teamName()}</span>
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-center">
                                        <span class="px-2 py-1 rounded-full ${pred.isCorrect() ? 'bg-green-100 text-green-800' : pred.match().is_finished() == 1 ? 'bg-red-100 text-red-800' : 'bg-blue-100 text-blue-800'} font-medium">
                                            ${pred.predictedTeam().teamName()}
                                        </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-center">
                <c:choose>
                  <c:when test="${pred.match().is_finished() == 1}">
                    <c:choose>
                      <c:when test="${pred.match().winner_id() == pred.team1().teamId()}">
                        ${pred.team1().teamName()} 승리
                      </c:when>
                      <c:when test="${pred.match().winner_id() == pred.team2().teamId()}">
                        ${pred.team2().teamName()} 승리
                      </c:when>
                    </c:choose>
                  </c:when>
                  <c:otherwise>
                    <span class="text-gray-500">경기 예정</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-center">
                <c:choose>
                  <c:when test="${pred.match().is_finished() == 0}">
                                                <span class="px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs font-medium">
                                                    진행중
                                                </span>
                  </c:when>
                  <c:otherwise>
                    <c:choose>
                      <c:when test="${pred.isCorrect()}">
                                                        <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs font-medium">
                                                            정확 (+10P)
                                                        </span>
                      </c:when>
                      <c:otherwise>
                                                        <span class="px-2 py-1 bg-red-100 text-red-800 rounded-full text-xs font-medium">
                                                            오답
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
      </c:otherwise>
    </c:choose>
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