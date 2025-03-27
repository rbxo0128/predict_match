package com.example.predict_match.service;

import com.example.predict_match.model.dto.MatchWithTeams;
import com.example.predict_match.model.dto.Team;
import com.example.predict_match.model.dto.Match;
import com.example.predict_match.model.repository.MatchRepository;
import com.example.predict_match.model.repository.TeamRepository;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class MatchService {
    private final MatchRepository matchRepository;
    private final TeamRepository teamRepository;
    private List<Match> cachedMatches;
    private LocalDateTime lastFetchTime;
    private static final Duration CACHE_DURATION = Duration.ofMinutes(15);

    public MatchService(MatchRepository matchRepository, TeamRepository teamRepository) {
        this.matchRepository = matchRepository;
        this.teamRepository = teamRepository;
    }

    public List<Match> getAllMatches() throws Exception {
        LocalDateTime now = LocalDateTime.now();
        if (cachedMatches == null || lastFetchTime == null ||
                Duration.between(lastFetchTime, now).compareTo(CACHE_DURATION) > 0) {
            cachedMatches = matchRepository.check();
            lastFetchTime = now;
        }
        return cachedMatches;
    }

    public List<MatchWithTeams> getMatchesWithTeams() throws Exception {
        return matchRepository.getMatchwithTeams();
    }

    public Match getMatchById(int matchId) throws Exception {
        return matchRepository.findById(matchId);
    }


}
