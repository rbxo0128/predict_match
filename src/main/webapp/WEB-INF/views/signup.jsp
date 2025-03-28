<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>LCK 예측 - 회원가입</title>
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

    .signup-image-container {
      display: none;
    }

    @media (min-width: 768px) {
      .signup-image-container {
        display: block;
        width: 50%;
        background: linear-gradient(135deg, rgba(10, 14, 19, 0.7) 0%, rgba(26, 33, 54, 0.7) 100%), url('https://images.contentstack.io/v3/assets/bltad9188aa9a70543a/blt77f17a28f5fa2e40/5e707272cb94665422c45593/lck-spring-2018.jpg');
        background-size: cover;
        background-position: center;
        padding: 48px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        color: white;
      }
    }

    .signup-container {
      min-height: 100vh;
      display: flex;
    }

    .signup-card {
      background-color: #101722;
      border: 1px solid #1a2136;
      border-radius: 12px;
      box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
      overflow: hidden;
      width: 100%;
      max-width: 420px;
    }

    .signup-header {
      background: linear-gradient(135deg, #0a1428 0%, #0a2354 100%);
      padding: 24px;
      text-align: center;
      border-bottom: 1px solid #1a2136;
    }

    .signup-header .logo {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 16px;
    }

    .signup-body {
      padding: 32px;
    }

    .form-group {
      margin-bottom: 24px;
    }

    .form-label {
      display: block;
      margin-bottom: 8px;
      font-weight: 500;
      color: #b0b8c8;
    }

    .form-input {
      width: 100%;
      background-color: #1a2136;
      border: 1px solid #2a3656;
      border-radius: 6px;
      padding: 12px 16px;
      color: white;
      transition: all 0.2s;
    }

    .form-input:focus {
      border-color: #0a6cff;
      box-shadow: 0 0 0 2px rgba(10, 108, 255, 0.2);
      outline: none;
    }

    .form-input-icon {
      position: relative;
    }

    .form-input-icon i {
      position: absolute;
      left: 16px;
      top: 50%;
      transform: translateY(-50%);
      color: #4e9fff;
    }

    .form-input-icon input {
      padding-left: 42px;
    }

    .form-checkbox {
      display: flex;
      align-items: center;
    }

    .form-checkbox input {
      width: 18px;
      height: 18px;
      margin-right: 8px;
      accent-color: #0a6cff;
    }

    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 12px 24px;
      border-radius: 6px;
      font-weight: 500;
      transition: all 0.2s;
      cursor: pointer;
      width: 100%;
    }

    .btn-blue {
      background: linear-gradient(135deg, #0050e0 0%, #003db5 100%);
      color: white;
      box-shadow: 0 2px 4px rgba(0, 65, 185, 0.3);
      border: none;
    }

    .btn-blue:hover {
      background: linear-gradient(135deg, #0046c7 0%, #00349b 100%);
      transform: translateY(-1px);
      box-shadow: 0 4px 8px rgba(0, 65, 185, 0.5);
    }

    .form-error {
      color: #ef4444;
      font-size: 0.875rem;
      margin-top: 4px;
    }

    .form-hint {
      color: #60a5fa;
      font-size: 0.75rem;
      margin-top: 4px;
    }

    .alert {
      padding: 12px;
      border-radius: 6px;
      margin-bottom: 20px;
      display: flex;
      align-items: center;
    }

    .alert-error {
      background-color: rgba(220, 38, 38, 0.1);
      border: 1px solid rgba(220, 38, 38, 0.2);
      color: #ef4444;
    }

    .alert i {
      margin-right: 8px;
      font-size: 1.25rem;
    }

    .link {
      color: #4e9fff;
      transition: color 0.2s;
    }

    .link:hover {
      color: #0a6cff;
      text-decoration: underline;
    }

    .signup-footer {
      text-align: center;
      margin-top: 24px;
    }

    /* Image side */
    .signup-image {
      position: relative;
      background: linear-gradient(135deg, rgba(10, 14, 19, 0.7) 0%, rgba(26, 33, 54, 0.7) 100%), url('https://images.contentstack.io/v3/assets/bltad9188aa9a70543a/blt77f17a28f5fa2e40/5e707272cb94665422c45593/lck-spring-2018.jpg');
      background-size: cover;
      background-position: center;
      padding: 48px;
      display: flex;
      flex-direction: column;
      justify-content: center;
      color: white;
      height: 100%;
    }

    .signup-image h2 {
      font-size: 2.5rem;
      font-weight: bold;
      margin-bottom: 24px;
    }

    .signup-image p {
      font-size: 1.25rem;
      margin-bottom: 32px;
      opacity: 0.9;
    }

    .feature-list {
      list-style: none;
      padding: 0;
      margin: 0;
    }

    .feature-list li {
      display: flex;
      align-items: flex-start;
      margin-bottom: 20px;
    }

    .feature-list li i {
      color: #4e9fff;
      margin-right: 12px;
      margin-top: 4px;
    }

    /* Animation */
    @keyframes pulse {
      0% { box-shadow: 0 0 0 0 rgba(10, 108, 255, 0.4); }
      70% { box-shadow: 0 0 0 10px rgba(10, 108, 255, 0); }
      100% { box-shadow: 0 0 0 0 rgba(10, 108, 255, 0); }
    }

    .animate-pulse {
      animation: pulse 2s infinite;
    }
  </style>
</head>
<body class="hexagon-bg">
<div class="signup-container">
  <!-- 왼쪽 이미지 섹션 -->
  <div class="signup-image-container">
    <div class="max-w-md">
      <h2 class="text-4xl font-bold mb-6">LCK 경기 예측</h2>
      <p class="text-xl mb-8">회원가입하고 즐겁게 예측에 참여하세요!</p>
      <ul class="feature-list">
        <li class="flex mb-5">
          <i class="fas fa-check-circle text-blue-400 mr-3 mt-1"></i>
          <p>무료 가입 후 바로 예측 시작</p>
        </li>
        <li class="flex mb-5">
          <i class="fas fa-check-circle text-blue-400 mr-3 mt-1"></i>
          <p>정확한 예측으로 포인트 획득</p>
        </li>
        <li class="flex mb-5">
          <i class="fas fa-check-circle text-blue-400 mr-3 mt-1"></i>
          <p>열정적인 e스포츠 팬들과 함께하세요</p>
        </li>
      </ul>
    </div>
  </div>

  <!-- 회원가입 폼 섹션 -->
  <div class="w-full md:w-1/2 flex items-center justify-center p-6">
    <div class="signup-card">
      <div class="signup-header">
        <a href="/" class="logo">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 mr-2 text-blue-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
          </svg>
          <span class="text-2xl font-bold text-white">LCK 예측</span>
        </a>
        <p class="text-gray-400 mt-2">새 계정을 만들고 경기 예측을 시작하세요</p>
      </div>

      <div class="signup-body">
        <!-- 알림 메시지 -->
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error">
          <i class="fas fa-exclamation-circle"></i>
          <p><%= request.getAttribute("error") %></p>
        </div>
        <% } %>

        <!-- 회원가입 폼 -->
        <form action="/signup" method="post">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

          <div class="form-group">
            <label for="username" class="form-label">사용자명</label>
            <div class="form-input-icon">
              <i class="fas fa-user"></i>
              <input type="text" id="username" name="username" required
                     class="form-input"
                     placeholder="닉네임 (3-50자)">
            </div>
            <% if (request.getAttribute("usernameError") != null) { %>
            <p class="form-error"><%= request.getAttribute("usernameError") %></p>
            <% } else { %>
            <p class="form-hint">다른 사용자에게 표시되는 이름입니다</p>
            <% } %>
          </div>

          <div class="form-group">
            <label for="email" class="form-label">이메일</label>
            <div class="form-input-icon">
              <i class="fas fa-envelope"></i>
              <input type="email" id="email" name="email" required
                     class="form-input"
                     placeholder="your@email.com">
            </div>
            <% if (request.getAttribute("emailError") != null) { %>
            <p class="form-error"><%= request.getAttribute("emailError") %></p>
            <% } else { %>
            <p class="form-hint">로그인 및 알림에 사용됩니다</p>
            <% } %>
          </div>

          <div class="form-group">
            <label for="password" class="form-label">비밀번호</label>
            <div class="form-input-icon">
              <i class="fas fa-lock"></i>
              <input type="password" id="password" name="password" required
                     class="form-input"
                     placeholder="••••••••">
            </div>
            <% if (request.getAttribute("passwordError") != null) { %>
            <p class="form-error"><%= request.getAttribute("passwordError") %></p>
            <% } else { %>
            <p class="form-hint">비밀번호는 최소 8자 이상이어야 합니다</p>
            <% } %>
          </div>

          <div class="form-checkbox mb-6">
            <input id="terms" name="terms" type="checkbox" required>
            <label for="terms" class="text-sm text-gray-400">
                  <span>
                    <a href="#" class="link">이용약관</a>과
                    <a href="#" class="link">개인정보처리방침</a>에 동의합니다
                  </span>
            </label>
          </div>

          <button type="submit" class="btn btn-blue animate-pulse">
            <i class="fas fa-user-plus mr-2"></i> 회원가입
          </button>
        </form>

        <!-- 로그인 링크 -->
        <div class="signup-footer">
          <p class="text-gray-400 mb-4">
            이미 계정이 있으신가요?
          </p>
          <a href="/login" class="link flex items-center justify-center">
            로그인하러 가기 <i class="fas fa-arrow-right ml-1"></i>
          </a>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- 비밀번호 유효성 검사 스크립트 -->
<script>
  document.addEventListener('DOMContentLoaded', function() {
    const passwordInput = document.getElementById('password');

    passwordInput.addEventListener('input', function() {
      const password = this.value;
      const minLength = 8;

      if (password.length < minLength) {
        this.setCustomValidity(`비밀번호는 최소 \${minLength}자 이상이어야 합니다.`);
      } else {
        this.setCustomValidity('');
      }
    });
  });
</script>
</body>
</html>