/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.NotificationSettings
 *  com.vpnexues.repository.NotificationSettingsRepository
 *  org.springframework.data.mongodb.repository.MongoRepository
 *  org.springframework.stereotype.Repository
 */
package com.vpnexues.repository;

import com.vpnexues.model.NotificationSettings;
import java.util.Optional;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NotificationSettingsRepository
extends MongoRepository<NotificationSettings, String> {
    public Optional<NotificationSettings> findByUserId(String var1);
}

