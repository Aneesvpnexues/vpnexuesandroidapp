package com.vpnexues.service;

import com.vpnexues.dto.AuthResponse;
import com.vpnexues.dto.SendOtpRequest;
import com.vpnexues.dto.UpdateProfileRequest;
import com.vpnexues.dto.VerifyOtpRequest;
import com.vpnexues.model.Otp;
import com.vpnexues.model.User;
import com.vpnexues.repository.OtpRepository;
import com.vpnexues.repository.UserRepository;
import com.vpnexues.security.JwtTokenProvider;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final OtpRepository otpRepository;
    private final JwtTokenProvider jwtTokenProvider;
    private final EmailService emailService;
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    public AuthService(UserRepository userRepository, OtpRepository otpRepository,
                       JwtTokenProvider jwtTokenProvider, EmailService emailService) {
        this.userRepository = userRepository;
        this.otpRepository = otpRepository;
        this.jwtTokenProvider = jwtTokenProvider;
        this.emailService = emailService;
    }

    public void sendOtp(String email) {
        otpRepository.deleteByEmail(email);
        String otp = String.format("%06d", SECURE_RANDOM.nextInt(1000000));
        Otp otpEntity = new Otp();
        otpEntity.setId(UUID.randomUUID().toString());
        otpEntity.setEmail(email);
        otpEntity.setOtp(otp);
        otpEntity.setExpiresAt(Instant.now().plusSeconds(300));
        otpRepository.save(otpEntity);
        emailService.sendOtpEmail(email, otp);
    }

    @Transactional
    public AuthResponse verifyOtp(String email, String otpCode) {
        Otp otpEntity = otpRepository.findByEmailAndOtpAndVerifiedFalseAndExpiresAtAfter(email, otpCode, Instant.now())
                .orElseThrow(() -> new RuntimeException("Invalid or expired OTP"));
        otpEntity.setVerified(true);
        otpRepository.save(otpEntity);

        Optional<User> existingUser = userRepository.findByEmail(email);
        User user;
        if (existingUser.isPresent()) {
            user = existingUser.get();
        } else {
            user = new User();
            user.setId(UUID.randomUUID().toString());
            user.setEmail(email);
            user = userRepository.save(user);
        }

        String token = jwtTokenProvider.generateToken(user.getId(), user.getEmail());
        AuthResponse response = new AuthResponse();
        response.setMessage("OTP verified successfully");
        response.setToken(token);
        response.setUser(toUserInfo(user));
        return response;
    }

    public AuthResponse.UserInfo getUserById(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return toUserInfo(user);
    }

    @Transactional
    public AuthResponse.UserInfo updateProfile(String userId, UpdateProfileRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        if (request.getName() != null) {
            user.setName(request.getName());
        }
        if (request.getPhone() != null) {
            user.setPhone(request.getPhone());
        }
        if (request.getLanguage() != null) {
            user.setLanguage(request.getLanguage());
        }
        user = userRepository.save(user);
        return toUserInfo(user);
    }

    private AuthResponse.UserInfo toUserInfo(User user) {
        AuthResponse.UserInfo info = new AuthResponse.UserInfo();
        info.setId(user.getId());
        info.setEmail(user.getEmail());
        info.setName(user.getName());
        info.setPhone(user.getPhone());
        info.setLanguage(user.getLanguage());
        return info;
    }
}
