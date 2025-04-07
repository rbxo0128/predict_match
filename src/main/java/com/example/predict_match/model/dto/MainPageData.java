package com.example.predict_match.model.dto;

import java.util.List;

public record MainPageData(
        List<MatchWithTeams> matches,
        boolean hasMatches,
        boolean isToday,
        String nextMatchDate,
        boolean loadError,
        List<Team> teams
) {
    // 기본 생성자 오버로드 (loadError가 기본적으로 false)
    public MainPageData(List<MatchWithTeams> matches, boolean hasMatches, boolean isToday, String nextMatchDate, List<Team> teams) {
        this(matches, hasMatches, isToday, nextMatchDate, false, teams);
    }
}
