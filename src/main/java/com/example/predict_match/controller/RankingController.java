package com.example.predict_match.controller;

import com.example.predict_match.model.dto.Match;
import com.example.predict_match.model.dto.Team;
import com.example.predict_match.service.MatchService;
import com.example.predict_match.service.TeamService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/rankings")
public class RankingController {
    private final TeamService teamService;
    private final MatchService matchService;

    public RankingController(TeamService teamService, MatchService matchService) {
        this.teamService = teamService;
        this.matchService = matchService;
    }

    @GetMapping
    public String showRankings(Model model) {
        try {
            // 팀 정보 가져오기
            List<Team> teams = teamService.getAllTeams();

            // 경기 정보 가져오기
            List<Match> matches = matchService.getAllMatches();

            // 팀별 통계 계산
            List<TeamStats> teamStats = calculateTeamStats(teams, matches);

            // 승률 기준으로 정렬
            teamStats.sort(Comparator.comparing(TeamStats::winRate).reversed()
                    .thenComparing(TeamStats::wins, Comparator.reverseOrder()));

            model.addAttribute("teamStats", teamStats);
            return "rankings";
        } catch (Exception e) {
            model.addAttribute("error", "팀 순위 정보를 불러오는 중 오류가 발생했습니다: " + e.getMessage());
            return "error";
        }
    }

    private List<TeamStats> calculateTeamStats(List<Team> teams, List<Match> matches) {
        List<TeamStats> result = new ArrayList<>();

        // 각 팀별로 진행
        for (Team team : teams) {
            int teamId = team.teamId();
            int wins = 0;
            int losses = 0;

            // 팀이 참여한 모든 경기를 찾아 승/패 계산
            for (Match match : matches) {
                // 경기가 완료된 경우만 계산
                if (match.is_finished() == 1) {
                    // 팀1로 참여한 경우
                    if (match.team1_id() == teamId) {
                        if (match.winner_id() == teamId) {
                            wins++;
                        } else {
                            losses++;
                        }
                    }
                    // 팀2로 참여한 경우
                    else if (match.team2_id() == teamId) {
                        if (match.winner_id() == teamId) {
                            wins++;
                        } else {
                            losses++;
                        }
                    }
                }
            }

            // 승률 계산 (경기가 없는 경우 0으로 처리)
            double winRate = wins + losses > 0 ? (double) wins / (wins + losses) * 100 : 0;

            // 팀 통계 추가
            result.add(new TeamStats(team, wins, losses, winRate));
        }

        return result;
    }

    // 팀 통계를 담기 위한 내부 레코드 클래스
    public record TeamStats(Team team, int wins, int losses, double winRate) {
        public int totalGames() {
            return wins + losses;
        }
    }
}