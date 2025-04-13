package com.example.predict_match.controller;

import com.example.predict_match.model.dto.MainPageData;
import com.example.predict_match.service.MainPageService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.logging.Logger;

@Controller
public class MainPageController {

    private final MainPageService mainPageService;


    public MainPageController(MainPageService mainPageService) {
        this.mainPageService = mainPageService;
    }

    @GetMapping("/")
    public String index(Model model) {
        try {
            // 서비스를 통해 데이터 가져오기
            MainPageData homeData = mainPageService.getMainPageData();

            // 모델에 데이터 추가
            model.addAttribute("todayMatches", homeData.matches());
            model.addAttribute("hasMatches", homeData.hasMatches());
            model.addAttribute("isToday", homeData.isToday());
            model.addAttribute("teams", homeData.teams());

            if (homeData.nextMatchDate() != null) {
                model.addAttribute("nextMatchDate", homeData.nextMatchDate());
            }

            if (homeData.loadError()) {
                model.addAttribute("loadError", true);
            }

            return "index";
        } catch (Exception e) {
            model.addAttribute("hasMatches", false);
            model.addAttribute("loadError", true);
            return "index";
        }
    }
}