package com.example.predict_match.service;

import com.example.predict_match.model.repository.MatchRepository;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.logging.Logger;

@Service
public class MatchUpdateScheduler {
//    private static final Logger logger = Logger.getLogger(MatchUpdateScheduler.class.getName());
//
//    private final MatchRepository matchRepository;
//
//    public MatchUpdateScheduler(MatchRepository matchRepository) {
//        this.matchRepository = matchRepository;
//    }
//
//    @Scheduled(cron = "0 0 0 * * ?")  // 매일 자정에 실행
//    public void updateMatchData() {
//        try {
//            logger.info("Scheduled match data update starting...");
//            matchRepository.check();
//            logger.info("Scheduled match data update completed successfully");
//        } catch (Exception e) {
//            logger.severe("Error while updating match data: " + e.getMessage());
//            e.printStackTrace();
//        }
//    }
}
