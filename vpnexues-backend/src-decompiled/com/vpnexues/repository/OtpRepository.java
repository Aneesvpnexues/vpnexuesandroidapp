/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.Otp
 *  com.vpnexues.repository.OtpRepository
 *  org.springframework.data.mongodb.repository.MongoRepository
 */
package com.vpnexues.repository;

import com.vpnexues.model.Otp;
import java.time.Instant;
import java.util.Optional;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface OtpRepository
extends MongoRepository<Otp, String> {
    public Optional<Otp> findByEmailAndOtpAndVerifiedFalseAndExpiresAtAfter(String var1, String var2, Instant var3);

    public void deleteByEmail(String var1);
}

