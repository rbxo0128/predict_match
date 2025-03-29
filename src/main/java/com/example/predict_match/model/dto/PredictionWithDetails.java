package com.example.predict_match.model.dto;

public record PredictionWithDetails(
        PredictedMatch prediction,
        Match match,
        Team team1,
        Team team2,
        Team predictedTeam,
        boolean isCorrect
) {}
