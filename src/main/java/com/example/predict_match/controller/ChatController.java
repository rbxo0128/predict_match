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

        ChatMessage messageToSave = new ChatMessage(
                chatMessage.id(),
                userId,
                userDetails.getDisplayName(),
                chatMessage.message(),
                LocalDateTime.now()
        );

        // DB에 저장
        chatService.saveMessage(messageToSave);

        // 클라이언트에게 보낼 응답용 객체 생성 (userId 제외)
        ChatMessage responseMessage = new ChatMessage(
                null,
                null,
                userDetails.getDisplayName(),
                chatMessage.message(),
                LocalDateTime.now()
        );

        return responseMessage;
    }
}
