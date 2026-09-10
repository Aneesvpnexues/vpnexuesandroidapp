/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.controller.ProductController
 *  com.vpnexues.model.Product
 *  com.vpnexues.service.ProductService
 *  org.springframework.data.domain.Page
 *  org.springframework.http.ResponseEntity
 *  org.springframework.web.bind.annotation.GetMapping
 *  org.springframework.web.bind.annotation.PathVariable
 *  org.springframework.web.bind.annotation.RequestMapping
 *  org.springframework.web.bind.annotation.RequestParam
 *  org.springframework.web.bind.annotation.RestController
 */
package com.vpnexues.controller;

import com.vpnexues.model.Product;
import com.vpnexues.service.ProductService;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value={"/api/products"})
public class ProductController {
    private final ProductService productService;

    @GetMapping
    public ResponseEntity<Map<String, Object>> getAllProducts(@RequestParam(defaultValue="0") int page, @RequestParam(defaultValue="100") int size) {
        Page products = this.productService.getAllProducts(page, size);
        HashMap<String, Object> response = new HashMap<String, Object>();
        response.put("content", products.getContent());
        response.put("totalPages", products.getTotalPages());
        response.put("totalElements", products.getTotalElements());
        response.put("currentPage", products.getNumber());
        return ResponseEntity.ok(response);
    }

    @GetMapping(value={"/list"})
    public ResponseEntity<List<Product>> getAllProductsList() {
        return ResponseEntity.ok((Object)this.productService.getAllProductsList());
    }

    @GetMapping(value={"/popular"})
    public ResponseEntity<List<Product>> getPopularProducts() {
        return ResponseEntity.ok((Object)this.productService.getPopularProducts());
    }

    @GetMapping(value={"/search"})
    public ResponseEntity<List<Product>> searchProducts(@RequestParam(name="q") String query) {
        return ResponseEntity.ok((Object)this.productService.searchProducts(query));
    }

    @GetMapping(value={"/category/{category}"})
    public ResponseEntity<Map<String, Object>> getProductsByCategory(@PathVariable String category, @RequestParam(defaultValue="0") int page, @RequestParam(defaultValue="100") int size) {
        Page products = this.productService.getProductsByCategory(category, page, size);
        HashMap<String, Object> response = new HashMap<String, Object>();
        response.put("content", products.getContent());
        response.put("totalPages", products.getTotalPages());
        response.put("totalElements", products.getTotalElements());
        return ResponseEntity.ok(response);
    }

    @GetMapping(value={"/category/{category}/list"})
    public ResponseEntity<List<Product>> getProductsByCategoryList(@PathVariable String category) {
        return ResponseEntity.ok((Object)this.productService.getProductsByCategoryList(category));
    }

    @GetMapping(value={"/{id}"})
    public ResponseEntity<Product> getProductById(@PathVariable String id) {
        return ResponseEntity.ok((Object)this.productService.getProductById(id));
    }

    public ProductController(ProductService productService) {
        this.productService = productService;
    }
}

