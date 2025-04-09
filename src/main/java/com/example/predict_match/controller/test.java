package com.example.predict_match.controller;

import com.example.predict_match.model.repository.*;
import com.example.predict_match.service.ScheduleService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class test {
    public static void main(String[] args) throws Exception {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);

        // 새 비밀번호 인코딩
        String newPassword = "yeeyeeyee"; // 여기에 새 비밀번호 입력
        String encodedPassword = encoder.encode(newPassword);

        System.out.println("인코딩된 비밀번호: " + encodedPassword);
    }
}
