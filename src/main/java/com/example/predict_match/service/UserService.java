package com.example.predict_match.service;

import com.example.predict_match.model.dto.SignUpRequest;
import com.example.predict_match.model.dto.User;
import com.example.predict_match.model.dto.UserRankDTO;
import com.example.predict_match.model.repository.UserRepository;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.util.List;
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
        if (findByEmail(signUpRequest.email()).isPresent()) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }

        if (findByUsername(signUpRequest.username()).isPresent()) {
            throw new IllegalArgumentException("이미 사용 중인 사용자명입니다.");
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

    public Optional<User> findByUsername(String username) throws Exception {
        return userRepository.findByUsername(username);
    }

    public Optional<User> findByEmail(String email) throws Exception {
        return userRepository.findByEmail(email);
    }

    public List<UserRankDTO> getTopUsers(int limit) throws Exception {
        return userRepository.findTopUsersByPoints(limit);
    }

    public UserRankDTO getUserRank(Long userId) throws Exception {
        return userRepository.findUserRankById(userId);
    }

    public void updatePassword(String email, String newPassword) throws Exception {
        // 비밀번호 암호화
        String encodedPassword = passwordEncoder.encode(newPassword);
        userRepository.updatePassword(email, encodedPassword);
    }
}