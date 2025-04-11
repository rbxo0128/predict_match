package com.example.predict_match.controller;

import com.example.predict_match.model.dto.ChatMessage;
import com.example.predict_match.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import java.security.Principal;
import java.time.LocalDateTime;

@Controller
public class ChatController {

    @Autowired
    private ChatService chatService;

    @MessageMapping("/chat.sendMessage")
    @SendTo("/topic/public")
    public ChatMessage sendMessage(ChatMessage chatMessage, Principal principal) {
        // record는 불변이므로 새 인스턴스를 생성하여 수정된 값을 적용
        ChatMessage updatedMessage = chatMessage
                .withUsername(principal.getName())
                .withTimestamp(LocalDateTime.now());

        chatService.saveMessage(updatedMessage);

        return updatedMessage;
    }
}
