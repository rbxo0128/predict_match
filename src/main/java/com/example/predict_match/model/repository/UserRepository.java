package com.example.predict_match.model.repository;

import com.example.predict_match.model.dto.User;
import com.example.predict_match.model.dto.UserRankDTO;
import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Logger;

@Repository
public class UserRepository implements JDBCRepository {
    private final Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
    private final Logger logger = Logger.getLogger(UserRepository.class.getName());
    public final String URL = dotenv.get("DB_URL");
    public final String USER = dotenv.get("DB_USER");
    public final String PASSWORD = dotenv.get("DB_PASSWORD");

    public User save(User user) throws SQLException, ClassNotFoundException {
        String query = "INSERT INTO USERS (user_id, username, email, password, role, point, is_active) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            long userId = generateUniqueUserId();
            pstmt.setLong(1, userId);
            pstmt.setString(2, user.username());
            pstmt.setString(3, user.email());
            pstmt.setString(4, user.password());
            pstmt.setString(5, user.role() != null ? user.role() : "USER");
            pstmt.setInt(6, 0);
            pstmt.setBoolean(7, true);

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }

            return new User(
                    userId,
                    user.username(),
                    user.email(),
                    user.password(),
                    "USER",
                    0,
                    true,
                    null,
                    LocalDateTime.now(),
                    LocalDateTime.now()
            );
        }
    }

    public Optional<User> findByEmail(String email) throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM USERS WHERE email = ?";

        try (Connection conn = getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return Optional.of(new User(
                        rs.getLong("user_id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getInt("point"),
                        rs.getBoolean("is_active"),
                        rs.getTimestamp("last_login") != null ?
                                rs.getTimestamp("last_login").toLocalDateTime() : null,
                        rs.getTimestamp("created_at").toLocalDateTime(),
                        rs.getTimestamp("updated_at").toLocalDateTime()
                ));
            }

            return Optional.empty();
        }
    }

    private long generateUniqueUserId() throws SQLException, ClassNotFoundException {
        try (Connection conn = getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement()) {

            ResultSet rs = stmt.executeQuery("SELECT generate_uuid() AS new_id");

            if (rs.next()) {
                return rs.getLong("new_id");
            }

            throw new SQLException("Failed to generate user ID");
        }
    }

    public void updateLastLogin(Long userId) throws SQLException, ClassNotFoundException {
        String query = "UPDATE USERS SET last_login = CURRENT_TIMESTAMP WHERE user_id = ?";

        try (Connection conn = getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setLong(1, userId);
            pstmt.executeUpdate();
        }
    }

    // UserRepository.java에 추가
    public List<UserRankDTO> findTopUsersByPoints(int limit) throws SQLException, ClassNotFoundException {
        List<UserRankDTO> users = new ArrayList<>();
        String query = "SELECT u.user_id, u.username, u.point, " +
                "(SELECT COUNT(*) FROM USERS WHERE point > u.point) + 1 AS user_rank, " +
                "COALESCE((SELECT (SUM(CASE WHEN pm.is_correct = true THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) " +
                "FROM PREDICTED_MATCHES pm WHERE pm.user_id = u.user_id AND pm.is_correct IS NOT NULL), 0) AS accuracy " +
                "FROM USERS u ORDER BY u.point DESC LIMIT ?";

        try (Connection conn = getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                users.add(new UserRankDTO(
                        rs.getLong("user_id"),
                        rs.getString("username"),
                        rs.getInt("point"),
                        rs.getDouble("accuracy"),
                        rs.getInt("user_rank")
                ));
            }
        }

        return users;
    }

    public UserRankDTO findUserRankById(Long userId) throws SQLException, ClassNotFoundException {
        String query = "SELECT u.user_id, u.username, u.point, " +
                "(SELECT COUNT(*) FROM USERS WHERE point > u.point) + 1 AS user_rank, " +
                "COALESCE((SELECT (SUM(CASE WHEN pm.is_correct = true THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) " +
                "FROM PREDICTED_MATCHES pm WHERE pm.user_id = u.user_id AND pm.is_correct IS NOT NULL), 0) AS accuracy " +
                "FROM USERS u WHERE u.user_id = ?";

        try (Connection conn = getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setLong(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return new UserRankDTO(
                        rs.getLong("user_id"),
                        rs.getString("username"),
                        rs.getInt("point"),
                        rs.getDouble("accuracy"),
                        rs.getInt("user_rank")
                );
            }
        }

        return null;
    }
}