package com.example.predict_match.model.repository;

import com.example.predict_match.model.dto.Match;
import com.example.predict_match.model.dto.Team;
import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@Repository
public class TeamRepository implements JDBCRepository {
    private final Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
    private final Logger logger = Logger.getLogger(TeamRepository.class.getName());
    private final String URL = dotenv.get("DB_URL");
    private final String USER = dotenv.get("DB_USER");
    private final String PASSWORD = dotenv.get("DB_PASSWORD");

    public List<Team> findAll() throws SQLException, ClassNotFoundException {
        List<Team> teams = new ArrayList<>();
        String query = "SELECT * FROM LCK_TEAMS ORDER BY team_rank ASC";

        try (Connection conn = getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                teams.add(new Team(
                        rs.getInt("team_id"),
                        rs.getString("team_name"),
                        rs.getInt("team_rank"),
                        rs.getInt("wins"),
                        rs.getInt("loses"),
                        rs.getInt("score")

                ));
            }
        }

        return teams;
    }

    public Team findById(int teamId) throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM LCK_TEAMS WHERE team_id = ?";

        try (Connection conn = getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, teamId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return new Team(
                        rs.getInt("team_id"),
                        rs.getString("team_name"),
                        rs.getInt("team_rank"),
                        rs.getInt("wins"),
                        rs.getInt("loses"),
                        rs.getInt("score")
                );
            }
        }

        return null;
    }

    public void update(List<Team> teams) throws SQLException, ClassNotFoundException {
        String query = "UPDATE LCK_TEAMS SET " +
                "team_name = ?, team_rank = ?, wins = ?, loses = ?, score = ? " +
                "WHERE team_id = ?";

        try (Connection conn = getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            for (Team team : teams) {
                pstmt.setString(1, team.teamName());
                pstmt.setInt(2, team.teamRank());
                pstmt.setInt(3, team.wins());
                pstmt.setInt(4, team.loses());
                pstmt.setInt(5, team.score());
                pstmt.setInt(6, mapTeamIdByName(team.teamName()));
                pstmt.executeUpdate();
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

    public int mapTeamIdByName(String crawledTeamName) {
        // 팀 이름 매핑 정보
        Map<String, Integer> teamNameToId = new HashMap<>();
        teamNameToId.put("한화생명e스포츠", 1);
        teamNameToId.put("T1", 2);
        teamNameToId.put("젠지", 3);
        teamNameToId.put("kt 롤스터", 4);
        teamNameToId.put("DRX", 5);
        teamNameToId.put("DN 프릭스", 6);
        teamNameToId.put("농심 레드포스", 7);
        teamNameToId.put("OK저축은행 브리온", 8);
        teamNameToId.put("BNK 피어엑스", 9);
        teamNameToId.put("Dplus KIA", 10);

        // 팀 이름으로 매핑된 ID 찾기
        return teamNameToId.getOrDefault(crawledTeamName, 0);
    }


}