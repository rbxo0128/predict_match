package com.example.predict_match.service;

import com.example.predict_match.model.dto.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@Service
public class UserPredictionService {
    private static final Logger logger = Logger.getLogger(UserPredictionService.class.getName());

    private final PredictionService predictionService;
    private final UserService userService;
    private final MatchService matchService;
    private final TeamService teamService;

    public UserPredictionService(PredictionService predictionService, UserService userService,
                                 MatchService matchService, TeamService teamService) {
        this.predictionService = predictionService;
        this.userService = userService;
        this.matchService = matchService;
        this.teamService = teamService;
    }

    /**
     * 사용자 예측 정보를 포함한 모델을 준비합니다.
     */
    public void prepareUserPredictionsModel(Model model, Authentication authentication) throws Exception {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        Optional<User> userOptional = userService.findByEmail(userDetails.getUsername());

        if (userOptional.isEmpty()) {
            logger.warning("User not found for email: " + userDetails.getUsername());
            model.addAttribute("error", "사용자 정보를 찾을 수 없습니다.");
            return;
        }

        User user = userOptional.get();

        // 사용자 예측 정보 가져오기
        List<PredictedMatch> predictions = predictionService.getUserPredictions(user.userId());

        // 데이터 조회를 위한 모든 매치와 팀 정보 가져오기
        List<Match> allMatches = matchService.getAllMatches();
        List<Team> allTeams = teamService.getAllTeams();

        // 쉬운 조회를 위한 맵 생성
        Map<Integer, Match> matchMap = createMatchMap(allMatches);
        Map<Integer, Team> teamMap = createTeamMap(allTeams);

        // 예측 상세 정보 목록 생성
        List<PredictionWithDetails> predictionsWithDetails = createPredictionDetails(
                predictions, matchMap, teamMap);

        // 예측 정확도 계산
        PredictionStats stats = calculatePredictionStats(predictionsWithDetails);

        // 모델에 데이터 추가
        populateModel(model, user, predictionsWithDetails, stats);
    }

    /**
     * 매치 ID로 빠르게 조회할 수 있는 맵 생성
     */
    private Map<Integer, Match> createMatchMap(List<Match> matches) {
        return matches.stream()
                .collect(Collectors.toMap(Match::match_id, match -> match));
    }

    /**
     * 팀 ID로 빠르게 조회할 수 있는 맵 생성
     */
    private Map<Integer, Team> createTeamMap(List<Team> teams) {
        return teams.stream()
                .collect(Collectors.toMap(Team::teamId, team -> team));
    }

    /**
     * 예측 상세 정보 목록 생성
     */
    private List<PredictionWithDetails> createPredictionDetails(
            List<PredictedMatch> predictions,
            Map<Integer, Match> matchMap,
            Map<Integer, Team> teamMap) {

        List<PredictionWithDetails> result = new ArrayList<>();

        for (PredictedMatch prediction : predictions) {
            Match match = matchMap.get(prediction.matchId());

            if (match != null) {
                Team team1 = teamMap.get(match.team1_id());
                Team team2 = teamMap.get(match.team2_id());
                Team predictedTeam = teamMap.get(prediction.predictedWinnerId());

                boolean isCorrect = prediction.isCorrect() != null ?
                        prediction.isCorrect() :
                        (match.is_finished() == 1 && match.winner_id() == prediction.predictedWinnerId());

                result.add(new PredictionWithDetails(
                        prediction,
                        match,
                        team1,
                        team2,
                        predictedTeam,
                        isCorrect
                ));
            }
        }

        return result;
    }

    /**
     * 예측 통계 계산
     */
    private PredictionStats calculatePredictionStats(List<PredictionWithDetails> predictions) {
        int correctPredictions = 0;
        int totalFinishedMatches = 0;

        for (PredictionWithDetails prediction : predictions) {
            if (prediction.match().is_finished() == 1) {
                totalFinishedMatches++;
                if (prediction.isCorrect()) {
                    correctPredictions++;
                }
            }
        }

        double accuracyPercentage = totalFinishedMatches > 0
                ? (double) correctPredictions / totalFinishedMatches * 100
                : 0;

        return new PredictionStats(
                correctPredictions,
                totalFinishedMatches,
                accuracyPercentage
        );
    }

    /**
     * 모델에 필요한 데이터 추가
     */
    private void populateModel(
            Model model,
            User user,
            List<PredictionWithDetails> predictions,
            PredictionStats stats) {

        model.addAttribute("predictions", predictions);
        model.addAttribute("correctPredictions", stats.correctPredictions());
        model.addAttribute("totalFinishedMatches", stats.totalFinishedMatches());
        model.addAttribute("accuracyPercentage", stats.accuracyPercentage());
        model.addAttribute("user", user);
    }

}