package com.example.predict_match.model.repository;

import com.example.predict_match.model.dto.Match;
import com.example.predict_match.model.dto.MatchSchedule;
import com.example.predict_match.model.dto.Team;
import com.example.predict_match.model.dto.TeamId;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class JsoupTeamRepository {
    final static ObjectMapper objectMapper = new ObjectMapper();
    public List<Team> getTeams() {
        List<Team> teams = new ArrayList<>();
        try {
            // 네이버 LCK 일정 페이지 URL (실제 URL로 변경 필요)
            String url = "https://game.naver.com/esports/League_of_Legends/record/lck/team/lck_2025";
            System.out.println("start");
            // 웹 페이지 가져오기
            Document doc = Jsoup.connect(url).get();
            // 경기 목록 크롤링 (예제: class="schedule_list" 아래 정보 가져오기)
            Element script = doc.getElementById("__NEXT_DATA__");
            String jsonStr = script.html();

            JsonNode rootNode = objectMapper.readTree(jsonStr);
            JsonNode teamRankingNode = rootNode.path("props")
                    .path("initialState")
                    .path("ranking")
                    .path("teamRanking");

            if (teamRankingNode.isArray()) {
                for (JsonNode teamData : teamRankingNode) {
                    JsonNode teamNode = teamData.path("team");

                    int teamId = teamNode.path("id").asInt();
                    String teamName = teamNode.path("name").asText();
                    int teamRank = teamData.path("rank").asInt();
                    int wins = teamData.path("wins").asInt();
                    int loses = teamData.path("loses").asInt();
                    int score = teamData.path("score").asInt();

                    teams.add(new Team(teamId, teamName, teamRank, wins, loses, score));
                }
            }



        } catch (Exception e) {
            System.out.println("Jsoup error");
            e.printStackTrace();
        }

        return teams;
    }
}
