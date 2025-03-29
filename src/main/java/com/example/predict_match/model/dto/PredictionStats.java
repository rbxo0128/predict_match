package com.example.predict_match.model.dto;

public record PredictionStats(
        int correctPredictions,
        int totalFinishedMatches,
        double accuracyPercentage
) {}
