package com.example.predict_match.controller;

import com.example.predict_match.config.CustomUserDetails;
import com.example.predict_match.model.dto.ChatMessage;
import com.example.predict_match.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.security.core.Authentication;
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
        // CustomUserDetails를 통해 사용자 ID 가져오기
        Authentication auth = (Authentication) principal;
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Long userId = userDetails.getUserId();

        // 새 인스턴스 생성 시 userId도 포함
        ChatMessage updatedMessage = new ChatMessage(
                chatMessage.id(),
                userId,  // 여기에 실제 userId 설정
                userDetails.getDisplayName(),
                chatMessage.message(),
                LocalDateTime.now()
        );

        chatService.saveMessage(updatedMessage);
        return updatedMessage;
    }
}
