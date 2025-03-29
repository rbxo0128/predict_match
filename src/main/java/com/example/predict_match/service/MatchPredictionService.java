package com.example.predict_match.service;

import com.example.predict_match.model.dto.Match;
import com.example.predict_match.model.dto.User;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
public class MatchPredictionService {
    private final MatchService matchService;
    private final UserService userService;
    private final PredictionService predictionService;

    public MatchPredictionService(MatchService matchService, UserService userService,
                                  PredictionService predictionService) {
        this.matchService = matchService;
        this.userService = userService;
        this.predictionService = predictionService;
    }

    /**
     * 경기 예측을 생성하고 결과를 반환합니다.
     */
    public ResponseEntity<Map<String, Object>> createPrediction(int matchId, int teamId, Authentication authentication) {
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

            // 경기 확인
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