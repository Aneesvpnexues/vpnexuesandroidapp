package com.vpnexues.model;

import jakarta.persistence.*;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "carts")
public class Cart {

    @Id
    private String id;

    @Column(name = "user_id")
    private String userId;

    @OneToMany(mappedBy = "cart", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CartItem> items = new ArrayList<>();

    @Column(name = "updated_at")
    private Instant updatedAt = Instant.now();

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = items;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Instant updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Entity
    @Table(name = "cart_items")
    public static class CartItem {

        @Id
        private String id;

        @ManyToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "cart_id")
        private Cart cart;

        @Column(name = "product_id")
        private String productId;

        private String name;

        @Column(name = "image_url")
        private String imageUrl;

        @Column(name = "current_price")
        private double currentPrice;

        private String weight;

        private int quantity;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public Cart getCart() {
            return cart;
        }

        public void setCart(Cart cart) {
            this.cart = cart;
        }

        public String getProductId() {
            return productId;
        }

        public void setProductId(String productId) {
            this.productId = productId;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getImageUrl() {
            return imageUrl;
        }

        public void setImageUrl(String imageUrl) {
            this.imageUrl = imageUrl;
        }

        public double getCurrentPrice() {
            return currentPrice;
        }

        public void setCurrentPrice(double currentPrice) {
            this.currentPrice = currentPrice;
        }

        public String getWeight() {
            return weight;
        }

        public void setWeight(String weight) {
            this.weight = weight;
        }

        public int getQuantity() {
            return quantity;
        }

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }
    }
}
