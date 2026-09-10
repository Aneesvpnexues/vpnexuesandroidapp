/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.controller.NotificationController
 *  com.vpnexues.dto.NotificationSettingsRequest
 *  com.vpnexues.model.Notification
 *  com.vpnexues.model.NotificationSettings
 *  com.vpnexues.service.NotificationService
 *  jakarta.validation.Valid
 *  org.springframework.http.ResponseEntity
 *  org.springframework.security.core.Authentication
 *  org.springframework.security.core.context.SecurityContextHolder
 *  org.springframework.web.bind.annotation.DeleteMapping
 *  org.springframework.web.bind.annotation.GetMapping
 *  org.springframework.web.bind.annotation.PathVariable
 *  org.springframework.web.bind.annotation.PutMapping
 *  org.springframework.web.bind.annotation.RequestBody
 *  org.springframework.web.bind.annotation.RequestMapping
 *  org.springframework.web.bind.annotation.RestController
 */
package com.vpnexues.controller;

import com.vpnexues.dto.NotificationSettingsRequest;
import com.vpnexues.model.Notification;
import com.vpnexues.model.NotificationSettings;
import com.vpnexues.service.NotificationService;
import jakarta.validation.Valid;
import java.util.List;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value={"/api/notifications"})
public class NotificationController {
    private final NotificationService notificationService;

    private String getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getName();
    }

    @GetMapping
    public ResponseEntity<List<Notification>> getNotifications() {
        String userId = this.getCurrentUserId();
        return ResponseEntity.ok((Object)this.notificationService.getNotifications(userId));
    }

    @GetMapping(value={"/unread-count"})
    public ResponseEntity<Map<String, Object>> getUnreadCount() {
        String userId = this.getCurrentUserId();
        long count = this.notificationService.getUnreadCount(userId);
        return ResponseEntity.ok(Map.of("count", count));
    }

    @PutMapping(value={"/{id}/read"})
    public ResponseEntity<Map<String, Object>> markAsRead(@PathVariable String id) {
        String userId = this.getCurrentUserId();
        Notification notification = this.notificationService.markAsRead(userId, id);
        return ResponseEntity.ok(Map.of("message", "Notification marked as read", "notification", notification));
    }

    @PutMapping(value={"/read-all"})
    public ResponseEntity<Map<String, String>> markAllAsRead() {
        String userId = this.getCurrentUserId();
        this.notificationService.markAllAsRead(userId);
        return ResponseEntity.ok(Map.of("message", "All notifications marked as read"));
    }

    @DeleteMapping(value={"/{id}"})
    public ResponseEntity<Map<String, String>> deleteNotification(@PathVariable String id) {
        String userId = this.getCurrentUserId();
        this.notificationService.deleteNotification(userId, id);
        return ResponseEntity.ok(Map.of("message", "Notification deleted"));
    }

    @GetMapping(value={"/settings"})
    public ResponseEntity<NotificationSettings> getSettings() {
        String userId = this.getCurrentUserId();
        return ResponseEntity.ok((Object)this.notificationService.getSettings(userId));
    }

    @PutMapping(value={"/settings"})
    public ResponseEntity<NotificationSettings> updateSettings(@Valid @RequestBody NotificationSettingsRequest request) {
        String userId = this.getCurrentUserId();
        return ResponseEntity.ok((Object)this.notificationService.updateSettings(userId, request));
    }

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }
}

