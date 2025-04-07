package com.example.predict_match.controller;

import com.example.predict_match.model.repository.*;
import com.example.predict_match.service.ScheduleService;

public class test {
    public static void main(String[] args) throws Exception {
        ScheduleService scheduleService = new ScheduleService(new JsoupRepository(), new JsoupTeamRepository(), new ScheduleRepository(new JsoupRepository()), new MatchRepository(new JsoupRepository()), new TeamRepository());
        scheduleService.check();
    }
}
