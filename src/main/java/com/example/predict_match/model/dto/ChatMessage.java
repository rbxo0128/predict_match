package com.example.predict_match.model.dto;

import java.time.LocalDateTime;

public record ChatMessage(
        Long id,
        Long userId,
        String username,
        String message,
        LocalDateTime timestamp
) {
    // 생성자 오버로딩 - ID 없이 생성할 때 사용
    public ChatMessage(Long userId, String username, String message, LocalDateTime timestamp) {
        this(null, userId, username, message, timestamp);
    }

    // 생성자 오버로딩 - 사용자 이름과 타임스탬프 없이 생성할 때 사용
    public ChatMessage(Long userId, String message) {
        this(null, userId, null, message, null);
    }

    // 메시지와 타임스탬프를 업데이트한 새 인스턴스 반환 메서드
    public ChatMessage withTimestamp(LocalDateTime newTimestamp) {
        return new ChatMessage(this.id, this.userId, this.username, this.message, newTimestamp);
    }

    // 사용자 이름을 업데이트한 새 인스턴스 반환 메서드
    public ChatMessage withUsername(String newUsername) {
        return new ChatMessage(this.id, this.userId, newUsername, this.message, this.timestamp);
    }
}
