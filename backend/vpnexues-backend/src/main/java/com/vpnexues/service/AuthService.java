package com.vpnexues.service;

import com.vpnexues.model.OtpToken;
import com.vpnexues.model.User;
import com.vpnexues.repository.OtpTokenRepository;
import com.vpnexues.repository.UserRepository;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final OtpTokenRepository otpTokenRepository;

    @Autowired(required = false)
    private JavaMailSender mailSender;

    @Value("${spring.mail.username:}")
    private String fromEmail;

    public AuthService(UserRepository userRepository, OtpTokenRepository otpTokenRepository) {
        this.userRepository = userRepository;
        this.otpTokenRepository = otpTokenRepository;
    }

    public String sendOtp(String email) {
        String otp = String.format("%06d", new Random().nextInt(999999));

        otpTokenRepository.markAllAsUsedByEmail(email);

        OtpToken token = new OtpToken(email, otp, LocalDateTime.now().plusMinutes(5));
        otpTokenRepository.save(token);

        sendOtpEmail(email, otp);

        return otp;
    }

    private void sendOtpEmail(String toEmail, String otp) {
        if (mailSender == null) {
            System.out.println("=== OTP for " + toEmail + ": " + otp + " ===");
            System.out.println("(Mail not configured - OTP printed to console)");
            return;
        }

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("VPNexues - Your OTP Code");

            String htmlContent = """
                <div style="font-family: Arial, sans-serif; max-width: 500px; margin: 0 auto; padding: 20px;">
                    <div style="background: #0E5A35; color: white; padding: 20px; text-align: center; border-radius: 10px 10px 0 0;">
                        <h1 style="margin: 0; font-size: 24px;">VPNexues</h1>
                        <p style="margin: 5px 0 0; font-size: 14px;">Email Verification</p>
                    </div>
                    <div style="background: #f9f9f9; padding: 30px; border: 1px solid #e0e0e0;">
                        <p style="font-size: 16px; color: #333;">Hello,</p>
                        <p style="font-size: 14px; color: #555;">Your One-Time Password (OTP) for login is:</p>
                        <div style="text-align: center; margin: 25px 0;">
                            <span style="background: #0E5A35; color: white; font-size: 32px; font-weight: bold; padding: 15px 30px; border-radius: 8px; letter-spacing: 8px;">%s</span>
                        </div>
                        <p style="font-size: 14px; color: #555;">This OTP is valid for <strong>5 minutes</strong>.</p>
                        <p style="font-size: 14px; color: #555;">If you did not request this, please ignore this email.</p>
                    </div>
                    <div style="text-align: center; padding: 15px; font-size: 12px; color: #999;">
                        <p>&copy; 2026 VPNexues. All rights reserved.</p>
                    </div>
                </div>
                """.formatted(otp);

            helper.setText(htmlContent, true);
            mailSender.send(message);
        } catch (Exception e) {
            System.out.println("=== OTP for " + toEmail + ": " + otp + " ===");
            System.out.println("Email sending failed: " + e.getMessage());
        }
    }

    @Transactional
    public Map<String, Object> verifyOtp(String email, String otp) {
        OtpToken token = otpTokenRepository.findTopByEmailAndUsedFalseOrderByCreatedAtDesc(email)
                .orElse(null);

        if (token == null || token.isExpired()) {
            return null;
        }

        if (!token.getOtp().equals(otp)) {
            return null;
        }

        token.setUsed(true);
        otpTokenRepository.save(token);

        User user = userRepository.findByEmail(email)
                .orElseGet(() -> userRepository.save(new User(email)));

        Map<String, Object> result = new HashMap<>();
        result.put("userId", user.getId());
        result.put("email", user.getEmail());
        return result;
    }
}
