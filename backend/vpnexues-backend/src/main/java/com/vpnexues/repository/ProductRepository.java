package com.vpnexues.repository;

import com.vpnexues.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, String> {
    List<Product> findByCategoryAndIsActiveTrue(String category);
    List<Product> findByIsActiveTrue();
    List<Product> findByNameContainingIgnoreCaseAndIsActiveTrue(String query);
    List<Product> findTop6ByIsActiveTrueOrderByCreatedAtDesc();
}
