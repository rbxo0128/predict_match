package com.example.predict_match.service;

import com.example.predict_match.model.dto.ChatMessage;
import com.example.predict_match.model.repository.ChatRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ChatService {

    @Autowired
    private ChatRepository chatRepository;

    public void saveMessage(ChatMessage chatMessage) {
        chatRepository.save(chatMessage);
    }

    public List<ChatMessage> getRecentMessages(int limit) {
        return chatRepository.findRecent(limit);
    }
}
