/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.dto.PlaceOrderRequest
 *  com.vpnexues.model.Order
 *  com.vpnexues.model.Order$OrderItem
 *  com.vpnexues.repository.CartRepository
 *  com.vpnexues.repository.OrderRepository
 *  com.vpnexues.service.OrderService
 *  org.springframework.stereotype.Service
 */
package com.vpnexues.service;

import com.vpnexues.dto.PlaceOrderRequest;
import com.vpnexues.model.Order;
import com.vpnexues.repository.CartRepository;
import com.vpnexues.repository.OrderRepository;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;

@Service
public class OrderService {
    private final OrderRepository orderRepository;
    private final CartRepository cartRepository;

    public Order placeOrder(String userId, PlaceOrderRequest request) {
        List orderItems = request.getItems().stream().map(dto -> new Order.OrderItem(dto.getProductId(), dto.getName(), dto.getImageUrl(), dto.getCurrentPrice(), dto.getQuantity())).collect(Collectors.toList());
        Order order = new Order();
        order.setUserId(userId);
        order.setSubtotal(request.getSubtotal());
        order.setDeliveryFee(request.getDeliveryFee());
        order.setDeliveryDiscount(request.getDeliveryDiscount());
        order.setTotalAmount(request.getTotalAmount());
        order.setPaymentMethod(request.getPaymentMethod());
        order.setPaymentId(request.getPaymentId());
        order.setPaymentStatus(request.getPaymentStatus() != null ? request.getPaymentStatus() : "pending");
        order.setItems(orderItems);
        order.setStatus("placed");
        order.setCreatedAt(Instant.now());
        order.setEstimatedDelivery(Instant.now().plus(18L, ChronoUnit.MINUTES));
        Order savedOrder = (Order)this.orderRepository.save((Object)order);
        this.cartRepository.deleteByUserId(userId);
        return savedOrder;
    }

    public Order getOrderById(String userId, String orderId) {
        Order order = (Order)this.orderRepository.findById((Object)orderId).orElseThrow(() -> new RuntimeException("Order not found"));
        if (!order.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized: order does not belong to this user");
        }
        return order;
    }

    public List<Order> getOrders(String userId) {
        return this.orderRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public Order updateOrderStatus(String userId, String orderId, String status) {
        Order order = (Order)this.orderRepository.findById((Object)orderId).orElseThrow(() -> new RuntimeException("Order not found"));
        if (!order.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized: order does not belong to this user");
        }
        order.setStatus(status);
        return (Order)this.orderRepository.save((Object)order);
    }

    public Order cancelOrder(String userId, String orderId) {
        Order order = (Order)this.orderRepository.findById((Object)orderId).orElseThrow(() -> new RuntimeException("Order not found"));
        if (!order.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized: order does not belong to this user");
        }
        String status = order.getStatus();
        if (!"placed".equals(status) && !"preparing".equals(status)) {
            throw new RuntimeException("Order cannot be cancelled in '" + status + "' status");
        }
        order.setStatus("cancelled");
        return (Order)this.orderRepository.save((Object)order);
    }

    public OrderService(OrderRepository orderRepository, CartRepository cartRepository) {
        this.orderRepository = orderRepository;
        this.cartRepository = cartRepository;
    }
}

