package com.example.predict_match.model.repository;

import com.example.predict_match.model.dto.Match;
import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.stereotype.Repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Logger;

@Repository
public class ScheduleRepository implements JDBCRepository {
    final Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
    final Logger logger = Logger.getLogger(ScheduleRepository.class.getName());
    final JsoupRepository jsoupRepository;
    public final String URL = dotenv.get("DB_URL");
    public final String USER = dotenv.get("DB_USER");
    public final String PASSWORD = dotenv.get("DB_PASSWORD");

    public ScheduleRepository(JsoupRepository jsoupRepository) {
        this.jsoupRepository = jsoupRepository;
    }

    public boolean check() throws Exception {
        try (Connection conn = getConnection(URL, USER, PASSWORD)) {
            String query = "SELECT * FROM SCHEDULER";
            try (PreparedStatement pstmt = conn.prepareStatement(query);
                 ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String lastUpdate = rs.getString("last_update_date");
                    LocalDate dbDate = LocalDate.parse(lastUpdate);
                    LocalDate today = LocalDate.now();

                    if (dbDate.equals(today)) {
                        logger.info("DB의 날짜와 오늘 날짜가 같습니다");
                        return true;
                    }
                    else {
                        logger.info("DB의 날짜와 오늘 날짜가 다릅니다");
                        return false;
                    }
                }
            }
        } catch (Exception e) {
            logger.severe(e.getMessage());
        }
        return false;
    }
}
