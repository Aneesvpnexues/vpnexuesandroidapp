/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.Cart
 *  com.vpnexues.repository.CartRepository
 *  org.springframework.data.mongodb.repository.MongoRepository
 */
package com.vpnexues.repository;

import com.vpnexues.model.Cart;
import java.util.Optional;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface CartRepository
extends MongoRepository<Cart, String> {
    public Optional<Cart> findByUserId(String var1);

    public void deleteByUserId(String var1);
}

