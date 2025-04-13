package com.example.predict_match.model.repository;

import com.example.predict_match.model.dto.Match;
import com.example.predict_match.model.dto.MatchSchedule;
import com.example.predict_match.model.dto.TeamId;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.jsoup.nodes.Element;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class JsoupRepository {
    final static ObjectMapper objectMapper = new ObjectMapper();
    public List<Match> getMatches(int month) {
        List<Match> matchList = new ArrayList<>();
        try {
            // 네이버 LCK 일정 페이지 URL (실제 URL로 변경 필요)
            String url = "https://game.naver.com/esports/League_of_Legends/schedule/lck?date=2025-%s".formatted(month);
            System.out.println("start");
            // 웹 페이지 가져오기
            Document doc = Jsoup.connect(url).get();
            // 경기 목록 크롤링 (예제: class="schedule_list" 아래 정보 가져오기)
            Elements scripts = doc.select("script");

            for (Element script : scripts) {
                String scriptData = script.data();

                // JSON 데이터가 포함된 부분만 추출
                if (scriptData.contains("monthSchedule")) {
                    // 필요한 부분만 추출하여 JSON 데이터로 파싱
                    String jsonString = scriptData.split("monthSchedule\":")[1].split(",\"userMatchPushGameIds")[0].trim();
                    List<MatchSchedule> matches = objectMapper.readValue(jsonString, new TypeReference<List<MatchSchedule>>() {});

                    for (MatchSchedule matchSchedule : matches) {
                        for (MatchSchedule.Schedule schedule : matchSchedule.schedules()) {
                            int team1Id = TeamId.fromAcronym(schedule.homeTeam().nameAcronym());
                            int team2Id = TeamId.fromAcronym(schedule.awayTeam().nameAcronym());
                            String time = schedule.time();

                            int matchId = team1Id;  // 상황에 맞게 조정

                            String matchDate = schedule.date() + " " + schedule.time();

                            // is_finished는 matchStatus 값에 따라 처리 (예시: "finished"이면 1, 아니면 0)
                            int isFinished = schedule.matchStatus().equalsIgnoreCase("Result") ? 1 : 0;

                            // winner_id는 winner 값이나 스코어를 통해 결정 (예시)
                            int winnerId = 0;
                            if (isFinished == 1) {
                                if (schedule.winner().equals("HOME")){
                                    winnerId = team1Id;
                                }
                                else{
                                    winnerId = team2Id;
                                }
                            }

                            // Match 객체 생성 (매개변수 순서에 맞게 할당)
                            Match match = new Match(matchId, team1Id, team2Id, matchDate, schedule.homeScore(), schedule.awayScore(), isFinished, winnerId);
                            matchList.add(match);
                        }

                    }
                    // 이제 데이터를 저장 하거나 업데이트? 이걸 여기서 처리하나? 매핑
                }
            }
        } catch (Exception e) {
            System.out.println("Jsoup error");
            e.printStackTrace();
        }

        return matchList;
    }
}
