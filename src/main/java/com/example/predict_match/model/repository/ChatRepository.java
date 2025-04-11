package com.example.predict_match.model.repository;

import com.example.predict_match.model.dto.ChatMessage;
import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.stereotype.Repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Repository
public class ChatRepository implements JDBCRepository {
    private final Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
    private final Logger logger = Logger.getLogger(ChatRepository.class.getName());
    public final String URL = dotenv.get("DB_URL");
    public final String USER = dotenv.get("DB_USER");
    public final String PASSWORD = dotenv.get("DB_PASSWORD");

    public void save(ChatMessage chatMessage) {
        String sql = "INSERT INTO CHAT_MESSAGES (user_id, message, timestamp) VALUES (?, ?, ?)";

        try (Connection conn = getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, chatMessage.userId());
            pstmt.setString(2, chatMessage.message());
            pstmt.setTimestamp(3, Timestamp.valueOf(chatMessage.timestamp()));

            pstmt.executeUpdate();
        } catch (Exception e) {
            logger.severe("채팅 메시지 저장 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public List<ChatMessage> findRecent(int limit) {
        List<ChatMessage> messages = new ArrayList<>();
        String sql = "SELECT cm.id, cm.user_id, u.username, cm.message, cm.timestamp " +
                "FROM CHAT_MESSAGES cm JOIN USERS u ON cm.user_id = u.user_id " +
                "ORDER BY cm.timestamp DESC LIMIT ?";

        try (Connection conn = getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limit);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    messages.add(new ChatMessage(
                            rs.getLong("id"),
                            rs.getLong("user_id"),
                            rs.getString("username"),
                            rs.getString("message"),
                            rs.getTimestamp("timestamp").toLocalDateTime()
                    ));
                }
            }
        } catch (Exception e) {
            logger.severe("최근 채팅 메시지 조회 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("messages = " + messages);
        return messages;
    }
}
