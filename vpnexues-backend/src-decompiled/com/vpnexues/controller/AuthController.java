/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.controller.AuthController
 *  com.vpnexues.dto.ApiResponse
 *  com.vpnexues.dto.AuthResponse
 *  com.vpnexues.dto.AuthResponse$UserInfo
 *  com.vpnexues.dto.SendOtpRequest
 *  com.vpnexues.dto.UpdateProfileRequest
 *  com.vpnexues.dto.VerifyOtpRequest
 *  com.vpnexues.security.JwtTokenProvider
 *  com.vpnexues.service.AuthService
 *  jakarta.validation.Valid
 *  org.springframework.http.ResponseEntity
 *  org.springframework.security.core.Authentication
 *  org.springframework.security.core.context.SecurityContextHolder
 *  org.springframework.web.bind.annotation.GetMapping
 *  org.springframework.web.bind.annotation.PostMapping
 *  org.springframework.web.bind.annotation.PutMapping
 *  org.springframework.web.bind.annotation.RequestBody
 *  org.springframework.web.bind.annotation.RequestMapping
 *  org.springframework.web.bind.annotation.RestController
 */
package com.vpnexues.controller;

import com.vpnexues.dto.ApiResponse;
import com.vpnexues.dto.AuthResponse;
import com.vpnexues.dto.SendOtpRequest;
import com.vpnexues.dto.UpdateProfileRequest;
import com.vpnexues.dto.VerifyOtpRequest;
import com.vpnexues.security.JwtTokenProvider;
import com.vpnexues.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value={"/api/auth"})
public class AuthController {
    private final AuthService authService;
    private final JwtTokenProvider jwtTokenProvider;

    @PostMapping(value={"/send-otp"})
    public ResponseEntity<ApiResponse> sendOtp(@Valid @RequestBody SendOtpRequest request) {
        this.authService.sendOtp(request.getEmail());
        return ResponseEntity.ok((Object)ApiResponse.success((String)"OTP sent successfully"));
    }

    @PostMapping(value={"/verify-otp"})
    public ResponseEntity<?> verifyOtp(@Valid @RequestBody VerifyOtpRequest request) {
        try {
            AuthResponse response = this.authService.verifyOtp(request);
            return ResponseEntity.ok((Object)response);
        }
        catch (RuntimeException e) {
            return ResponseEntity.badRequest().body((Object)ApiResponse.error((String)(e.getMessage() != null ? e.getMessage() : "Invalid or expired OTP")));
        }
    }

    @GetMapping(value={"/me"})
    public ResponseEntity<AuthResponse.UserInfo> getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String userId = auth.getName();
        AuthResponse.UserInfo user = this.authService.getUserById(userId);
        return ResponseEntity.ok((Object)user);
    }

    @PutMapping(value={"/profile"})
    public ResponseEntity<AuthResponse.UserInfo> updateProfile(@RequestBody UpdateProfileRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String userId = auth.getName();
        AuthResponse.UserInfo user = this.authService.updateProfile(userId, request);
        return ResponseEntity.ok((Object)user);
    }

    public AuthController(AuthService authService, JwtTokenProvider jwtTokenProvider) {
        this.authService = authService;
        this.jwtTokenProvider = jwtTokenProvider;
    }
}

