package com.example.predict_match.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

@Configuration
// 본인의 패키지명 중에 가장 좁히는 범위
@ComponentScan(basePackages = "com.example.predict_match")
@EnableScheduling
public class AppConfig {
    // 빈(Bean)
    // @ <- 이걸로 처리해서 우리가 직접 넣어주는 경우는 많지 않음
}
