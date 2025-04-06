package com.example.predict_match.controller;

import com.example.predict_match.model.repository.MatchRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SchedulerController {

    private final MatchRepository matchRepository;

    public SchedulerController(MatchRepository matchRepository) {
        this.matchRepository = matchRepository;
    }

    @GetMapping("/api/update-matches")
    public ResponseEntity<String> triggerMatchUpdate() {
        try {
            matchRepository.check();
            return ResponseEntity.ok("Match data updated successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error updating match data: " + e.getMessage());
        }
    }
}