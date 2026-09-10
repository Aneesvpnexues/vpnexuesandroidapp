/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.PaymentMethod
 *  com.vpnexues.repository.PaymentMethodRepository
 *  org.springframework.data.mongodb.repository.MongoRepository
 *  org.springframework.stereotype.Repository
 */
package com.vpnexues.repository;

import com.vpnexues.model.PaymentMethod;
import java.util.List;
import java.util.Optional;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PaymentMethodRepository
extends MongoRepository<PaymentMethod, String> {
    public List<PaymentMethod> findByUserIdOrderByIsDefaultDescCreatedAtDesc(String var1);

    public Optional<PaymentMethod> findByUserIdAndIsDefaultTrue(String var1);

    public void deleteByUserIdAndId(String var1, String var2);
}

