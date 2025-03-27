package com.example.predict_match.controller;

import com.example.predict_match.model.dto.Match;
import com.example.predict_match.model.dto.MatchWithTeams;
import com.example.predict_match.model.dto.PredictedMatch;
import com.example.predict_match.model.dto.User;
import com.example.predict_match.service.MatchService;
import com.example.predict_match.service.PredictionService;
import com.example.predict_match.service.TeamService;
import com.example.predict_match.service.UserService;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;

@Controller
@RequestMapping("/matches")
public class MatchController {
    private final MatchService matchService;
    private final TeamService teamService;
    private final UserService userService;
    private final PredictionService predictionService;

    public MatchController(MatchService matchService, TeamService teamService,
                           UserService userService, PredictionService predictionService) {
        this.matchService = matchService;
        this.teamService = teamService;
        this.userService = userService;
        this.predictionService = predictionService;
    }

    @GetMapping
    public String showMatches(Model model, Authentication authentication) {
        try {
            System.out.println("MatchController: 경기 목록 조회 시작");
            List<MatchWithTeams> matchesWithTeams = matchService.getMatchesWithTeams();
            System.out.println("MatchController: 경기 목록 조회 완료, 경기 수: " + matchesWithTeams.size());
            model.addAttribute("matches", matchesWithTeams);

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

                    model.addAttribute("matches", matchesWithPredictions);
                }
            }
            System.out.println("로딩완료");
            return "matches";
        } catch (Exception e) {
            model.addAttribute("error", "경기 정보를 불러오는 중 오류가 발생했습니다: " + e.getMessage());
            return "error";
        }
    }

    @PostMapping(value = "/predict", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody  // 이 어노테이션을 추가하여 응답이 뷰가 아닌 데이터임을 나타냄
    public ResponseEntity<Map<String, Object>> predictMatch(
            @RequestParam("matchId") int matchId,
            @RequestParam("teamId") int teamId,
            Authentication authentication) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 사용자 확인
            if (authentication == null || !authentication.isAuthenticated()) {
                response.put("success", false);
                response.put("error", "예측하려면 로그인이 필요합니다.");
                return ResponseEntity.ok(response);
            }

            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            Optional<User> userOptional = userService.findByEmail(userDetails.getUsername());

            if (userOptional.isEmpty()) {
                response.put("success", false);
                response.put("error", "사용자 정보를 찾을 수 없습니다.");
                return ResponseEntity.ok(response);
            }

            User user = userOptional.get();

            // 경기 확인 (단일 쿼리로 가져옴)
            Match match = matchService.getMatchById(matchId);
            if (match == null) {
                response.put("success", false);
                response.put("error", "존재하지 않는 경기입니다.");
                return ResponseEntity.ok(response);
            }

            // 이미 종료된 경기인지 확인
            if (match.is_finished() == 1) {
                response.put("success", false);
                response.put("error", "이미 종료된 경기는 예측할 수 없습니다.");
                return ResponseEntity.ok(response);
            }

            // 유효한 팀인지 확인 (Team1 또는 Team2여야 함)
            if (match.team1_id() != teamId && match.team2_id() != teamId) {
                response.put("success", false);
                response.put("error", "유효하지 않은 팀 선택입니다.");
                return ResponseEntity.ok(response);
            }

            // 예측 저장 또는 업데이트
            predictionService.createOrUpdatePrediction(user, matchId, teamId);

            response.put("success", true);
            response.put("message", "예측이 성공적으로 저장되었습니다.");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("error", "예측 처리 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.ok(response);
        }
    }
}
