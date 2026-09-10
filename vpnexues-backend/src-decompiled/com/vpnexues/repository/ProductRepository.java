/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.Product
 *  com.vpnexues.repository.ProductRepository
 *  org.springframework.data.domain.Page
 *  org.springframework.data.domain.Pageable
 *  org.springframework.data.mongodb.repository.MongoRepository
 *  org.springframework.data.mongodb.repository.Query
 */
package com.vpnexues.repository;

import com.vpnexues.model.Product;
import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface ProductRepository
extends MongoRepository<Product, String> {
    public List<Product> findByIsSaleTrue();

    public Page<Product> findByCategory(String var1, Pageable var2);

    public List<Product> findByCategory(String var1);

    @Query(value="{ $or: [   { name: { $regex: ?0, $options: 'i' } },   { subtitle: { $regex: ?0, $options: 'i' } },   { category: { $regex: ?0, $options: 'i' } } ] }")
    public List<Product> searchProducts(String var1);
}

