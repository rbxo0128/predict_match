package com.example.predict_match.model.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public record Match(int match_id, int team1_id, int team2_id, String match_date, int team1_score, int team2_score, int is_finished, int winner_id) {
}
