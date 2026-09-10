/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.Product
 *  org.springframework.data.annotation.CreatedDate
 *  org.springframework.data.annotation.Id
 *  org.springframework.data.annotation.LastModifiedDate
 *  org.springframework.data.mongodb.core.index.CompoundIndex
 *  org.springframework.data.mongodb.core.index.Indexed
 *  org.springframework.data.mongodb.core.mapping.Document
 */
package com.vpnexues.model;

import java.time.Instant;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection="products")
@CompoundIndex(name="category_created", def="{'category': 1, 'createdAt': -1}")
public class Product {
    @Id
    private String id;
    private String name;
    private String subtitle = "";
    @Indexed
    private String category;
    private String imageUrl = "";
    private double currentPrice;
    private double originalPrice;
    private String discount = "";
    private String weight = "";
    private boolean isOrganic = false;
    private boolean isSale = false;
    @CreatedDate
    private Instant createdAt;
    @LastModifiedDate
    private Instant updatedAt;

    public String getId() {
        return this.id;
    }

    public String getName() {
        return this.name;
    }

    public String getSubtitle() {
        return this.subtitle;
    }

    public String getCategory() {
        return this.category;
    }

    public String getImageUrl() {
        return this.imageUrl;
    }

    public double getCurrentPrice() {
        return this.currentPrice;
    }

    public double getOriginalPrice() {
        return this.originalPrice;
    }

    public String getDiscount() {
        return this.discount;
    }

    public String getWeight() {
        return this.weight;
    }

    public boolean isOrganic() {
        return this.isOrganic;
    }

    public boolean isSale() {
        return this.isSale;
    }

    public Instant getCreatedAt() {
        return this.createdAt;
    }

    public Instant getUpdatedAt() {
        return this.updatedAt;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public void setCurrentPrice(double currentPrice) {
        this.currentPrice = currentPrice;
    }

    public void setOriginalPrice(double originalPrice) {
        this.originalPrice = originalPrice;
    }

    public void setDiscount(String discount) {
        this.discount = discount;
    }

    public void setWeight(String weight) {
        this.weight = weight;
    }

    public void setOrganic(boolean isOrganic) {
        this.isOrganic = isOrganic;
    }

    public void setSale(boolean isSale) {
        this.isSale = isSale;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }

    public void setUpdatedAt(Instant updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof Product)) {
            return false;
        }
        Product other = (Product)o;
        if (!other.canEqual((Object)this)) {
            return false;
        }
        if (Double.compare(this.getCurrentPrice(), other.getCurrentPrice()) != 0) {
            return false;
        }
        if (Double.compare(this.getOriginalPrice(), other.getOriginalPrice()) != 0) {
            return false;
        }
        if (this.isOrganic() != other.isOrganic()) {
            return false;
        }
        if (this.isSale() != other.isSale()) {
            return false;
        }
        String this$id = this.getId();
        String other$id = other.getId();
        if (this$id == null ? other$id != null : !this$id.equals(other$id)) {
            return false;
        }
        String this$name = this.getName();
        String other$name = other.getName();
        if (this$name == null ? other$name != null : !this$name.equals(other$name)) {
            return false;
        }
        String this$subtitle = this.getSubtitle();
        String other$subtitle = other.getSubtitle();
        if (this$subtitle == null ? other$subtitle != null : !this$subtitle.equals(other$subtitle)) {
            return false;
        }
        String this$category = this.getCategory();
        String other$category = other.getCategory();
        if (this$category == null ? other$category != null : !this$category.equals(other$category)) {
            return false;
        }
        String this$imageUrl = this.getImageUrl();
        String other$imageUrl = other.getImageUrl();
        if (this$imageUrl == null ? other$imageUrl != null : !this$imageUrl.equals(other$imageUrl)) {
            return false;
        }
        String this$discount = this.getDiscount();
        String other$discount = other.getDiscount();
        if (this$discount == null ? other$discount != null : !this$discount.equals(other$discount)) {
            return false;
        }
        String this$weight = this.getWeight();
        String other$weight = other.getWeight();
        if (this$weight == null ? other$weight != null : !this$weight.equals(other$weight)) {
            return false;
        }
        Instant this$createdAt = this.getCreatedAt();
        Instant other$createdAt = other.getCreatedAt();
        if (this$createdAt == null ? other$createdAt != null : !((Object)this$createdAt).equals(other$createdAt)) {
            return false;
        }
        Instant this$updatedAt = this.getUpdatedAt();
        Instant other$updatedAt = other.getUpdatedAt();
        return !(this$updatedAt == null ? other$updatedAt != null : !((Object)this$updatedAt).equals(other$updatedAt));
    }

    protected boolean canEqual(Object other) {
        return other instanceof Product;
    }

    public int hashCode() {
        int PRIME = 59;
        int result = 1;
        long $currentPrice = Double.doubleToLongBits(this.getCurrentPrice());
        result = result * 59 + (int)($currentPrice >>> 32 ^ $currentPrice);
        long $originalPrice = Double.doubleToLongBits(this.getOriginalPrice());
        result = result * 59 + (int)($originalPrice >>> 32 ^ $originalPrice);
        result = result * 59 + (this.isOrganic() ? 79 : 97);
        result = result * 59 + (this.isSale() ? 79 : 97);
        String $id = this.getId();
        result = result * 59 + ($id == null ? 43 : $id.hashCode());
        String $name = this.getName();
        result = result * 59 + ($name == null ? 43 : $name.hashCode());
        String $subtitle = this.getSubtitle();
        result = result * 59 + ($subtitle == null ? 43 : $subtitle.hashCode());
        String $category = this.getCategory();
        result = result * 59 + ($category == null ? 43 : $category.hashCode());
        String $imageUrl = this.getImageUrl();
        result = result * 59 + ($imageUrl == null ? 43 : $imageUrl.hashCode());
        String $discount = this.getDiscount();
        result = result * 59 + ($discount == null ? 43 : $discount.hashCode());
        String $weight = this.getWeight();
        result = result * 59 + ($weight == null ? 43 : $weight.hashCode());
        Instant $createdAt = this.getCreatedAt();
        result = result * 59 + ($createdAt == null ? 43 : ((Object)$createdAt).hashCode());
        Instant $updatedAt = this.getUpdatedAt();
        result = result * 59 + ($updatedAt == null ? 43 : ((Object)$updatedAt).hashCode());
        return result;
    }

    public String toString() {
        return "Product(id=" + this.getId() + ", name=" + this.getName() + ", subtitle=" + this.getSubtitle() + ", category=" + this.getCategory() + ", imageUrl=" + this.getImageUrl() + ", currentPrice=" + this.getCurrentPrice() + ", originalPrice=" + this.getOriginalPrice() + ", discount=" + this.getDiscount() + ", weight=" + this.getWeight() + ", isOrganic=" + this.isOrganic() + ", isSale=" + this.isSale() + ", createdAt=" + String.valueOf(this.getCreatedAt()) + ", updatedAt=" + String.valueOf(this.getUpdatedAt()) + ")";
    }

    public Product() {
    }

    public Product(String id, String name, String subtitle, String category, String imageUrl, double currentPrice, double originalPrice, String discount, String weight, boolean isOrganic, boolean isSale, Instant createdAt, Instant updatedAt) {
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
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
}

