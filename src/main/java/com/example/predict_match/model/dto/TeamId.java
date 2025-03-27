package com.example.predict_match.model.dto;

public enum TeamId {
    한화생명(1),
    T1(2),
    젠지(3),
    KT(4),
    DRX(5),
    DNF(6),
    농심(7),
    OK저축은행(8),
    BFX(9),
    DK(10);

    private final int id;

    TeamId(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public static int fromAcronym(String acronym) {
        for (TeamId team : values()) {
            if (team.name().equalsIgnoreCase(acronym)) {
                return team.getId();
            }
        }
        throw new IllegalArgumentException("Unknown team acronym: " + acronym);
    }
}
