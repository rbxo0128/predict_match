// 새로운 HomeService 클래스
package com.example.predict_match.service;

import com.example.predict_match.model.dto.*;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
public class MainPageService {

    private final MatchService matchService;
    private final TeamService teamService;

    public MainPageService(MatchService matchService, TeamService teamService) {
        this.matchService = matchService;
        this.teamService = teamService;
    }

    /**
     * 오늘 날짜의 경기를 가져옵니다.
     * 오늘 경기가 없으면 미래의 가장 가까운 경기를 가져옵니다.
     */
    public MainPageData getMainPageData() {
        try {
            // 경기 일정을 가져옴
            List<MatchWithTeams> allMatches = matchService.getMatchesWithTeams();

            // 오늘 날짜 가져오기
            LocalDate today = LocalDate.now();
            int currentYear = today.getYear();  // 현재 연도

            // 한국어 날짜 포맷 (예: "04월 02일 (수) 17:00")을 파싱하기 위한 패턴
            Pattern datePattern = Pattern.compile("(\\d{2})월 (\\d{2})일 \\([월화수목금토일]\\) (\\d{2}):(\\d{2})");

            // 오늘 날짜의 경기 필터링
            List<MatchWithTeams> todayMatches = filterMatchesByDate(allMatches, today, currentYear, datePattern);

            List<Team> teams = teamService.getAllTeams();

            // 오늘 경기가 없다면, 미래의 가장 가까운 경기를 찾음
            if (todayMatches.isEmpty()) {
                List<MatchWithTeams> upcomingMatches = findUpcomingMatches(allMatches, today, currentYear, datePattern);

                // 다음 경기가 있는 경우 최대 2개까지 반환
                if (!upcomingMatches.isEmpty()) {
                    int matchCount = Math.min(upcomingMatches.size(), 2);
                    String nextMatchDate = extractNextMatchDate(upcomingMatches.get(0), datePattern);

                    return new MainPageData(
                            upcomingMatches.subList(0, matchCount),
                            true,
                            false,
                            nextMatchDate,
                            teams
                    );
                } else {
                    return new MainPageData(null, false, false, null, null);
                }
            } else {
                int matchCount = Math.min(todayMatches.size(), 2);
                return new MainPageData(
                        todayMatches.subList(0, matchCount),
                        true,
                        true,
                        null,
                        teams
                );
            }
        } catch (Exception e) {
            // 로그 기록
            e.printStackTrace();
            return new MainPageData(null, false, false, null, true, null);
        }
    }

    /**
     * 주어진 날짜에 맞는 경기를 필터링합니다.
     */
    private List<MatchWithTeams> filterMatchesByDate(
            List<MatchWithTeams> matches,
            LocalDate targetDate,
            int year,
            Pattern datePattern) {

        return matches.stream()
                .filter(match -> {
                    String dateStr = match.match().match_date();
                    Matcher matcher = datePattern.matcher(dateStr);

                    if (matcher.find()) {
                        int month = Integer.parseInt(matcher.group(1));
                        int day = Integer.parseInt(matcher.group(2));

                        // LocalDate 객체 생성 (현재 연도 사용)
                        LocalDate matchDate = LocalDate.of(year, month, day);
                        return matchDate.equals(targetDate);
                    }
                    return false;
                })
                .collect(Collectors.toList());
    }

    /**
     * 오늘 이후의 경기 중 가장 가까운 경기들을 찾습니다.
     */
    private List<MatchWithTeams> findUpcomingMatches(
            List<MatchWithTeams> matches,
            LocalDate today,
            int year,
            Pattern datePattern) {

        return matches.stream()
                .filter(match -> {
                    String dateStr = match.match().match_date();
                    Matcher matcher = datePattern.matcher(dateStr);

                    if (matcher.find()) {
                        int month = Integer.parseInt(matcher.group(1));
                        int day = Integer.parseInt(matcher.group(2));

                        // LocalDate 객체 생성 (현재 연도 사용)
                        LocalDate matchDate = LocalDate.of(year, month, day);
                        // 미래 날짜이고 경기가 끝나지 않은 경우
                        return matchDate.isAfter(today) && match.match().is_finished() == 0;
                    }
                    return false;
                })
                .sorted((m1, m2) -> {
                    // 날짜 기준으로 정렬 (가장 가까운 미래 날짜 먼저)
                    String date1 = m1.match().match_date();
                    String date2 = m2.match().match_date();

                    Matcher matcher1 = datePattern.matcher(date1);
                    Matcher matcher2 = datePattern.matcher(date2);

                    if (matcher1.find() && matcher2.find()) {
                        int month1 = Integer.parseInt(matcher1.group(1));
                        int day1 = Integer.parseInt(matcher1.group(2));

                        int month2 = Integer.parseInt(matcher2.group(1));
                        int day2 = Integer.parseInt(matcher2.group(2));

                        // 날짜 비교
                        LocalDate d1 = LocalDate.of(year, month1, day1);
                        LocalDate d2 = LocalDate.of(year, month2, day2);

                        int dateCompare = d1.compareTo(d2);
                        if (dateCompare != 0) {
                            return dateCompare;
                        }

                        // 같은 날짜면 시간 비교
                        int time1 = Integer.parseInt(matcher1.group(3) + matcher1.group(4));
                        int time2 = Integer.parseInt(matcher2.group(3) + matcher2.group(4));
                        return Integer.compare(time1, time2);
                    }

                    // 날짜 형식이 다르면 문자열 자체를 비교
                    return date1.compareTo(date2);
                })
                .collect(Collectors.toList());
    }

    /**
     * 다음 경기 날짜를 추출합니다.
     */
    private String extractNextMatchDate(MatchWithTeams match, Pattern datePattern) {
        String nextMatchDate = match.match().match_date();
        Matcher matcher = datePattern.matcher(nextMatchDate);
        if (matcher.find()) {
            return matcher.group(1) + "월 " + matcher.group(2) + "일";
        } else {
            return nextMatchDate;
        }
    }
}