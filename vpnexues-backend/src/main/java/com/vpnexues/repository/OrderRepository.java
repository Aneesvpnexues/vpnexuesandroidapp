package com.vpnexues.repository;

import com.vpnexues.model.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface OrderRepository extends JpaRepository<Order, String> {
    List<Order> findByUserIdOrderByCreatedAtDesc(String userId);
}
