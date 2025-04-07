package com.example.predict_match.model.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public record Team(
        int teamId,
        String teamName,
        int teamRank,
        int wins,
        int loses,
        int score
) {}
