package com.example.predict_match.model.repository;

import com.example.predict_match.model.dto.Match;
import com.example.predict_match.model.dto.MatchWithTeams;
import com.example.predict_match.model.dto.Team;
import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Repository
public class MatchRepository implements JDBCRepository {
    final Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
    final Logger logger = Logger.getLogger(MatchRepository.class.getName());
    final JsoupRepository jsoupRepository;
    public final String URL = dotenv.get("DB_URL");
    public final String USER = dotenv.get("DB_USER");
    public final String PASSWORD = dotenv.get("DB_PASSWORD");

    public MatchRepository(JsoupRepository jsoupRepository) {
        this.jsoupRepository = jsoupRepository;
    }

    public List<Match> check() throws Exception {
        try (Connection conn = getConnection(URL, USER, PASSWORD)) {
            String query = "SELECT * FROM MATCHES ORDER BY match_id ASC";
            try (PreparedStatement pstmt = conn.prepareStatement(query);
                 ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String lastUpdate = rs.getString("last_update_date");
                    LocalDate dbDate = LocalDate.parse(lastUpdate);
                    LocalDate today = LocalDate.now();

                    if (dbDate.equals(today)) {
                        logger.info("DB의 날짜와 오늘 날짜가 같습니다");
                    }
                    else {
                        logger.info("DB의 날짜와 오늘 날짜가 다릅니다");
                        List<Match> matches = jsoupRepository.getMatches(4);
                        update(matches);
                    }
                }
            }
        } catch (Exception e) {
            logger.severe(e.getMessage());
        }
        return findAll();
    }


    public List<Match> findAll() throws Exception {
        logger.info("findAll 시작");
        List<Match> matches = new ArrayList<>();
        try (Connection conn = getConnection(URL, USER, PASSWORD)) {
            Statement stmt = conn.createStatement();
            String query = "SELECT * FROM MATCHES ORDER BY match_id ASC";
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                matches.add(new Match(
                        rs.getInt("match_id"),
                        rs.getInt("team1_id"),
                        rs.getInt("team2_id"),
                        rs.getString("match_date"),
                        rs.getInt("team1_score"),
                        rs.getInt("team2_score"),
                        rs.getInt("is_finished"),
                        rs.getInt("winner_id")
                ));
            }
        }
        logger.info(matches.toString());
        return matches;
    }

    public void save(List<Match> matches) throws SQLException, ClassNotFoundException {
        String query = "INSERT INTO MATCHES (team1_id, team2_id, match_date, team1_score, team2_score, is_finished, winner_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            for (Match match : matches) {
                pstmt.setInt(1, match.team1_id());
                pstmt.setInt(2, match.team2_id());
                pstmt.setString(3, match.match_date());
                pstmt.setInt(4, match.team1_score());
                pstmt.setInt(5, match.team2_score());
                pstmt.setInt(6, match.is_finished());
                pstmt.setInt(7, match.winner_id());

                int rowsAffected = pstmt.executeUpdate();
                System.out.println("Rows affected: " + rowsAffected);
            }
        }catch (Exception e){
            System.out.println(e.getMessage());
        }
    }

    public void update(List<Match> matches) throws SQLException, ClassNotFoundException {
        String query = "UPDATE MATCHES SET " +
                "team1_id = ?, team2_id = ?, team1_score = ?, team2_score = ?, " +
                "is_finished = ?, winner_id = ? " +
                "WHERE match_date = ?";

        try (Connection conn = getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            for (Match match : matches) {
                pstmt.setInt(1, match.team1_id());
                pstmt.setInt(2, match.team2_id());
                pstmt.setInt(3, match.team1_score());
                pstmt.setInt(4, match.team2_score());
                pstmt.setInt(5, match.is_finished());
                pstmt.setInt(6, match.winner_id());
                pstmt.setString(7, match.match_date()); // match_date를 기준으로 업데이트
                pstmt.executeUpdate();
            }

            query = "UPDATE SCHEDULER SET last_update_date = ? WHERE id = 1";
            try (PreparedStatement pstmt2 = conn.prepareStatement(query)){
                pstmt2.setString(1, LocalDate.now().toString());
                System.out.println(LocalDate.now().toString());
                pstmt2.executeUpdate();
                System.out.println("날짜 수정");
            }catch (Exception e){
                System.out.println(e.getMessage());
            }

        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

    public List<MatchWithTeams> getMatchwithTeams(){
        List<MatchWithTeams> result = new ArrayList<>();

        try (Connection conn = getConnection(URL, USER, PASSWORD)) {
            String query = "SELECT m.*, t1.team_id as t1_id, t1.team_name as t1_name, t1.team_rank as t1_rank, " +
                    "t2.team_id as t2_id, t2.team_name as t2_name, t2.team_rank as t2_rank " +
                    "FROM MATCHES m " +
                    "JOIN LCK_TEAMS t1 ON m.team1_id = t1.team_id " +
                    "JOIN LCK_TEAMS t2 ON m.team2_id = t2.team_id " +
                    "ORDER BY m.match_date";

            try (PreparedStatement pstmt = conn.prepareStatement(query);
                 ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    Match match = new Match(
                            rs.getInt("match_id"),
                            rs.getInt("team1_id"),
                            rs.getInt("team2_id"),
                            rs.getString("match_date"),
                            rs.getInt("team1_score"),
                            rs.getInt("team2_score"),
                            rs.getInt("is_finished"),
                            rs.getInt("winner_id")
                    );

                    Team team1 = new Team(
                            rs.getInt("t1_id"),
                            rs.getString("t1_name"),
                            rs.getInt("t1_rank")
                    );

                    Team team2 = new Team(
                            rs.getInt("t2_id"),
                            rs.getString("t2_name"),
                            rs.getInt("t2_rank")
                    );

                    result.add(new MatchWithTeams(match, team1, team2, null));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return result;
    }

    public Match findById(int matchId) throws SQLException, ClassNotFoundException {
        String query = "SELECT * FROM MATCHES WHERE match_id = ?";

        try (Connection conn = getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, matchId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Match(
                            rs.getInt("match_id"),
                            rs.getInt("team1_id"),
                            rs.getInt("team2_id"),
                            rs.getString("match_date"),
                            rs.getInt("team1_score"),
                            rs.getInt("team2_score"),
                            rs.getInt("is_finished"),
                            rs.getInt("winner_id")
                    );
                }
            }
        }

        return null;
    }
}