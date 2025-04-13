package com.example.predict_match.service;

import com.example.predict_match.model.dto.Match;
import com.example.predict_match.model.dto.Team;
import com.example.predict_match.model.repository.*;
import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.logging.Logger;

@Service
public class ScheduleService {
    final Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
    final Logger logger = Logger.getLogger(ScheduleService.class.getName());
    final JsoupRepository jsoupRepository;
    final JsoupTeamRepository jsoupTeamRepository;
    final ScheduleRepository scheduleRepository;
    final MatchRepository matchRepository;
    final TeamRepository teamRepository;

    public ScheduleService(JsoupRepository jsoupRepository, JsoupTeamRepository jsoupTeamRepository, ScheduleRepository scheduleRepository, MatchRepository matchRepository, TeamRepository teamRepository) {
        this.jsoupRepository = jsoupRepository;
        this.jsoupTeamRepository = jsoupTeamRepository;
        this.scheduleRepository = scheduleRepository;
        this.matchRepository = matchRepository;
        this.teamRepository = teamRepository;
    }

    public void check() throws Exception {
        if (!scheduleRepository.check()){
            List<Match> matches = jsoupRepository.getMatches(4);
            matchRepository.update(matches);
            List<Team> teams = jsoupTeamRepository.getTeams();
            logger.info(teams.toString());
            teamRepository.update(teams);
        }
    }
}
