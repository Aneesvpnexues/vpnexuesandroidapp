/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.User
 *  com.vpnexues.repository.UserRepository
 *  org.springframework.data.mongodb.repository.MongoRepository
 */
package com.vpnexues.repository;

import com.vpnexues.model.User;
import java.util.Optional;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface UserRepository
extends MongoRepository<User, String> {
    public Optional<User> findByEmail(String var1);
}

