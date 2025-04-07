package com.example.predict_match.controller;

import com.example.predict_match.model.repository.JsoupRepository;
import com.example.predict_match.model.repository.JsoupTeamRepository;
import com.example.predict_match.model.repository.MatchRepository;

public class test {
    public static void main(String[] args) throws Exception {
        JsoupTeamRepository repository = new JsoupTeamRepository();
        repository.getMatches();
    }
}
