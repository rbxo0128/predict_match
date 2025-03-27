package com.example.predict_match.controller;

import com.example.predict_match.model.repository.JsoupRepository;
import com.example.predict_match.model.repository.MatchRepository;

import java.sql.SQLException;

public class test {

    public static void main(String[] args) throws Exception {
        MatchRepository matchRepository = new MatchRepository(new JsoupRepository());

        matchRepository.check();
    }
}
