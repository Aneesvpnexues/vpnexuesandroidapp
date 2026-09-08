package com.vpnexues.service;

import com.vpnexues.dto.OrderRequest;
import com.vpnexues.model.Order;
import com.vpnexues.model.OrderItem;
import com.vpnexues.repository.CartItemRepository;
import com.vpnexues.repository.OrderRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class OrderService {

    private final OrderRepository orderRepository;
    private final CartItemRepository cartItemRepository;

    public OrderService(OrderRepository orderRepository, CartItemRepository cartItemRepository) {
        this.orderRepository = orderRepository;
        this.cartItemRepository = cartItemRepository;
    }

    @Transactional
    public Order placeOrder(OrderRequest request) {
        Order order = new Order();
        order.setUserId(request.getUserId());
        order.setSubtotal(request.getSubtotal());
        order.setDeliveryFee(request.getDeliveryFee());
        order.setDeliveryDiscount(request.getDeliveryDiscount());
        order.setTotalAmount(request.getTotalAmount());
        order.setPaymentMethod(request.getPaymentMethod());
        order.setStatus("confirmed");

        List<OrderItem> items = new ArrayList<>();
        for (OrderRequest.OrderItemRequest itemReq : request.getItems()) {
            OrderItem item = new OrderItem(order, itemReq.getProductId(), itemReq.getQuantity(), itemReq.getPrice());
            items.add(item);
        }
        order.setItems(items);

        Order savedOrder = orderRepository.save(order);

        cartItemRepository.deleteByUserId(request.getUserId());

        return savedOrder;
    }

    public List<Order> getUserOrders(Long userId) {
        return orderRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }
}
