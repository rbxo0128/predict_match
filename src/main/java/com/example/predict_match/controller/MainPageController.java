package com.example.predict_match.controller;

import com.example.predict_match.service.MainPageService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

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
            MainPageService.HomePageData homeData = mainPageService.getHomePageData();

            // 모델에 데이터 추가
            model.addAttribute("todayMatches", homeData.getMatches());
            model.addAttribute("hasMatches", homeData.isHasMatches());
            model.addAttribute("isToday", homeData.isToday());

            if (homeData.getNextMatchDate() != null) {
                model.addAttribute("nextMatchDate", homeData.getNextMatchDate());
            }

            if (homeData.isLoadError()) {
                model.addAttribute("loadError", true);
            }

            return "index";
        } catch (Exception e) {
            // 오류 발생 시 간단한 로깅만 수행하고 기본 뷰 반환
            System.err.println("메인 페이지 로딩 중 오류 발생: " + e.getMessage());
            System.out.println("e = " + e.getMessage());
            model.addAttribute("hasMatches", false);
            model.addAttribute("loadError", true);
            return "index";
        }
    }
}