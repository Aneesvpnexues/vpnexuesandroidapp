package com.vpnexues.service;

import com.vpnexues.model.Product;
import com.vpnexues.repository.ProductRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    private final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<Product> getAllProducts() {
        return productRepository.findByIsActiveTrue();
    }

    public List<Product> getProductsByCategory(String category) {
        return productRepository.findByCategoryAndIsActiveTrue(category);
    }

    public List<Product> getPopularProducts() {
        return productRepository.findTop6ByIsActiveTrueOrderByCreatedAtDesc();
    }

    public List<Product> searchProducts(String query) {
        return productRepository.findByNameContainingIgnoreCaseAndIsActiveTrue(query);
    }

    public Product getProductById(String id) {
        return productRepository.findById(id).orElse(null);
    }
}
