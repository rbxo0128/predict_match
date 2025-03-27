package com.example.predict_match.model.dto;

import java.time.LocalDateTime;

public record PredictedMatch(
        Long id,
        Long userId,
        int matchId,
        int predictedWinnerId,
        Boolean isCorrect,
        LocalDateTime createdAt
) {}
