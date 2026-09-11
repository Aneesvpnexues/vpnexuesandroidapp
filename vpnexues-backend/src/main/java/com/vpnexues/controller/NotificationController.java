package com.vpnexues.controller;

import com.vpnexues.dto.ApiResponse;
import com.vpnexues.dto.NotificationSettingsRequest;
import com.vpnexues.model.Notification;
import com.vpnexues.model.NotificationSettings;
import com.vpnexues.service.NotificationService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @GetMapping
    public ResponseEntity<List<Notification>> getNotifications() {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(notificationService.getNotifications(userId));
    }

    @GetMapping("/unread-count")
    public ResponseEntity<Map<String, Long>> getUnreadCount() {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        long count = notificationService.getUnreadCount(userId);
        return ResponseEntity.ok(Map.of("count", count));
    }

    @PutMapping("/{id}/read")
    public ResponseEntity<ApiResponse> markAsRead(@PathVariable String id) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        notificationService.markAsRead(userId, id);
        return ResponseEntity.ok(ApiResponse.success("Notification marked as read"));
    }

    @PutMapping("/read-all")
    public ResponseEntity<ApiResponse> markAllAsRead() {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        notificationService.markAllAsRead(userId);
        return ResponseEntity.ok(ApiResponse.success("All notifications marked as read"));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse> deleteNotification(@PathVariable String id) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        notificationService.deleteNotification(userId, id);
        return ResponseEntity.ok(ApiResponse.success("Notification deleted"));
    }

    @GetMapping("/settings")
    public ResponseEntity<NotificationSettings> getSettings() {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(notificationService.getSettings(userId));
    }

    @PutMapping("/settings")
    public ResponseEntity<NotificationSettings> updateSettings(@RequestBody NotificationSettingsRequest request) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(notificationService.updateSettings(userId, request));
    }
}
