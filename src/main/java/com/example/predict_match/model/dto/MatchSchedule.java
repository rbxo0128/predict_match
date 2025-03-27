package com.example.predict_match.model.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public record MatchSchedule(
        String groupName,
        List<Schedule> schedules
) {
    @JsonIgnoreProperties(ignoreUnknown = true)
    public record Schedule(
            String gameId,
            String winner,
            int homeScore,
            int awayScore,
            String matchStatus,
            Team homeTeam,
            Team awayTeam,
            String date,
            String time
    ) {}

    @JsonIgnoreProperties(ignoreUnknown = true)
    public record Team(
            String teamId,
            String name,
            String nameAcronym,
            String nameEng,
            String nameEngAcronym
    ) {}
}