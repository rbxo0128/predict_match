<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>LCK 예측 - 로그인</title>
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
    .login-image-container {
      display: none;
    }

    @media (min-width: 768px) {
      .login-image-container {
        display: block;
        width: 50%;
        background: linear-gradient(135deg, rgba(10, 14, 19, 0.7) 0%, rgba(26, 33, 54, 0.7) 100%), url('https://images.contentstack.io/v3/assets/bltad9188aa9a70543a/blt711d7b66ed0d5efb/5e70728fc7e156403cf09bf2/lck-og-image-2020.jpg');
        background-size: cover;
        background-position: center;
        padding: 48px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        color: white;
      }
    }

    .login-container {
      min-height: 100vh;
      display: flex;
      /*align-items: center;*/
      /*justify-content: center;*/
    }

    .login-card {
      background-color: #101722;
      border: 1px solid #1a2136;
      border-radius: 12px;
      box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
      overflow: hidden;
      width: 100%;
      max-width: 420px;
    }

    .login-header {
      background: linear-gradient(135deg, #0a1428 0%, #0a2354 100%);
      padding: 24px;
      text-align: center;
      border-bottom: 1px solid #1a2136;
    }

    .login-header .logo {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 16px;
    }

    .login-body {
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

    .alert-success {
      background-color: rgba(4, 120, 87, 0.1);
      border: 1px solid rgba(4, 120, 87, 0.2);
      color: #10b981;
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

    .login-footer {
      text-align: center;
      margin-top: 24px;
    }

    .divider {
      display: flex;
      align-items: center;
      margin: 24px 0;
      color: #4a5568;
    }

    .divider::before,
    .divider::after {
      content: "";
      flex: 1;
      height: 1px;
      background-color: #2d3748;
    }

    .divider span {
      padding: 0 12px;
    }

    /* Image side */
    .login-image {
      position: relative;
      background: linear-gradient(135deg, rgba(10, 14, 19, 0.7) 0%, rgba(26, 33, 54, 0.7) 100%), url('https://images.contentstack.io/v3/assets/bltad9188aa9a70543a/blt711d7b66ed0d5efb/5e70728fc7e156403cf09bf2/lck-og-image-2020.jpg');
      background-size: cover;
      background-position: center;
      padding: 48px;
      display: flex;
      flex-direction: column;
      justify-content: center;
      color: white;
      height: 100%;
    }

    .login-image h2 {
      font-size: 2.5rem;
      font-weight: bold;
      margin-bottom: 24px;
    }

    .login-image p {
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
<div class="login-container">
  <!-- 왼쪽 이미지 섹션 -->
  <div class="login-image-container">
    <div class="max-w-md">
      <h2 class="text-4xl font-bold mb-6">LCK 경기 예측</h2>
      <p class="text-xl mb-8">승부를 예측하고 포인트를 획득하세요!</p>
      <ul class="feature-list">
        <li class="flex mb-5">
          <i class="fas fa-check-circle text-blue-400 mr-3 mt-1"></i>
          <p>실시간으로 업데이트되는 LCK 경기 일정을 확인하세요</p>
        </li>
        <li class="flex mb-5">
          <i class="fas fa-check-circle text-blue-400 mr-3 mt-1"></i>
          <p>정확한 예측으로 포인트를 획득하고 순위에 도전하세요</p>
        </li>
        <li class="flex mb-5">
          <i class="fas fa-check-circle text-blue-400 mr-3 mt-1"></i>
          <p>다른 팬들과 함께 e스포츠의 열기를 느껴보세요</p>
        </li>
      </ul>
    </div>
  </div>

  <!-- 로그인 폼 섹션 -->
  <div class="w-full md:w-1/2 flex items-center justify-center p-6">
    <div class="login-card">
      <div class="login-header">
        <a href="/" class="logo">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 mr-2 text-blue-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
          </svg>
          <span class="text-2xl font-bold text-white">LCK 예측</span>
        </a>
        <p class="text-gray-400 mt-2">계정에 로그인하고 경기 예측을 시작하세요</p>
      </div>

      <div class="login-body">
        <!-- 알림 메시지 -->
        <c:if test="${param.error != null}">
          <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <p>잘못된 이메일 또는 비밀번호입니다.</p>
          </div>
        </c:if>

        <c:if test="${param.logout != null}">
          <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <p>성공적으로 로그아웃되었습니다.</p>
          </div>
        </c:if>

        <c:if test="${param.signup != null}">
          <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <p>회원가입이 성공적으로 완료되었습니다. 로그인해주세요.</p>
          </div>
        </c:if>

        <!-- 로그인 폼 -->
        <form action="${pageContext.request.contextPath}/login-process" method="post">
          <sec:csrfInput />

          <div class="form-group">
            <label for="username" class="form-label">이메일</label>
            <div class="form-input-icon">
              <i class="fas fa-envelope"></i>
              <input id="username" name="username" type="email" required
                     class="form-input"
                     placeholder="your@email.com">
            </div>
          </div>

          <div class="form-group">
            <label for="password" class="form-label">비밀번호</label>
            <div class="form-input-icon">
              <i class="fas fa-lock"></i>
              <input id="password" name="password" type="password" required
                     class="form-input"
                     placeholder="••••••••">
            </div>
          </div>

          <div class="flex items-center justify-between mb-6">
            <div class="form-checkbox">
              <input id="remember-me" name="remember-me" type="checkbox">
              <label for="remember-me" class="text-sm text-gray-400">
                로그인 상태 유지
              </label>
            </div>
            <div class="text-sm">
              <a href="/forgot-password" class="link">
                비밀번호를 잊으셨나요?
              </a>
            </div>
          </div>

          <button type="submit" class="btn btn-blue animate-pulse">
            <i class="fas fa-sign-in-alt mr-2"></i> 로그인
          </button>
        </form>

        <div class="divider">
          <span>또는</span>
        </div>

        <!-- 회원가입 링크 -->
        <div class="login-footer">
        <div class="login-footer">
          <p class="text-gray-400 mb-4">
            계정이 없으신가요?
          </p>
          <a href="/signup" class="link flex items-center justify-center">
            회원가입하러 가기 <i class="fas fa-arrow-right ml-1"></i>
          </a>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>