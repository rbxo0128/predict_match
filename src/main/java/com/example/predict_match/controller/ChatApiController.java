package com.example.predict_match.controller;

import com.example.predict_match.model.dto.ChatMessage;
import com.example.predict_match.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/chat")
public class ChatApiController {

    @Autowired
    private ChatService chatService;

    @GetMapping("/recent")
    public List<ChatMessage> getRecentMessages() {
        return chatService.getRecentMessages(50); // 최근 50개 메시지 가져오기
    }
}
