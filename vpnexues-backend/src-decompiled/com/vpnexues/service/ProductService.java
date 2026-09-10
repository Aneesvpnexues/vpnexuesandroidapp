/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.Product
 *  com.vpnexues.repository.ProductRepository
 *  com.vpnexues.service.ProductService
 *  org.springframework.data.domain.Page
 *  org.springframework.data.domain.PageRequest
 *  org.springframework.data.domain.Pageable
 *  org.springframework.data.domain.Sort
 *  org.springframework.data.domain.Sort$Direction
 *  org.springframework.stereotype.Service
 */
package com.vpnexues.service;

import com.vpnexues.model.Product;
import com.vpnexues.repository.ProductRepository;
import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

@Service
public class ProductService {
    private final ProductRepository productRepository;

    public Page<Product> getAllProducts(int page, int size) {
        PageRequest pageable = PageRequest.of((int)page, (int)size, (Sort)Sort.by((Sort.Direction)Sort.Direction.DESC, (String[])new String[]{"createdAt"}));
        return this.productRepository.findAll((Pageable)pageable);
    }

    public List<Product> getAllProductsList() {
        return this.productRepository.findAll();
    }

    public List<Product> getPopularProducts() {
        return this.productRepository.findByIsSaleTrue();
    }

    public List<Product> searchProducts(String query) {
        return this.productRepository.searchProducts(query);
    }

    public Page<Product> getProductsByCategory(String category, int page, int size) {
        PageRequest pageable = PageRequest.of((int)page, (int)size);
        return this.productRepository.findByCategory(category, (Pageable)pageable);
    }

    public List<Product> getProductsByCategoryList(String category) {
        return this.productRepository.findByCategory(category);
    }

    public Product getProductById(String id) {
        return (Product)this.productRepository.findById((Object)id).orElseThrow(() -> new RuntimeException("Product not found"));
    }

    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }
}

