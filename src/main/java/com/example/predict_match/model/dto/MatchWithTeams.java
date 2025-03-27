package com.example.predict_match.model.dto;

public record MatchWithTeams(
        Match match,
        Team team1,
        Team team2,
        PredictedMatch userPrediction
) {}