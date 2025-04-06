package com.example.predict_match.service;

import com.example.predict_match.model.dto.*;
import com.example.predict_match.model.repository.MatchRepository;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class MatchService {
    private final MatchRepository matchRepository;
    private final UserService userService;
    private final PredictionService predictionService;

    private List<Match> cachedMatches;
    private LocalDateTime lastFetchTime;
    private static final Duration CACHE_DURATION = Duration.ofMinutes(15);

    public MatchService(MatchRepository matchRepository,
                        UserService userService, PredictionService predictionService) {
        this.matchRepository = matchRepository;
        this.userService = userService;
        this.predictionService = predictionService;
    }

    public List<Match> getAllMatches() throws Exception {
        LocalDateTime now = LocalDateTime.now();
        if (cachedMatches == null || lastFetchTime == null ||
                Duration.between(lastFetchTime, now).compareTo(CACHE_DURATION) > 0) {
            cachedMatches = matchRepository.findAll();
            lastFetchTime = now;
        }
        return cachedMatches;
    }

    public List<MatchWithTeams> getMatchesWithTeams() {
        return matchRepository.getMatchwithTeams();
    }

    public Match getMatchById(int matchId) throws Exception {
        return matchRepository.findById(matchId);
    }

    /**
     * 사용자의 예측 정보가 포함된 경기 목록을 반환합니다.
     */
    public List<MatchWithTeams> getMatchesWithUserPredictions(Authentication authentication) throws Exception {
        List<MatchWithTeams> matchesWithTeams = getMatchesWithTeams();

        // 로그인한 사용자가 있으면 예측 정보를 가져옴
        if (authentication != null && authentication.isAuthenticated()) {
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            Optional<User> userOptional = userService.findByEmail(userDetails.getUsername());

            if (userOptional.isPresent()) {
                User user = userOptional.get();
                List<PredictedMatch> userPredictions = predictionService.getUserPredictions(user.userId());

                // 각 경기에 사용자의 예측 정보 추가
                List<MatchWithTeams> matchesWithPredictions = new ArrayList<>();
                for (MatchWithTeams match : matchesWithTeams) {
                    PredictedMatch prediction = userPredictions.stream()
                            .filter(p -> p.matchId() == match.match().match_id())
                            .findFirst()
                            .orElse(null);

                    matchesWithPredictions.add(new MatchWithTeams(
                            match.match(), match.team1(), match.team2(), prediction
                    ));
                }

                return matchesWithPredictions;
            }
        }

        return matchesWithTeams;
    }
}
