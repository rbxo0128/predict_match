package com.example.predict_match.controller;

import com.example.predict_match.service.*;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/predictions")
public class PredictionController {
    private final UserPredictionService userPredictionService;

    public PredictionController(UserPredictionService userPredictionService) {
        this.userPredictionService = userPredictionService;
    }

    @GetMapping
    public String showUserPredictions(Model model, Authentication authentication) {
        try {
            // 여기서는 인증 체크를 하지 않습니다. Spring Security가 이미 확인함
            userPredictionService.prepareUserPredictionsModel(model, authentication);
            return "predictions";
        } catch (Exception e) {
            model.addAttribute("error", "예측 정보를 불러오는 중 오류가 발생했습니다: " + e.getMessage());
            return "errors";
        }
    }
}