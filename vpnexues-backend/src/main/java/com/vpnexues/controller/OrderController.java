package com.vpnexues.controller;

import com.vpnexues.dto.ApiResponse;
import com.vpnexues.dto.PlaceOrderRequest;
import com.vpnexues.model.Order;
import com.vpnexues.service.OrderService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @PostMapping
    public ResponseEntity<Order> placeOrder(@Valid @RequestBody PlaceOrderRequest request) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(orderService.placeOrder(userId, request));
    }

    @GetMapping
    public ResponseEntity<List<Order>> getOrders() {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(orderService.getOrders(userId));
    }

    @GetMapping("/{orderId}")
    public ResponseEntity<Order> getOrderById(@PathVariable String orderId) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(orderService.getOrderById(userId, orderId));
    }

    @PutMapping("/{orderId}/status")
    public ResponseEntity<Order> updateOrderStatus(@PathVariable String orderId, @RequestParam String status) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(orderService.updateOrderStatus(userId, orderId, status));
    }

    @PutMapping("/{orderId}/cancel")
    public ResponseEntity<Order> cancelOrder(@PathVariable String orderId) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(orderService.cancelOrder(userId, orderId));
    }
}
