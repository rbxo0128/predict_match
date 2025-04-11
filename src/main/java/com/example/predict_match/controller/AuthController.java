package com.example.predict_match.controller;

import com.example.predict_match.model.dto.SignUpRequest;
import com.example.predict_match.model.dto.User;
import com.example.predict_match.service.UserService;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

@Controller
public class AuthController {
    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/signup")
    public String signupForm(Model model) {
        model.addAttribute("signUpRequest", new SignUpRequest(null, null, null));
        return "signup";
    }

    @PostMapping("/signup")
    public String signup(@Valid @ModelAttribute SignUpRequest signUpRequest,
                         BindingResult bindingResult,
                         Model model) {
        if (bindingResult.hasErrors()) {
            return "signup";
        }

        try {
            userService.registerNewUser(signUpRequest);
            return "redirect:/login?signup=success";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "signup";
        } catch (Exception e) {
            model.addAttribute("error", "회원가입 중 오류가 발생했습니다.");
            return "signup";
        }
    }

    @GetMapping("/login")
    public String loginForm() {
        return "login";
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordForm() {
        return "forgot-password";
    }

    @PostMapping("/forgot-password")
    public String processForgotPassword(@RequestParam("email") String email,
                                        Model model,
                                        RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOptional = userService.findByEmail(email);
            if (userOptional.isEmpty()) {
                model.addAttribute("error", "해당 이메일 주소로 등록된 계정을 찾을 수 없습니다.");
                return "forgot-password";
            }

            // 세션에 이메일 저장 또는 임시 토큰 생성
            redirectAttributes.addAttribute("email", email);
            return "redirect:/reset-password";
        } catch (Exception e) {
            model.addAttribute("error", "처리 중 오류가 발생했습니다: " + e.getMessage());
            return "forgot-password";
        }
    }

    @GetMapping("/reset-password")
    public String showResetPasswordForm(@RequestParam("email") String email, Model model) {
        model.addAttribute("email", email);
        return "reset-password";
    }

    @PostMapping("/reset-password")
    public String processResetPassword(@RequestParam("email") String email,
                                       @RequestParam("password") String newPassword,
                                       Model model) {
        try {
            userService.updatePassword(email, newPassword);
            return "redirect:/login?reset=success";
        } catch (Exception e) {
            model.addAttribute("error", "비밀번호 변경 중 오류가 발생했습니다: " + e.getMessage());
            model.addAttribute("email", email);
            return "reset-password";
        }
    }
}