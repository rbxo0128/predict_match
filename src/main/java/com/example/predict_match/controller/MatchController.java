package com.example.predict_match.controller;

import com.example.predict_match.model.dto.MatchWithTeams;
import com.example.predict_match.service.*;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Controller
@RequestMapping("/matches")
public class MatchController {
    private final MatchService matchService;
    private final MatchPredictionService matchPredictionService;

    public MatchController(MatchService matchService, MatchPredictionService matchPredictionService) {
        this.matchService = matchService;
        this.matchPredictionService = matchPredictionService;
    }


    @GetMapping
    public String showMatches(Model model, Authentication authentication) {
        try {
            List<MatchWithTeams> matchesWithPredictions = matchService.getMatchesWithUserPredictions(authentication);
            model.addAttribute("matches", matchesWithPredictions);
            return "matches";
        } catch (Exception e) {
            model.addAttribute("error", "경기 정보를 불러오는 중 오류가 발생했습니다: " + e.getMessage());
            return "errors";
        }
    }


    @PostMapping(value = "/predict", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> predictMatch(
            @RequestParam("matchId") int matchId,
            @RequestParam("teamId") int teamId,
            Authentication authentication) {

        return matchPredictionService.createPrediction(matchId, teamId, authentication);
    }
}
