package com.example.predict_match.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

@Configuration
@ComponentScan(basePackages = "com.example.predict_match")
//@EnableScheduling 무료 사이트 배포라 아직 비활성화 대신 github actions로 할 예정
public class AppConfig {

}
