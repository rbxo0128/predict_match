package com.example.predict_match.service;

import com.example.predict_match.model.dto.Team;
import com.example.predict_match.model.repository.TeamRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TeamService {
    private final TeamRepository teamRepository;

    public TeamService(TeamRepository teamRepository) {
        this.teamRepository = teamRepository;
    }

    public List<Team> getAllTeams() throws Exception {
        return teamRepository.findAll();
    }

    public Team getTeamById(int teamId) throws Exception {
        return teamRepository.findById(teamId);
    }
}
