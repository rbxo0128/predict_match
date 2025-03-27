package com.example.predict_match.model.repository;

import com.example.predict_match.model.dto.PredictedMatch;
import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
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
}
