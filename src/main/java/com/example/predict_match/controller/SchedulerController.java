package com.example.predict_match.controller;

import com.example.predict_match.model.repository.MatchRepository;
import com.example.predict_match.model.repository.ScheduleRepository;
import com.example.predict_match.model.repository.TeamRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.logging.Logger;

@Controller
public class SchedulerController {
    private final Logger logger = Logger.getLogger(SchedulerController.class.getName());
    private final ScheduleRepository scheduleRepository;

    public SchedulerController(ScheduleRepository scheduleRepository) {
        this.scheduleRepository = scheduleRepository;
    }


    @GetMapping("/api/update-matches")
    public ResponseEntity<String> triggerMatchUpdate() {
        try {
            logger.info("crawling 진행 중");
            scheduleRepository.check();
            return ResponseEntity.ok("Match data updated successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error updating match data: " + e.getMessage());
        }
    }
}