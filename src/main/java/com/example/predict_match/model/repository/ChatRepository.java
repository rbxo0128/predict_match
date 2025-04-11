package com.example.predict_match.model.repository;

import com.example.predict_match.model.dto.ChatMessage;

import java.util.List;

public interface ChatRepository {

    void save(ChatMessage chatMessage);

    List<ChatMessage> findRecent(int limit);
}
