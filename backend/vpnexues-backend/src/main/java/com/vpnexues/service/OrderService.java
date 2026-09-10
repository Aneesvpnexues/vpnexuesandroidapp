package com.vpnexues.service;

import com.vpnexues.dto.PlaceOrderRequest;
import com.vpnexues.model.Order;
import com.vpnexues.model.Order.OrderItem;
import com.vpnexues.repository.OrderRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Service
public class OrderService {

    private final OrderRepository orderRepository;

    public OrderService(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }

    @Transactional
    public Order placeOrder(String userId, PlaceOrderRequest request) {
        Order order = new Order();
        order.setId(UUID.randomUUID().toString());
        order.setUserId(userId);
        order.setSubtotal(request.getSubtotal());
        order.setDeliveryFee(request.getDeliveryFee());
        order.setDeliveryDiscount(request.getDeliveryDiscount());
        order.setTotalAmount(request.getTotalAmount());
        order.setPaymentMethod(request.getPaymentMethod());
        order.setPaymentId(request.getPaymentId());
        if (request.getPaymentStatus() != null) {
            order.setPaymentStatus(request.getPaymentStatus());
        }
        order.setEstimatedDelivery(Instant.now().plusSeconds(3600));

        if (request.getItems() != null) {
            for (PlaceOrderRequest.OrderItemDto itemDto : request.getItems()) {
                OrderItem item = new OrderItem(
                        itemDto.getProductId(),
                        itemDto.getName(),
                        itemDto.getImageUrl(),
                        itemDto.getCurrentPrice(),
                        itemDto.getQuantity()
                );
                item.setId(UUID.randomUUID().toString());
                item.setOrder(order);
                order.getItems().add(item);
            }
        }

        return orderRepository.save(order);
    }

    public Order getOrderById(String userId, String orderId) {
        return orderRepository.findById(orderId)
                .filter(o -> o.getUserId().equals(userId))
                .orElseThrow(() -> new RuntimeException("Order not found"));
    }

    public List<Order> getOrders(String userId) {
        return orderRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    @Transactional
    public Order updateOrderStatus(String userId, String orderId, String status) {
        Order order = getOrderById(userId, orderId);
        order.setStatus(status);
        return orderRepository.save(order);
    }

    @Transactional
    public Order cancelOrder(String userId, String orderId) {
        Order order = getOrderById(userId, orderId);
        order.setStatus("cancelled");
        return orderRepository.save(order);
    }
}
