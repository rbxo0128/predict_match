package com.example.predict_match.controller;

import com.example.predict_match.model.repository.MatchRepository;
import com.example.predict_match.model.repository.PredictionRepository;
import com.example.predict_match.model.repository.ScheduleRepository;
import com.example.predict_match.model.repository.TeamRepository;
import com.example.predict_match.service.PredictionProcessor;
import com.example.predict_match.service.ScheduleService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.logging.Logger;

@Controller
public class SchedulerController {
    private final Logger logger = Logger.getLogger(SchedulerController.class.getName());
    private final ScheduleService scheduleService;
    private final PredictionRepository predictionRepository;

    public SchedulerController(ScheduleService scheduleService, PredictionRepository predictionRepository) {
        this.scheduleService = scheduleService;
        this.predictionRepository = predictionRepository;
    }


    @GetMapping("/api/update-matches")
    public ResponseEntity<String> triggerMatchUpdate() {
        try {
            logger.info("경기 데이터 업데이트 진행 중");
            scheduleService.check();

            // 2. 예측 처리 및 포인트 계산 실행
            logger.info("예측 결과 처리 및 포인트 계산 진행 중");
            predictionRepository.processFinishedMatchesAndUpdatePoints();
            return ResponseEntity.ok("Match data updated and predictions processed successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error updating match data and processing predictions: " + e.getMessage());
        }
    }
}