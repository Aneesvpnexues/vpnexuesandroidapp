package com.vpnexues.service;

import com.vpnexues.dto.NotificationSettingsRequest;
import com.vpnexues.model.Notification;
import com.vpnexues.model.NotificationSettings;
import com.vpnexues.repository.NotificationRepository;
import com.vpnexues.repository.NotificationSettingsRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Service
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final NotificationSettingsRepository notificationSettingsRepository;

    public NotificationService(NotificationRepository notificationRepository,
                               NotificationSettingsRepository notificationSettingsRepository) {
        this.notificationRepository = notificationRepository;
        this.notificationSettingsRepository = notificationSettingsRepository;
    }

    public List<Notification> getNotifications(String userId) {
        return notificationRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public long getUnreadCount(String userId) {
        return notificationRepository.countByUserIdAndIsReadFalse(userId);
    }

    @Transactional
    public void markAsRead(String userId, String notificationId) {
        List<Notification> notifications = notificationRepository.findByUserIdOrderByCreatedAtDesc(userId);
        for (Notification notification : notifications) {
            if (notification.getId().equals(notificationId) && notification.getUserId().equals(userId)) {
                notification.setRead(true);
                notification.setUpdatedAt(Instant.now());
                notificationRepository.save(notification);
                return;
            }
        }
        throw new RuntimeException("Notification not found");
    }

    @Transactional
    public void markAllAsRead(String userId) {
        List<Notification> notifications = notificationRepository.findByUserIdAndIsReadFalse(userId);
        for (Notification notification : notifications) {
            notification.setRead(true);
            notification.setUpdatedAt(Instant.now());
        }
        notificationRepository.saveAll(notifications);
    }

    @Transactional
    public void deleteNotification(String userId, String notificationId) {
        notificationRepository.deleteByUserIdAndId(userId, notificationId);
    }

    @Transactional
    public Notification createNotification(String userId, String title, String message, String type) {
        Notification notification = new Notification();
        notification.setId(UUID.randomUUID().toString());
        notification.setUserId(userId);
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setType(type);
        notification = notificationRepository.save(notification);
        return notification;
    }

    public NotificationSettings getSettings(String userId) {
        return notificationSettingsRepository.findByUserId(userId).orElseGet(() -> {
            NotificationSettings settings = new NotificationSettings();
            settings.setId(UUID.randomUUID().toString());
            settings.setUserId(userId);
            return notificationSettingsRepository.save(settings);
        });
    }

    @Transactional
    public NotificationSettings updateSettings(String userId, NotificationSettingsRequest request) {
        NotificationSettings settings = getSettings(userId);
        settings.setOrderUpdates(request.isOrderUpdates());
        settings.setDeliveryUpdates(request.isDeliveryUpdates());
        settings.setCouponsDeals(request.isCouponsDeals());
        settings.setPromotions(request.isPromotions());
        settings.setNewArrivals(request.isNewArrivals());
        settings.setPriceDropAlerts(request.isPriceDropAlerts());
        settings.setWeeklyDeals(request.isWeeklyDeals());
        settings.setEmailNotifications(request.isEmailNotifications());
        return notificationSettingsRepository.save(settings);
    }
}
