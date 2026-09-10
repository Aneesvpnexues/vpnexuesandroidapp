/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.dto.NotificationSettingsRequest
 *  com.vpnexues.model.Notification
 *  com.vpnexues.model.NotificationSettings
 *  com.vpnexues.repository.NotificationRepository
 *  com.vpnexues.repository.NotificationSettingsRepository
 *  com.vpnexues.service.NotificationService
 *  org.springframework.stereotype.Service
 */
package com.vpnexues.service;

import com.vpnexues.dto.NotificationSettingsRequest;
import com.vpnexues.model.Notification;
import com.vpnexues.model.NotificationSettings;
import com.vpnexues.repository.NotificationRepository;
import com.vpnexues.repository.NotificationSettingsRepository;
import java.time.Instant;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class NotificationService {
    private final NotificationRepository notificationRepository;
    private final NotificationSettingsRepository notificationSettingsRepository;

    public List<Notification> getNotifications(String userId) {
        return this.notificationRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public long getUnreadCount(String userId) {
        return this.notificationRepository.countByUserIdAndIsReadFalse(userId);
    }

    public Notification markAsRead(String userId, String notificationId) {
        Notification notification = (Notification)this.notificationRepository.findById((Object)notificationId).orElseThrow(() -> new RuntimeException("Notification not found"));
        if (!notification.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized: notification does not belong to this user");
        }
        notification.setRead(true);
        return (Notification)this.notificationRepository.save((Object)notification);
    }

    public void markAllAsRead(String userId) {
        List unread = this.notificationRepository.findByUserIdAndIsReadFalse(userId);
        for (Notification n : unread) {
            n.setRead(true);
        }
        this.notificationRepository.saveAll((Iterable)unread);
    }

    public void deleteNotification(String userId, String notificationId) {
        Notification notification = (Notification)this.notificationRepository.findById((Object)notificationId).orElseThrow(() -> new RuntimeException("Notification not found"));
        if (!notification.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized: notification does not belong to this user");
        }
        this.notificationRepository.delete((Object)notification);
    }

    public Notification createNotification(String userId, String title, String message, String type) {
        Notification notification = new Notification();
        notification.setUserId(userId);
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setType(type);
        notification.setRead(false);
        notification.setCreatedAt(Instant.now());
        return (Notification)this.notificationRepository.save((Object)notification);
    }

    public NotificationSettings getSettings(String userId) {
        return this.notificationSettingsRepository.findByUserId(userId).orElseGet(() -> {
            NotificationSettings settings = new NotificationSettings();
            settings.setUserId(userId);
            return (NotificationSettings)this.notificationSettingsRepository.save((Object)settings);
        });
    }

    public NotificationSettings updateSettings(String userId, NotificationSettingsRequest request) {
        NotificationSettings settings = this.notificationSettingsRepository.findByUserId(userId).orElseGet(() -> {
            NotificationSettings newSettings = new NotificationSettings();
            newSettings.setUserId(userId);
            return newSettings;
        });
        settings.setOrderUpdates(request.isOrderUpdates());
        settings.setDeliveryUpdates(request.isDeliveryUpdates());
        settings.setCouponsDeals(request.isCouponsDeals());
        settings.setPromotions(request.isPromotions());
        settings.setNewArrivals(request.isNewArrivals());
        settings.setPriceDropAlerts(request.isPriceDropAlerts());
        settings.setWeeklyDeals(request.isWeeklyDeals());
        settings.setEmailNotifications(request.isEmailNotifications());
        return (NotificationSettings)this.notificationSettingsRepository.save((Object)settings);
    }

    public NotificationService(NotificationRepository notificationRepository, NotificationSettingsRepository notificationSettingsRepository) {
        this.notificationRepository = notificationRepository;
        this.notificationSettingsRepository = notificationSettingsRepository;
    }
}

