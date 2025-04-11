package com.example.predict_match.model.repository;


import com.example.predict_match.model.dto.ChatMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public class JdbcChatRepository implements ChatRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void save(ChatMessage chatMessage) {
        String sql = "INSERT INTO CHAT_MESSAGES (user_id, message, timestamp) VALUES (?, ?, ?)";
        jdbcTemplate.update(sql, chatMessage.userId(), chatMessage.message(), chatMessage.timestamp());
    }

    @Override
    public List<ChatMessage> findRecent(int limit) {
        String sql = "SELECT cm.id, cm.user_id, u.username, cm.message, cm.timestamp " +
                "FROM CHAT_MESSAGES cm JOIN USERS u ON cm.user_id = u.id " +
                "ORDER BY cm.timestamp DESC LIMIT ?";

        return jdbcTemplate.query(sql, new ChatMessageRowMapper(), limit);
    }

    private static class ChatMessageRowMapper implements RowMapper<ChatMessage> {
        @Override
        public ChatMessage mapRow(ResultSet rs, int rowNum) throws SQLException {
            return new ChatMessage(
                    rs.getLong("id"),
                    rs.getLong("user_id"),
                    rs.getString("username"),
                    rs.getString("message"),
                    rs.getObject("timestamp", LocalDateTime.class)
            );
        }
    }
}
