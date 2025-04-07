package com.example.predict_match.service;

import com.example.predict_match.model.dto.Match;
import com.example.predict_match.model.dto.PredictedMatch;
import com.example.predict_match.model.dto.User;
import com.example.predict_match.model.repository.MatchRepository;
import com.example.predict_match.model.repository.PredictionRepository;
import com.example.predict_match.model.repository.UserRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;

/**
 * 경기 결과 업데이트 및 예측 결과에 따른 포인트 처리를 담당하는 서비스
 */
@Service
public class PredictionProcessor {
    private static final Logger logger = Logger.getLogger(PredictionProcessor.class.getName());

    private final MatchRepository matchRepository;
    private final PredictionRepository predictionRepository;
    private final UserRepository userRepository;

    // 정확한 예측에 대한 포인트 보상
    private static final int CORRECT_PREDICTION_POINTS = 10;
    private static final int INCORRECT_PREDICTION_POINTS = -5;

    public PredictionProcessor(MatchRepository matchRepository,
                               PredictionRepository predictionRepository,
                               UserRepository userRepository) {
        this.matchRepository = matchRepository;
        this.predictionRepository = predictionRepository;
        this.userRepository = userRepository;
    }

    /**
     * 매일 자정에 실행되어 경기 결과를 확인하고 포인트를 업데이트
     */// 매일 자정에 실행
    public void processFinishedMatches() {
        try {
            logger.info("Processing finished matches and updating user points...");

            // 모든 경기 가져오기
            List<Match> matches = matchRepository.findAll();

            // 종료된 경기만 필터링
            List<Match> finishedMatches = matches.stream()
                    .filter(match -> match.is_finished() == 1)
                    .toList();

            for (Match match : finishedMatches) {
                processMatch(match);
            }

            logger.info("Finished processing matches and updating points");
        } catch (Exception e) {
            logger.severe("Error while processing matches: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 특정 경기에 대한 모든 예측을 처리하고 포인트를 업데이트
     */
    private void processMatch(Match match) throws SQLException, ClassNotFoundException {
        // 이 경기에 대한 모든 예측을 가져오는 쿼리
        String query = "SELECT * FROM PREDICTED_MATCHES WHERE match_id = ? AND is_correct IS NULL";

        try (Connection conn = matchRepository.getConnection(
                matchRepository.URL, matchRepository.USER, matchRepository.PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, match.match_id());
            var rs = pstmt.executeQuery();

            while (rs.next()) {
                long userId = rs.getLong("user_id");
                int predictedWinnerId = rs.getInt("predicted_winner_id");
                long predictionId = rs.getLong("id");

                // 예측이 맞았는지 확인
                boolean isCorrect = predictedWinnerId == match.winner_id();

                // 예측 결과 업데이트
                updatePredictionResult(predictionId, isCorrect);

                // 맞았으면 포인트 부여
                if (isCorrect) {
                    awardPointsToUser(userId, CORRECT_PREDICTION_POINTS);
                }
            }
        }
    }

    /**
     * 예측 결과 업데이트 (맞았는지 여부)
     */
    private void updatePredictionResult(long predictionId, boolean isCorrect) throws SQLException, ClassNotFoundException {
        String query = "UPDATE PREDICTED_MATCHES SET is_correct = ? WHERE id = ?";

        try (Connection conn = predictionRepository.getConnection(
                predictionRepository.URL, predictionRepository.USER, predictionRepository.PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setBoolean(1, isCorrect);
            pstmt.setLong(2, predictionId);
            pstmt.executeUpdate();
        }
    }

    /**
     * 사용자에게 포인트 부여
     */
    private void awardPointsToUser(long userId, int points) throws SQLException, ClassNotFoundException {
        String query = "UPDATE USERS SET point = point + ? WHERE user_id = ?";

        try (Connection conn = userRepository.getConnection(
                userRepository.URL, userRepository.USER, userRepository.PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, points);
            pstmt.setLong(2, userId);
            pstmt.executeUpdate();

            logger.info("Awarded " + points + " points to user ID: " + userId);
        }
    }
}