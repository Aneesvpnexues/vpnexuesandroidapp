package com.vpnexues.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;

@Service
public class EmailService {

    private final JavaMailSender javaMailSender;
    private final TemplateEngine templateEngine;

    @Value("${app.email.from:}")
    private String fromEmail;

    public EmailService(JavaMailSender javaMailSender, TemplateEngine templateEngine) {
        this.javaMailSender = javaMailSender;
        this.templateEngine = templateEngine;
    }

    @Async
    public void sendOtpEmail(String toEmail, String otp) {
        try {
            Context context = new Context();
            context.setVariable("otp", otp);
            String htmlContent = templateEngine.process("otp-email", context);

            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            String sender = (fromEmail != null && !fromEmail.isBlank()) ? fromEmail : "noreply@vpnexues.com";
            helper.setFrom(sender);
            helper.setTo(toEmail);
            helper.setSubject("VPNexues - Your Verification Code");
            helper.setText(htmlContent, true);
            javaMailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send OTP email", e);
        }
    }
}
