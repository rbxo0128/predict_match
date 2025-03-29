package com.example.predict_match.model.dto;

public record TeamStats(Team team, int wins, int losses, double winRate) {
    public int totalGames() {
        return wins + losses;
    }
}
