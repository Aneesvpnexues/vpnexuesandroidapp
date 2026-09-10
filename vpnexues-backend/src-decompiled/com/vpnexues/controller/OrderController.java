/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.controller.OrderController
 *  com.vpnexues.dto.PlaceOrderRequest
 *  com.vpnexues.model.Order
 *  com.vpnexues.service.OrderService
 *  jakarta.validation.Valid
 *  org.springframework.http.ResponseEntity
 *  org.springframework.security.core.Authentication
 *  org.springframework.security.core.context.SecurityContextHolder
 *  org.springframework.web.bind.annotation.GetMapping
 *  org.springframework.web.bind.annotation.PathVariable
 *  org.springframework.web.bind.annotation.PostMapping
 *  org.springframework.web.bind.annotation.PutMapping
 *  org.springframework.web.bind.annotation.RequestBody
 *  org.springframework.web.bind.annotation.RequestMapping
 *  org.springframework.web.bind.annotation.RestController
 */
package com.vpnexues.controller;

import com.vpnexues.dto.PlaceOrderRequest;
import com.vpnexues.model.Order;
import com.vpnexues.service.OrderService;
import jakarta.validation.Valid;
import java.util.List;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value={"/api/orders"})
public class OrderController {
    private final OrderService orderService;

    private String getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getName();
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> placeOrder(@Valid @RequestBody PlaceOrderRequest request) {
        String userId = this.getCurrentUserId();
        Order order = this.orderService.placeOrder(userId, request);
        return ResponseEntity.ok(Map.of("orderId", order.getId(), "userId", order.getUserId(), "totalAmount", order.getTotalAmount(), "status", order.getStatus(), "paymentMethod", order.getPaymentMethod() != null ? order.getPaymentMethod() : "cash_on_delivery", "paymentId", order.getPaymentId() != null ? order.getPaymentId() : "", "paymentStatus", order.getPaymentStatus() != null ? order.getPaymentStatus() : "pending", "createdAt", order.getCreatedAt().toString()));
    }

    @GetMapping
    public ResponseEntity<List<Order>> getOrders() {
        String userId = this.getCurrentUserId();
        return ResponseEntity.ok((Object)this.orderService.getOrders(userId));
    }

    @GetMapping(value={"/{orderId}"})
    public ResponseEntity<Order> getOrderById(@PathVariable String orderId) {
        String userId = this.getCurrentUserId();
        return ResponseEntity.ok((Object)this.orderService.getOrderById(userId, orderId));
    }

    @PutMapping(value={"/{orderId}/status"})
    public ResponseEntity<Map<String, Object>> updateOrderStatus(@PathVariable String orderId, @RequestBody Map<String, String> body) {
        String userId = this.getCurrentUserId();
        String status = body.get("status");
        Order order = this.orderService.updateOrderStatus(userId, orderId, status);
        return ResponseEntity.ok(Map.of("orderId", order.getId(), "status", order.getStatus(), "estimatedDelivery", order.getEstimatedDelivery() != null ? order.getEstimatedDelivery().toString() : ""));
    }

    @PutMapping(value={"/{orderId}/cancel"})
    public ResponseEntity<Map<String, Object>> cancelOrder(@PathVariable String orderId) {
        String userId = this.getCurrentUserId();
        Order order = this.orderService.cancelOrder(userId, orderId);
        return ResponseEntity.ok(Map.of("orderId", order.getId(), "userId", order.getUserId(), "totalAmount", order.getTotalAmount(), "status", order.getStatus(), "createdAt", order.getCreatedAt().toString()));
    }

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }
}

