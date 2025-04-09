package com.example.predict_match.model.repository;

import com.example.predict_match.model.dto.PredictedMatch;
import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@Repository
public class PredictionRepository implements JDBCRepository {
    private final Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
    private final Logger logger = Logger.getLogger(PredictionRepository.class.getName());
    public final String URL = dotenv.get("DB_URL");
    public final String USER = dotenv.get("DB_USER");
    public final String PASSWORD = dotenv.get("DB_PASSWORD");

    public PredictedMatch save(PredictedMatch prediction) throws SQLException, ClassNotFoundException {
        String query = "INSERT INTO PREDICTED_MATCHES (user_id, match_id, predicted_winner_id) VALUES (?, ?, ?)";

        try (Connection conn = getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setLong(1, prediction.userId());
            pstmt.setInt(2, prediction.matchId());
            pstmt.setInt(3, prediction.predictedWinnerId());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating prediction failed, no rows affected.");
            }

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return new PredictedMatch(
                            generatedKeys.getLong(1),
                            prediction.userId(),
                            prediction.matchId(),
                            prediction.predictedWinnerId(),
                            null,
                            LocalDateTime.now()
                    );
                } else {
                    throw new SQLException("Creating prediction failed, no ID obtained.");
                }
            }
        }
    }

    public void update(PredictedMatch prediction) throws SQLException, ClassNotFoundException {
        String query = "UPDATE PREDICTED_MATCHES SET predicted_winner_id = ? WHERE user_id = ? AND match_id = ?";

        try (Connection conn = getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, prediction.predictedWinnerId());
            pstmt.setLong(2, prediction.userId());
            pstmt.setInt(3, prediction.matchId());

            pstmt.executeUpdate();
        }
    }

    public List<PredictedMatch> findByUserId(Long userId) throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM PREDICTED_MATCHES WHERE user_id = ?";
        List<PredictedMatch> predictions = new ArrayList<>();

        try (Connection conn = getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setLong(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                predictions.add(new PredictedMatch(
                        rs.getLong("id"),
                        rs.getLong("user_id"),
                        rs.getInt("match_id"),
                        rs.getInt("predicted_winner_id"),
                        rs.getObject("is_correct", Boolean.class),
                        rs.getTimestamp("created_at").toLocalDateTime()
                ));
            }
        }

        return predictions;
    }

    public PredictedMatch findByUserIdAndMatchId(Long userId, int matchId) throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM PREDICTED_MATCHES WHERE user_id = ? AND match_id = ?";

        try (Connection conn = getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setLong(1, userId);
            pstmt.setInt(2, matchId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return new PredictedMatch(
                        rs.getLong("id"),
                        rs.getLong("user_id"),
                        rs.getInt("match_id"),
                        rs.getInt("predicted_winner_id"),
                        rs.getObject("is_correct", Boolean.class),
                        rs.getTimestamp("created_at").toLocalDateTime()
                );
            }
        }

        return null;
    }

    // PredictionRepository.java에 추가
    /**
     * 경기 결과에 따라 모든 예측을 처리하고 포인트를 업데이트
     */
    public void processFinishedMatchesAndUpdatePoints() {
        try {
            logger.info("Processing finished matches and updating user points...");

            // 하나의 트랜잭션으로 모든 처리를 수행
            try (Connection conn = getConnection(URL, USER, PASSWORD)) {

                // 자동 커밋 비활성화
                conn.setAutoCommit(false);

                // 1. 아직 처리되지 않은 예측이 있는 종료된 경기 조회 (최적화된 쿼리)
                String matchQuery = "SELECT DISTINCT m.match_id, m.winner_id FROM MATCHES m " +
                        "JOIN PREDICTED_MATCHES pm ON m.match_id = pm.match_id " +
                        "WHERE m.is_finished = 1 AND pm.is_correct IS NULL";

                try (PreparedStatement matchStmt = conn.prepareStatement(matchQuery);
                     ResultSet matchRs = matchStmt.executeQuery()) {

                    // 예측 결과 업데이트를 위한 prepared statement (재사용)
                    String updatePredictionQuery = "UPDATE PREDICTED_MATCHES SET is_correct = ? WHERE id = ?";
                    try (PreparedStatement updatePredStmt = conn.prepareStatement(updatePredictionQuery)) {

                        // 포인트 업데이트를 위한 map (사용자별 포인트 합산)
                        Map<Long, Integer> userPointsMap = new HashMap<>();

                        // 정확한 예측과 틀린 예측에 대한 포인트
                        final int CORRECT_PREDICTION_POINTS = 10;
                        final int INCORRECT_PREDICTION_POINTS = 0;

                        // 각 경기 처리
                        while (matchRs.next()) {
                            int matchId = matchRs.getInt("match_id");
                            int winnerId = matchRs.getInt("winner_id");

                            // 2. 이 경기에 대한 모든 처리되지 않은 예측 조회
                            String predQuery = "SELECT id, user_id, predicted_winner_id FROM PREDICTED_MATCHES " +
                                    "WHERE match_id = ? AND is_correct IS NULL";

                            try (PreparedStatement predStmt = conn.prepareStatement(predQuery)) {
                                predStmt.setInt(1, matchId);
                                try (ResultSet predRs = predStmt.executeQuery()) {

                                    // 배치 처리를 위한 카운터
                                    int batchCount = 0;

                                    // 각 예측 처리
                                    while (predRs.next()) {
                                        long predictionId = predRs.getLong("id");
                                        long userId = predRs.getLong("user_id");
                                        int predictedWinnerId = predRs.getInt("predicted_winner_id");

                                        // 예측 정확성 확인
                                        boolean isCorrect = (predictedWinnerId == winnerId);

                                        // 예측 결과 업데이트 (배치에 추가)
                                        updatePredStmt.setBoolean(1, isCorrect);
                                        updatePredStmt.setLong(2, predictionId);
                                        updatePredStmt.addBatch();

                                        // 포인트 계산 및 맵에 추가
                                        int points = isCorrect ? CORRECT_PREDICTION_POINTS : INCORRECT_PREDICTION_POINTS;
                                        userPointsMap.put(userId, userPointsMap.getOrDefault(userId, 0) + points);

                                        // 50개마다 배치 실행
                                        if (++batchCount % 50 == 0) {
                                            updatePredStmt.executeBatch();
                                        }
                                    }

                                    // 남은 배치 실행
                                    if (batchCount % 50 != 0) {
                                        updatePredStmt.executeBatch();
                                    }
                                }
                            }
                        }

                        // 3. 사용자별 포인트 업데이트 (배치 처리)
                        if (!userPointsMap.isEmpty()) {
                            String updatePointsQuery = "UPDATE USERS SET point = point + ? WHERE user_id = ?";
                            try (PreparedStatement pointsStmt = conn.prepareStatement(updatePointsQuery)) {

                                int batchCount = 0;
                                for (Map.Entry<Long, Integer> entry : userPointsMap.entrySet()) {
                                    pointsStmt.setInt(1, entry.getValue());
                                    pointsStmt.setLong(2, entry.getKey());
                                    pointsStmt.addBatch();

                                    // 로그 기록
                                    logger.info("User ID " + entry.getKey() + " points adjustment: " + entry.getValue());

                                    // 50개마다 배치 실행
                                    if (++batchCount % 50 == 0) {
                                        pointsStmt.executeBatch();
                                    }
                                }

                                // 남은 배치 실행
                                if (batchCount % 50 != 0) {
                                    pointsStmt.executeBatch();
                                }
                            }
                        }
                    }
                }

                // 모든 작업이 성공하면 커밋
                conn.commit();
                logger.info("Successfully processed matches and updated points");

            } catch (SQLException e) {
                logger.severe("Error processing matches: " + e.getMessage());
                e.printStackTrace();
                // 롤백은 try-with-resources에 의해 자동으로 처리됨
            }

        } catch (Exception e) {
            logger.severe("Error while processing matches: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
