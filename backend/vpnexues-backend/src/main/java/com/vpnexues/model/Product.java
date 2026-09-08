package com.vpnexues.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "products")
public class Product {

    @Id
    private String id;

    private String name;
    private String subtitle;
    private String category;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "current_price")
    private double currentPrice;

    @Column(name = "original_price")
    private double originalPrice;

    private String discount;
    private String weight;

    @Column(name = "is_organic")
    private boolean isOrganic;

    @Column(name = "is_sale")
    private boolean isSale;

    @Column(name = "is_active")
    private boolean isActive = true;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    public Product() {}

    public Product(String id, String name, String subtitle, String category, String imageUrl,
                   double currentPrice, double originalPrice, String discount, String weight,
                   boolean isOrganic, boolean isSale) {
        this.id = id;
        this.name = name;
        this.subtitle = subtitle;
        this.category = category;
        this.imageUrl = imageUrl;
        this.currentPrice = currentPrice;
        this.originalPrice = originalPrice;
        this.discount = discount;
        this.weight = weight;
        this.isOrganic = isOrganic;
        this.isSale = isSale;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSubtitle() { return subtitle; }
    public void setSubtitle(String subtitle) { this.subtitle = subtitle; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public double getCurrentPrice() { return currentPrice; }
    public void setCurrentPrice(double currentPrice) { this.currentPrice = currentPrice; }
    public double getOriginalPrice() { return originalPrice; }
    public void setOriginalPrice(double originalPrice) { this.originalPrice = originalPrice; }
    public String getDiscount() { return discount; }
    public void setDiscount(String discount) { this.discount = discount; }
    public String getWeight() { return weight; }
    public void setWeight(String weight) { this.weight = weight; }
    public boolean isOrganic() { return isOrganic; }
    public void setOrganic(boolean organic) { isOrganic = organic; }
    public boolean isSale() { return isSale; }
    public void setSale(boolean sale) { isSale = sale; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
