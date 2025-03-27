package com.example.predict_match.controller;

import com.example.predict_match.model.dto.SignUpRequest;
import com.example.predict_match.service.UserService;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

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
}