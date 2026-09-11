package com.vpnexues.controller;

import com.vpnexues.dto.AuthResponse;
import com.vpnexues.dto.SendOtpRequest;
import com.vpnexues.dto.UpdateProfileRequest;
import com.vpnexues.dto.VerifyOtpRequest;
import com.vpnexues.dto.ApiResponse;
import com.vpnexues.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/send-otp")
    public ResponseEntity<ApiResponse> sendOtp(@Valid @RequestBody SendOtpRequest request) {
        authService.sendOtp(request.getEmail());
        return ResponseEntity.ok(ApiResponse.success("OTP sent successfully"));
    }

    @PostMapping("/verify-otp")
    public ResponseEntity<AuthResponse> verifyOtp(@Valid @RequestBody VerifyOtpRequest request) {
        AuthResponse response = authService.verifyOtp(request.getEmail(), request.getOtp());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/me")
    public ResponseEntity<AuthResponse.UserInfo> getProfile() {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(authService.getUserById(userId));
    }

    @PutMapping("/profile")
    public ResponseEntity<AuthResponse.UserInfo> updateProfile(@Valid @RequestBody UpdateProfileRequest request) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(authService.updateProfile(userId, request));
    }
}
