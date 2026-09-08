package com.vpnexues.dto;

import java.util.List;

public class OrderRequest {
    private Long userId;
    private double subtotal;
    private double deliveryFee;
    private double deliveryDiscount;
    private double totalAmount;
    private String paymentMethod;
    private List<OrderItemRequest> items;

    public OrderRequest() {}

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }
    public double getDeliveryFee() { return deliveryFee; }
    public void setDeliveryFee(double deliveryFee) { this.deliveryFee = deliveryFee; }
    public double getDeliveryDiscount() { return deliveryDiscount; }
    public void setDeliveryDiscount(double deliveryDiscount) { this.deliveryDiscount = deliveryDiscount; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    public List<OrderItemRequest> getItems() { return items; }
    public void setItems(List<OrderItemRequest> items) { this.items = items; }

    public static class OrderItemRequest {
        private String productId;
        private int quantity;
        private double price;

        public OrderItemRequest() {}

        public String getProductId() { return productId; }
        public void setProductId(String productId) { this.productId = productId; }
        public int getQuantity() { return quantity; }
        public void setQuantity(int quantity) { this.quantity = quantity; }
        public double getPrice() { return price; }
        public void setPrice(double price) { this.price = price; }
    }
}
