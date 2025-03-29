package com.example.predict_match.model.dto;

public record UserRankDTO(Long userId, String username, int point, double accuracy, int rank) {}
