/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.service.EmailService
 *  jakarta.mail.internet.MimeMessage
 *  org.springframework.beans.factory.annotation.Value
 *  org.springframework.mail.javamail.JavaMailSender
 *  org.springframework.mail.javamail.MimeMessageHelper
 *  org.springframework.scheduling.annotation.Async
 *  org.springframework.stereotype.Service
 *  org.thymeleaf.TemplateEngine
 *  org.thymeleaf.context.Context
 *  org.thymeleaf.context.IContext
 */
package com.vpnexues.service;

import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.context.IContext;

@Service
public class EmailService {
    private final JavaMailSender mailSender;
    private final TemplateEngine templateEngine;
    @Value(value="${app.email.from}")
    private String fromEmail;

    @Async
    public void sendOtpEmail(String toEmail, String otp) {
        try {
            MimeMessage message = this.mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setFrom(this.fromEmail, "VPNexues");
            helper.setTo(toEmail);
            helper.setSubject("Your VPNexues Verification Code");
            Context context = new Context();
            context.setVariable("otp", (Object)otp);
            String htmlContent = this.templateEngine.process("otp-email", (IContext)context);
            helper.setText(htmlContent, true);
            this.mailSender.send(message);
        }
        catch (Exception exception) {
            // empty catch block
        }
    }

    public EmailService(JavaMailSender mailSender, TemplateEngine templateEngine) {
        this.mailSender = mailSender;
        this.templateEngine = templateEngine;
    }
}

