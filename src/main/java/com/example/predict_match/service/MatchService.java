package com.example.predict_match.service;

import com.example.predict_match.model.dto.MatchWithTeams;
import com.example.predict_match.model.dto.Team;
import com.example.predict_match.model.dto.Match;
import com.example.predict_match.model.repository.MatchRepository;
import com.example.predict_match.model.repository.TeamRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class MatchService {
    private final MatchRepository matchRepository;
    private final TeamRepository teamRepository;

    public MatchService(MatchRepository matchRepository, TeamRepository teamRepository) {
        this.matchRepository = matchRepository;
        this.teamRepository = teamRepository;
    }

    public List<Match> getAllMatches() throws Exception {
        return matchRepository.check();
    }

    public List<MatchWithTeams> getMatchesWithTeams() throws Exception {
        List<Match> matches = matchRepository.check();
        List<Team> allTeams = teamRepository.findAll();
        Map<Integer, Team> teamMap = allTeams.stream()
                .collect(Collectors.toMap(Team::teamId, team -> team));

        // 경기와 팀 정보 결합
        List<MatchWithTeams> matchesWithTeams = new ArrayList<>();
        for (Match match : matches) {
            Team team1 = teamMap.get(match.team1_id());
            Team team2 = teamMap.get(match.team2_id());

            if (team1 != null && team2 != null) {
                matchesWithTeams.add(new MatchWithTeams(match, team1, team2, null));
            }
        }
        System.out.println("matchesWithTeams = " + matchesWithTeams);
        return matchesWithTeams;
    }

    public Match getMatchById(int matchId) throws Exception {
        List<Match> matches = matchRepository.findAll();
        return matches.stream()
                .filter(match -> match.match_id() == matchId)
                .findFirst()
                .orElse(null);
    }
}
