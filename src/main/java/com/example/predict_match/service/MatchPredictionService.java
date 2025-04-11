package com.example.predict_match.service;

import com.example.predict_match.model.dto.Match;
import com.example.predict_match.model.dto.User;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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

            if (!isMatchPredictionAllowed(match)) {
                response.put("success", false);
                response.put("error", "경기 시작 1시간 전부터는 예측을 변경할 수 없습니다.");
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
            System.out.println("에러에러에러에러");
            response.put("success", false);
            response.put("error", "예측 처리 중 일시적인 오류가 발생했습니다. \n잠시 후 다시 시도하시거나, 문제가 지속될 경우 페이지를 새로고침해 주세요.");
            return ResponseEntity.ok(response);
        }
    }

    private boolean isMatchPredictionAllowed(Match match) {
        try {
            // 경기 날짜 문자열 파싱 (04월 09일 (수) 17:00 형식)
            String matchDateStr = match.match_date();

            // 정규식을 사용하여 날짜 및 시간 추출
            Pattern pattern = Pattern.compile("(\\d{2})월 (\\d{2})일 \\([월화수목금토일]\\) (\\d{2}):(\\d{2})");
            Matcher matcher = pattern.matcher(matchDateStr);

            if (!matcher.find()) {
                // 날짜 형식이 맞지 않으면 기본적으로 예측 허용
                return true;
            }

            int month = Integer.parseInt(matcher.group(1));
            int day = Integer.parseInt(matcher.group(2));
            int hour = Integer.parseInt(matcher.group(3));
            int minute = Integer.parseInt(matcher.group(4));

            // 현재 년도 가져오기
            int currentYear = LocalDate.now().getYear();

            // 경기 시간 생성
            LocalDateTime matchDateTime = LocalDateTime.of(currentYear, month, day, hour, minute);

            // 현재 시간
            LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));

            // 경기 시작 1시간 전
            LocalDateTime cutoffTime = matchDateTime.minusHours(1);

            // 현재 시간이 cutoffTime 이후인지 확인
            return now.isBefore(cutoffTime);
        } catch (Exception e) {
            // 날짜 파싱 중 오류가 발생하면 기본적으로 예측 허용
            return true;
        }
    }
}