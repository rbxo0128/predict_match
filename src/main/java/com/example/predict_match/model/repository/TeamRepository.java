package com.example.predict_match.model.repository;

import com.example.predict_match.model.dto.Team;
import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
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
                        rs.getInt("team_rank")
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
                        rs.getInt("team_rank")
                );
            }
        }

        return null;
    }
}