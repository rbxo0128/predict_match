package com.example.predict_match.model.dto;

import java.time.LocalDateTime;

public record User(
        Long userId,
        String username,
        String email,
        String password,
        String role,
        Integer point,
        Boolean isActive,
        LocalDateTime lastLogin,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {}