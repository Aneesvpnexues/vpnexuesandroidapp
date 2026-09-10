/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.dto.AuthResponse
 *  com.vpnexues.dto.AuthResponse$UserInfo
 *  com.vpnexues.dto.UpdateProfileRequest
 *  com.vpnexues.dto.VerifyOtpRequest
 *  com.vpnexues.model.Otp
 *  com.vpnexues.model.User
 *  com.vpnexues.repository.OtpRepository
 *  com.vpnexues.repository.UserRepository
 *  com.vpnexues.security.JwtTokenProvider
 *  com.vpnexues.service.AuthService
 *  com.vpnexues.service.EmailService
 *  org.springframework.stereotype.Service
 */
package com.vpnexues.service;

import com.vpnexues.dto.AuthResponse;
import com.vpnexues.dto.UpdateProfileRequest;
import com.vpnexues.dto.VerifyOtpRequest;
import com.vpnexues.model.Otp;
import com.vpnexues.model.User;
import com.vpnexues.repository.OtpRepository;
import com.vpnexues.repository.UserRepository;
import com.vpnexues.security.JwtTokenProvider;
import com.vpnexues.service.EmailService;
import java.security.SecureRandom;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import org.springframework.stereotype.Service;

@Service
public class AuthService {
    private final OtpRepository otpRepository;
    private final UserRepository userRepository;
    private final EmailService emailService;
    private final JwtTokenProvider jwtTokenProvider;
    private static final SecureRandom RANDOM = new SecureRandom();

    public void sendOtp(String email) {
        String otp = String.format("%06d", RANDOM.nextInt(1000000));
        this.otpRepository.deleteByEmail(email);
        Otp otpRecord = new Otp();
        otpRecord.setEmail(email.toLowerCase().trim());
        otpRecord.setOtp(otp);
        otpRecord.setExpiresAt(Instant.now().plus(5L, ChronoUnit.MINUTES));
        otpRecord.setVerified(false);
        this.otpRepository.save((Object)otpRecord);
        System.out.println("=== OTP for " + email + ": " + otp + " ===");
        this.emailService.sendOtpEmail(email, otp);
    }

    public AuthResponse verifyOtp(VerifyOtpRequest request) {
        Otp otpRecord = (Otp)this.otpRepository.findByEmailAndOtpAndVerifiedFalseAndExpiresAtAfter(request.getEmail().toLowerCase().trim(), request.getOtp(), Instant.now()).orElseThrow(() -> new RuntimeException("Invalid or expired OTP"));
        otpRecord.setVerified(true);
        this.otpRepository.save((Object)otpRecord);
        User user = this.userRepository.findByEmail(request.getEmail().toLowerCase().trim()).orElseGet(() -> {
            User newUser = new User();
            newUser.setEmail(request.getEmail().toLowerCase().trim());
            newUser.setName("");
            newUser.setPhone("");
            return (User)this.userRepository.save((Object)newUser);
        });
        String token = this.jwtTokenProvider.generateToken(user.getId(), user.getEmail());
        return new AuthResponse(token, new AuthResponse.UserInfo(user.getId(), user.getEmail(), user.getName(), user.getPhone(), user.getLanguage()));
    }

    public AuthResponse.UserInfo getUserById(String userId) {
        User user = (User)this.userRepository.findById((Object)userId).orElseThrow(() -> new RuntimeException("User not found"));
        return new AuthResponse.UserInfo(user.getId(), user.getEmail(), user.getName(), user.getPhone(), user.getLanguage());
    }

    public AuthResponse.UserInfo updateProfile(String userId, UpdateProfileRequest request) {
        User user = (User)this.userRepository.findById((Object)userId).orElseThrow(() -> new RuntimeException("User not found"));
        if (request.getName() != null) {
            user.setName(request.getName());
        }
        if (request.getPhone() != null) {
            user.setPhone(request.getPhone());
        }
        if (request.getLanguage() != null) {
            user.setLanguage(request.getLanguage());
        }
        User saved = (User)this.userRepository.save((Object)user);
        return new AuthResponse.UserInfo(saved.getId(), saved.getEmail(), saved.getName(), saved.getPhone(), saved.getLanguage());
    }

    public AuthService(OtpRepository otpRepository, UserRepository userRepository, EmailService emailService, JwtTokenProvider jwtTokenProvider) {
        this.otpRepository = otpRepository;
        this.userRepository = userRepository;
        this.emailService = emailService;
        this.jwtTokenProvider = jwtTokenProvider;
    }
}

