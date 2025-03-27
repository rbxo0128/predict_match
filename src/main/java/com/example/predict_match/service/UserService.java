package com.example.predict_match.service;

import com.example.predict_match.model.dto.SignUpRequest;
import com.example.predict_match.model.dto.User;
import com.example.predict_match.model.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.util.Optional;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public User registerNewUser(SignUpRequest signUpRequest) throws Exception {
        // 이메일 중복 체크
        if (userRepository.findByEmail(signUpRequest.email()).isPresent()) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }

        // 비밀번호 암호화
        String encodedPassword = passwordEncoder.encode(signUpRequest.password());

        // 유저 생성
        User newUser = new User(
                null,
                signUpRequest.username(),
                signUpRequest.email(),
                encodedPassword,
                "USER",
                0,
                true,
                null,
                null,
                null
        );

        return userRepository.save(newUser);
    }

    public Optional<User> authenticateUser(String email, String password) throws Exception {
        Optional<User> userOptional = userRepository.findByEmail(email);

        if (userOptional.isPresent()) {
            User user = userOptional.get();
            if (passwordEncoder.matches(password, user.password())) {
                // 로그인 성공 시 last_login 업데이트
                userRepository.updateLastLogin(user.userId());
                return userOptional;
            }
        }

        return Optional.empty();
    }
}