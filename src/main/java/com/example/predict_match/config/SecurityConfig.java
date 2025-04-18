package com.example.predict_match.config;

import com.example.predict_match.model.dto.User;
import com.example.predict_match.model.repository.UserRepository;
import com.example.predict_match.service.UserService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.HeadersConfigurer;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import java.util.Collection;
import java.util.Collections;
import java.util.Optional;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http, UserRepository userRepository) throws Exception {
        http
                .csrf(csrf -> csrf.csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse()))
                .authorizeHttpRequests(authz -> authz
                        .requestMatchers("/", "/login", "/login-process", "/signup", "rankings", "/ws-chat/**","/api/chat/recent", "/matches","forgot-password","reset-password","/api/update-matches", "/images/**", "/asset/**").permitAll()
                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        .anyRequest().authenticated()
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/login-process") // 다른 URL 사용
                        .usernameParameter("username")
                        .passwordParameter("password")
                        .defaultSuccessUrl("/", true)
                        .successHandler((request, response, authentication) -> {
                            // 사용자 ID 가져오기
                            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
                            Long userId = userDetails.getUserId();

                            try {
                                // 마지막 로그인 시간 업데이트
                                userRepository.updateLastLogin(userId);
                            } catch (Exception e) {
                                // 예외 처리
                                e.printStackTrace();
                            }

                            // 기본 URL로 리다이렉트
                            response.sendRedirect("/");
                        })
                        .failureUrl("/login?error=true")
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                        .logoutSuccessUrl("/login?logout=true")
                        .invalidateHttpSession(true)
                        .deleteCookies("JSESSIONID")
                        .permitAll()
                )
                .exceptionHandling(ex -> ex
                        .accessDeniedPage("/access-denied")
                );

        return http.build();
    }

    @Bean
    public UserDetailsService userDetailsService(UserService userService) {
        return username -> {
            try {
                Optional<User> userOptional = userService.findByEmail(username);
                if (userOptional.isEmpty()) {
                    throw new UsernameNotFoundException("User not found with email: " + username);
                }

                User user = userOptional.get();
                Collection<SimpleGrantedAuthority> authorities = Collections.singletonList(
                        new SimpleGrantedAuthority("ROLE_" + user.role())
                );

                return new CustomUserDetails(
                        user.email(),
                        user.password(),
                        user.username(),  // 실제 사용자 이름
                        user.userId(),
                        user.point(),
                        authorities,
                        user.isActive()
                );
            } catch (Exception e) {
                throw new RuntimeException("Error loading user", e);
            }
        };
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }
}