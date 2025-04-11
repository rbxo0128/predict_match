<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LCK 예측 - 비밀번호 재설정</title>
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

        .container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .card {
            background-color: #101722;
            border: 1px solid #1a2136;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            width: 100%;
            max-width: 420px;
        }

        .card-header {
            background: linear-gradient(135deg, #0a1428 0%, #0a2354 100%);
            padding: 24px;
            text-align: center;
            border-bottom: 1px solid #1a2136;
        }

        .card-header .logo {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
        }

        .card-body {
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

        .alert i {
            margin-right: 8px;
            font-size: 1.25rem;
        }

        .form-hint {
            color: #60a5fa;
            font-size: 0.75rem;
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

        .password-strength {
            height: 5px;
            border-radius: 5px;
            margin-top: 8px;
            transition: all 0.3s;
        }

        .password-strength-weak {
            background-color: #ef4444;
            width: 33.33%;
        }

        .password-strength-medium {
            background-color: #f59e0b;
            width: 66.66%;
        }

        .password-strength-strong {
            background-color: #10b981;
            width: 100%;
        }
    </style>
</head>
<body class="hexagon-bg">
<div class="container">
    <div class="card">
        <div class="card-header">
            <a href="/" class="logo">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 mr-2 text-blue-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                </svg>
                <span class="text-2xl font-bold text-white">LCK 예측</span>
            </a>
            <p class="text-gray-400 mt-2">비밀번호 재설정</p>
        </div>

        <div class="card-body">
            <!-- 알림 메시지 -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <p>${error}</p>
                </div>
            </c:if>

            <!-- 폼 -->
            <form action="/reset-password" method="post" id="resetPasswordForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <input type="hidden" name="email" value="${email}"/>

                <div class="form-group">
                    <label for="password" class="form-label">새 비밀번호</label>
                    <div class="form-input-icon">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="password" name="password" required
                               class="form-input"
                               placeholder="••••••••" minlength="8">
                    </div>
                    <p class="form-hint">비밀번호는 최소 8자 이상이어야 합니다</p>
                    <div id="passwordStrength" class="password-strength"></div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword" class="form-label">비밀번호 확인</label>
                    <div class="form-input-icon">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="confirmPassword" required
                               class="form-input"
                               placeholder="••••••••">
                    </div>
                    <p id="passwordMatch" class="form-hint"></p>
                </div>

                <button type="submit" class="btn btn-blue animate-pulse" id="submitButton">
                    <i class="fas fa-check mr-2"></i> 비밀번호 재설정
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const passwordInput = document.getElementById('password');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const passwordStrength = document.getElementById('passwordStrength');
        const passwordMatch = document.getElementById('passwordMatch');
        const submitButton = document.getElementById('submitButton');
        const form = document.getElementById('resetPasswordForm');

        // 비밀번호 강도 검사
        passwordInput.addEventListener('input', function() {
            const password = this.value;

            // 비밀번호 강도 계산
            let strength = 0;
            if (password.length >= 8) strength += 1;
            if (password.match(/[a-z]/) && password.match(/[A-Z]/)) strength += 1;
            if (password.match(/\d/)) strength += 1;
            if (password.match(/[^a-zA-Z\d]/)) strength += 1;

            // 강도에 따른 시각적 표시
            passwordStrength.className = 'password-strength';
            if (password.length === 0) {
                passwordStrength.style.width = '0';
            } else if (strength < 2) {
                passwordStrength.classList.add('password-strength-weak');
            } else if (strength < 3) {
                passwordStrength.classList.add('password-strength-medium');
            } else {
                passwordStrength.classList.add('password-strength-strong');
            }

            checkPasswordsMatch();
        });

        // 비밀번호 일치 검사
        confirmPasswordInput.addEventListener('input', checkPasswordsMatch);

        function checkPasswordsMatch() {
            const password = passwordInput.value;
            const confirmPassword = confirmPasswordInput.value;

            if (confirmPassword.length === 0) {
                passwordMatch.textContent = '';
                return;
            }

            if (password === confirmPassword) {
                passwordMatch.textContent = '비밀번호가 일치합니다';
                passwordMatch.style.color = '#10b981';
                submitButton.disabled = false;
            } else {
                passwordMatch.textContent = '비밀번호가 일치하지 않습니다';
                passwordMatch.style.color = '#ef4444';
                submitButton.disabled = true;
            }
        }

        // 폼 제출 검증
        form.addEventListener('submit', function(e) {
            const password = passwordInput.value;
            const confirmPassword = confirmPasswordInput.value;

            if (password.length < 8) {
                e.preventDefault();
                alert('비밀번호는 최소 8자 이상이어야 합니다.');
                return;
            }

            if (password !== confirmPassword) {
                e.preventDefault();
                alert('비밀번호가 일치하지 않습니다.');
                return;
            }
        });
    });
</script>
</body>
</html>