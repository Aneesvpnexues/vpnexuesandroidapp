package com.vpnexues.repository;

import com.vpnexues.model.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface ProductRepository extends JpaRepository<Product, String> {
    List<Product> findByIsSaleTrue();

    Page<Product> findByCategory(String category, Pageable pageable);

    List<Product> findByCategory(String category);

    @Query("SELECT p FROM Product p WHERE LOWER(p.category) = LOWER(:category)")
    List<Product> findByCategoryIgnoreCase(@Param("category") String category);

    @Query("SELECT p FROM Product p WHERE LOWER(p.name) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(p.subtitle) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(p.category) LIKE LOWER(CONCAT('%', :query, '%'))")
    List<Product> searchProducts(@Param("query") String query);
}
