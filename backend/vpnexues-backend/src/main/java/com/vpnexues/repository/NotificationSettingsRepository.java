package com.vpnexues.repository;

import com.vpnexues.model.NotificationSettings;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface NotificationSettingsRepository extends JpaRepository<NotificationSettings, String> {
    Optional<NotificationSettings> findByUserId(String userId);
}
