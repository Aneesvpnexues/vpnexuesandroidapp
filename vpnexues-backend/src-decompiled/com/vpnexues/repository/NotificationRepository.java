/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.Notification
 *  com.vpnexues.repository.NotificationRepository
 *  org.springframework.data.mongodb.repository.MongoRepository
 *  org.springframework.stereotype.Repository
 */
package com.vpnexues.repository;

import com.vpnexues.model.Notification;
import java.util.List;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NotificationRepository
extends MongoRepository<Notification, String> {
    public List<Notification> findByUserIdOrderByCreatedAtDesc(String var1);

    public long countByUserIdAndIsReadFalse(String var1);

    public List<Notification> findByUserIdAndIsReadFalse(String var1);

    public void deleteByUserIdAndId(String var1, String var2);
}

