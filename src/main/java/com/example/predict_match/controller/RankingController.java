package com.example.predict_match.controller;

import com.example.predict_match.config.CustomUserDetails;
import com.example.predict_match.model.dto.Match;
import com.example.predict_match.model.dto.Team;
import com.example.predict_match.model.dto.User;
import com.example.predict_match.model.dto.UserRankDTO;
import com.example.predict_match.service.MatchService;
import com.example.predict_match.service.TeamService;
import com.example.predict_match.service.UserService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/rankings")
public class RankingController {
    private final UserService userService;

    public RankingController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public String showRankings(Model model, Authentication authentication) {
        try {
            // 상위 10명의 사용자 가져오기
            List<UserRankDTO> topUsers = userService.getTopUsers(10);
            model.addAttribute("topUsers", topUsers);

            // 현재 로그인한 사용자 정보
            if (authentication != null && authentication.isAuthenticated()) {
                CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
                String currentUsername = userDetails.getDisplayName();


                // 현재 사용자가 Top 10에 있는지 확인
                Optional<UserRankDTO> currentUserInTop = topUsers.stream()
                        .filter(user -> user.username().equals(currentUsername))
                        .findFirst();

                if (currentUserInTop.isPresent()) {
                    // Top 10에 있으면, 해당 정보 사용
                    model.addAttribute("isCurrentUserInTop", true);
                    model.addAttribute("currentUserRank", currentUserInTop.get());
                } else {
                    // Top 10에 없으면, 별도로 랭킹 정보만 가져옴
                    Long userId = ((CustomUserDetails) userDetails).getUserId();
                    UserRankDTO currentUserRank = userService.getUserRank(userId);
                    model.addAttribute("isCurrentUserInTop", false);
                    model.addAttribute("currentUserRank", currentUserRank);
                }
            }


            return "rankings";
        } catch (Exception e) {
            model.addAttribute("error", "랭킹 정보를 불러오는 중 오류가 발생했습니다: " + e.getMessage());
            return "errors";
        }
    }

    // 기존 메소드는 그대로 유지
}