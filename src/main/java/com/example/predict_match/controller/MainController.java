package com.example.predict_match.controller;

import com.example.predict_match.model.dto.MatchWithTeams;
import com.example.predict_match.model.dto.SignUpRequest;
import com.example.predict_match.service.MatchService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDate;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Controller
public class MainController {

    private final MatchService matchService;

    public MainController(MatchService matchService) {
        this.matchService = matchService;
    }

    @GetMapping("/")
    public String index(Model model) {
        try {
            // 경기 일정을 가져옴
            List<MatchWithTeams> allMatches = matchService.getMatchesWithTeams();

            // 오늘 날짜 가져오기
            LocalDate today = LocalDate.now();
            int currentYear = today.getYear();  // 현재 연도

            // 한국어 날짜 포맷 (예: "04월 02일 (수) 17:00")을 파싱하기 위한 패턴
            Pattern datePattern = Pattern.compile("(\\d{2})월 (\\d{2})일 \\([월화수목금토일]\\) (\\d{2}):(\\d{2})");

            // 오늘 날짜의 경기 필터링
            List<MatchWithTeams> todayMatches = allMatches.stream()
                    .filter(match -> {
                        String dateStr = match.match().match_date();
                        Matcher matcher = datePattern.matcher(dateStr);

                        if (matcher.find()) {
                            int month = Integer.parseInt(matcher.group(1));
                            int day = Integer.parseInt(matcher.group(2));

                            // LocalDate 객체 생성 (현재 연도 사용)
                            LocalDate matchDate = LocalDate.of(currentYear, month, day);
                            return matchDate.equals(today);
                        }
                        return false;
                    })
                    .collect(Collectors.toList());

            // 오늘 경기가 없다면, 미래의 가장 가까운 경기를 찾음
            if (todayMatches.isEmpty()) {
                List<MatchWithTeams> upcomingMatches = allMatches.stream()
                        .filter(match -> {
                            String dateStr = match.match().match_date();
                            Matcher matcher = datePattern.matcher(dateStr);

                            if (matcher.find()) {
                                int month = Integer.parseInt(matcher.group(1));
                                int day = Integer.parseInt(matcher.group(2));

                                // LocalDate 객체 생성 (현재 연도 사용)
                                LocalDate matchDate = LocalDate.of(currentYear, month, day);
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
                                LocalDate d1 = LocalDate.of(currentYear, month1, day1);
                                LocalDate d2 = LocalDate.of(currentYear, month2, day2);

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

                // 다음 경기가 있는 경우 최대 3개까지 전달
                if (!upcomingMatches.isEmpty()) {
                    int matchCount = Math.min(upcomingMatches.size(), 2);
                    model.addAttribute("todayMatches", upcomingMatches.subList(0, matchCount));
                    model.addAttribute("hasMatches", true);

                    // 다음 경기 날짜 추출 (표시용)
                    String nextMatchDate = upcomingMatches.get(0).match().match_date();
                    Matcher matcher = datePattern.matcher(nextMatchDate);
                    if (matcher.find()) {
                        String formattedDate = matcher.group(1) + "월 " + matcher.group(2) + "일";
                        model.addAttribute("nextMatchDate", formattedDate);
                    } else {
                        model.addAttribute("nextMatchDate", nextMatchDate);
                    }
                } else {
                    model.addAttribute("hasMatches", false);
                }
            } else {
                int matchCount = Math.min(todayMatches.size(), 2);
                model.addAttribute("todayMatches", todayMatches.subList(0, matchCount));
                model.addAttribute("hasMatches", true);
                model.addAttribute("isToday", true);
            }

        } catch (Exception e) {
            // 에러 발생 시 빈 페이지를 보여주되 로그는 남김
            System.err.println("메인 페이지 경기 로딩 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("hasMatches", false);
            model.addAttribute("loadError", true);
        }

        return "index";
    }
}