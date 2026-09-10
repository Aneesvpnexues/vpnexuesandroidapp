/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.Order
 *  com.vpnexues.repository.OrderRepository
 *  org.springframework.data.mongodb.repository.MongoRepository
 */
package com.vpnexues.repository;

import com.vpnexues.model.Order;
import java.util.List;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface OrderRepository
extends MongoRepository<Order, String> {
    public List<Order> findByUserIdOrderByCreatedAtDesc(String var1);
}

