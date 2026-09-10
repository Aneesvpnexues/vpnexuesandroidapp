/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.Address
 *  com.vpnexues.repository.AddressRepository
 *  org.springframework.data.mongodb.repository.MongoRepository
 */
package com.vpnexues.repository;

import com.vpnexues.model.Address;
import java.util.List;
import java.util.Optional;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface AddressRepository
extends MongoRepository<Address, String> {
    public List<Address> findByUserIdOrderByIsDefaultDescCreatedAtDesc(String var1);

    public Optional<Address> findByUserIdAndIsDefaultTrue(String var1);

    public void deleteByUserIdAndId(String var1, String var2);
}

