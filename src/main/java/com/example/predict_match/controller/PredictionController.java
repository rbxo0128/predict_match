package com.example.predict_match.controller;

import com.example.predict_match.model.dto.*;
import com.example.predict_match.service.MatchService;
import com.example.predict_match.service.PredictionService;
import com.example.predict_match.service.TeamService;
import com.example.predict_match.service.UserService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/predictions")
public class PredictionController {
    private final PredictionService predictionService;
    private final UserService userService;
    private final MatchService matchService;
    private final TeamService teamService;

    public PredictionController(PredictionService predictionService, UserService userService,
                                MatchService matchService, TeamService teamService) {
        this.predictionService = predictionService;
        this.userService = userService;
        this.matchService = matchService;
        this.teamService = teamService;
    }

    @GetMapping
    public String showUserPredictions(Model model, Authentication authentication) {
        try {
            // Check if user is authenticated
            if (authentication == null || !authentication.isAuthenticated()) {
                return "redirect:/login";
            }

            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            Optional<User> userOptional = userService.findByEmail(userDetails.getUsername());

            if (userOptional.isEmpty()) {
                model.addAttribute("error", "사용자 정보를 찾을 수 없습니다.");
                return "error";
            }

            User user = userOptional.get();

            // Get all user predictions
            List<PredictedMatch> predictions = predictionService.getUserPredictions(user.userId());

            // Get all matches and teams for reference
            List<Match> allMatches = matchService.getAllMatches();
            List<Team> allTeams = teamService.getAllTeams();

            // Create map for quick lookup
            Map<Integer, Match> matchMap = allMatches.stream()
                    .collect(Collectors.toMap(Match::match_id, match -> match));

            Map<Integer, Team> teamMap = allTeams.stream()
                    .collect(Collectors.toMap(Team::teamId, team -> team));

            // Create list of predictions with details
            List<PredictionWithDetails> predictionsWithDetails = new ArrayList<>();

            int correctPredictions = 0;
            int totalFinishedMatches = 0;

            for (PredictedMatch prediction : predictions) {
                Match match = matchMap.get(prediction.matchId());

                if (match != null) {
                    Team team1 = teamMap.get(match.team1_id());
                    Team team2 = teamMap.get(match.team2_id());
                    Team predictedTeam = teamMap.get(prediction.predictedWinnerId());

                    boolean isCorrect = match.is_finished() == 1 && match.winner_id() == prediction.predictedWinnerId();

                    if (match.is_finished() == 1) {
                        totalFinishedMatches++;
                        if (isCorrect) {
                            correctPredictions++;
                        }
                    }

                    predictionsWithDetails.add(new PredictionWithDetails(
                            prediction,
                            match,
                            team1,
                            team2,
                            predictedTeam,
                            isCorrect
                    ));
                }
            }

            // Calculate prediction accuracy percentage
            double accuracyPercentage = totalFinishedMatches > 0
                    ? (double) correctPredictions / totalFinishedMatches * 100
                    : 0;

            model.addAttribute("predictions", predictionsWithDetails);
            model.addAttribute("correctPredictions", correctPredictions);
            model.addAttribute("totalFinishedMatches", totalFinishedMatches);
            model.addAttribute("accuracyPercentage", accuracyPercentage);
            model.addAttribute("user", user);

            return "predictions";
        } catch (Exception e) {
            model.addAttribute("error", "예측 정보를 불러오는 중 오류가 발생했습니다: " + e.getMessage());
            return "error";
        }
    }

    // Inner record class for combining prediction data with match and team details
    public record PredictionWithDetails(
            PredictedMatch prediction,
            Match match,
            Team team1,
            Team team2,
            Team predictedTeam,
            boolean isCorrect
    ) {}
}