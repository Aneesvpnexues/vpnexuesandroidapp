/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.Order
 *  com.vpnexues.model.Order$OrderItem
 *  org.springframework.data.annotation.CreatedDate
 *  org.springframework.data.annotation.Id
 *  org.springframework.data.mongodb.core.index.Indexed
 *  org.springframework.data.mongodb.core.mapping.Document
 */
package com.vpnexues.model;

import com.vpnexues.model.Order;
import java.time.Instant;
import java.util.List;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection="orders")
public class Order {
    @Id
    private String id;
    @Indexed
    private String userId;
    private double subtotal;
    private double deliveryFee;
    private double deliveryDiscount;
    private double totalAmount;
    private String paymentMethod = "cash_on_delivery";
    private String paymentId;
    private String paymentStatus = "pending";
    private List<OrderItem> items;
    private String status = "placed";
    private Instant estimatedDelivery;
    @CreatedDate
    private Instant createdAt;

    public String getId() {
        return this.id;
    }

    public String getUserId() {
        return this.userId;
    }

    public double getSubtotal() {
        return this.subtotal;
    }

    public double getDeliveryFee() {
        return this.deliveryFee;
    }

    public double getDeliveryDiscount() {
        return this.deliveryDiscount;
    }

    public double getTotalAmount() {
        return this.totalAmount;
    }

    public String getPaymentMethod() {
        return this.paymentMethod;
    }

    public String getPaymentId() {
        return this.paymentId;
    }

    public String getPaymentStatus() {
        return this.paymentStatus;
    }

    public List<OrderItem> getItems() {
        return this.items;
    }

    public String getStatus() {
        return this.status;
    }

    public Instant getEstimatedDelivery() {
        return this.estimatedDelivery;
    }

    public Instant getCreatedAt() {
        return this.createdAt;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

    public void setDeliveryFee(double deliveryFee) {
        this.deliveryFee = deliveryFee;
    }

    public void setDeliveryDiscount(double deliveryDiscount) {
        this.deliveryDiscount = deliveryDiscount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public void setPaymentId(String paymentId) {
        this.paymentId = paymentId;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setEstimatedDelivery(Instant estimatedDelivery) {
        this.estimatedDelivery = estimatedDelivery;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof Order)) {
            return false;
        }
        Order other = (Order)o;
        if (!other.canEqual((Object)this)) {
            return false;
        }
        if (Double.compare(this.getSubtotal(), other.getSubtotal()) != 0) {
            return false;
        }
        if (Double.compare(this.getDeliveryFee(), other.getDeliveryFee()) != 0) {
            return false;
        }
        if (Double.compare(this.getDeliveryDiscount(), other.getDeliveryDiscount()) != 0) {
            return false;
        }
        if (Double.compare(this.getTotalAmount(), other.getTotalAmount()) != 0) {
            return false;
        }
        String this$id = this.getId();
        String other$id = other.getId();
        if (this$id == null ? other$id != null : !this$id.equals(other$id)) {
            return false;
        }
        String this$userId = this.getUserId();
        String other$userId = other.getUserId();
        if (this$userId == null ? other$userId != null : !this$userId.equals(other$userId)) {
            return false;
        }
        String this$paymentMethod = this.getPaymentMethod();
        String other$paymentMethod = other.getPaymentMethod();
        if (this$paymentMethod == null ? other$paymentMethod != null : !this$paymentMethod.equals(other$paymentMethod)) {
            return false;
        }
        String this$paymentId = this.getPaymentId();
        String other$paymentId = other.getPaymentId();
        if (this$paymentId == null ? other$paymentId != null : !this$paymentId.equals(other$paymentId)) {
            return false;
        }
        String this$paymentStatus = this.getPaymentStatus();
        String other$paymentStatus = other.getPaymentStatus();
        if (this$paymentStatus == null ? other$paymentStatus != null : !this$paymentStatus.equals(other$paymentStatus)) {
            return false;
        }
        List this$items = this.getItems();
        List other$items = other.getItems();
        if (this$items == null ? other$items != null : !((Object)this$items).equals(other$items)) {
            return false;
        }
        String this$status = this.getStatus();
        String other$status = other.getStatus();
        if (this$status == null ? other$status != null : !this$status.equals(other$status)) {
            return false;
        }
        Instant this$estimatedDelivery = this.getEstimatedDelivery();
        Instant other$estimatedDelivery = other.getEstimatedDelivery();
        if (this$estimatedDelivery == null ? other$estimatedDelivery != null : !((Object)this$estimatedDelivery).equals(other$estimatedDelivery)) {
            return false;
        }
        Instant this$createdAt = this.getCreatedAt();
        Instant other$createdAt = other.getCreatedAt();
        return !(this$createdAt == null ? other$createdAt != null : !((Object)this$createdAt).equals(other$createdAt));
    }

    protected boolean canEqual(Object other) {
        return other instanceof Order;
    }

    public int hashCode() {
        int PRIME = 59;
        int result = 1;
        long $subtotal = Double.doubleToLongBits(this.getSubtotal());
        result = result * 59 + (int)($subtotal >>> 32 ^ $subtotal);
        long $deliveryFee = Double.doubleToLongBits(this.getDeliveryFee());
        result = result * 59 + (int)($deliveryFee >>> 32 ^ $deliveryFee);
        long $deliveryDiscount = Double.doubleToLongBits(this.getDeliveryDiscount());
        result = result * 59 + (int)($deliveryDiscount >>> 32 ^ $deliveryDiscount);
        long $totalAmount = Double.doubleToLongBits(this.getTotalAmount());
        result = result * 59 + (int)($totalAmount >>> 32 ^ $totalAmount);
        String $id = this.getId();
        result = result * 59 + ($id == null ? 43 : $id.hashCode());
        String $userId = this.getUserId();
        result = result * 59 + ($userId == null ? 43 : $userId.hashCode());
        String $paymentMethod = this.getPaymentMethod();
        result = result * 59 + ($paymentMethod == null ? 43 : $paymentMethod.hashCode());
        String $paymentId = this.getPaymentId();
        result = result * 59 + ($paymentId == null ? 43 : $paymentId.hashCode());
        String $paymentStatus = this.getPaymentStatus();
        result = result * 59 + ($paymentStatus == null ? 43 : $paymentStatus.hashCode());
        List $items = this.getItems();
        result = result * 59 + ($items == null ? 43 : ((Object)$items).hashCode());
        String $status = this.getStatus();
        result = result * 59 + ($status == null ? 43 : $status.hashCode());
        Instant $estimatedDelivery = this.getEstimatedDelivery();
        result = result * 59 + ($estimatedDelivery == null ? 43 : ((Object)$estimatedDelivery).hashCode());
        Instant $createdAt = this.getCreatedAt();
        result = result * 59 + ($createdAt == null ? 43 : ((Object)$createdAt).hashCode());
        return result;
    }

    public String toString() {
        return "Order(id=" + this.getId() + ", userId=" + this.getUserId() + ", subtotal=" + this.getSubtotal() + ", deliveryFee=" + this.getDeliveryFee() + ", deliveryDiscount=" + this.getDeliveryDiscount() + ", totalAmount=" + this.getTotalAmount() + ", paymentMethod=" + this.getPaymentMethod() + ", paymentId=" + this.getPaymentId() + ", paymentStatus=" + this.getPaymentStatus() + ", items=" + String.valueOf(this.getItems()) + ", status=" + this.getStatus() + ", estimatedDelivery=" + String.valueOf(this.getEstimatedDelivery()) + ", createdAt=" + String.valueOf(this.getCreatedAt()) + ")";
    }

    public Order() {
    }

    public Order(String id, String userId, double subtotal, double deliveryFee, double deliveryDiscount, double totalAmount, String paymentMethod, String paymentId, String paymentStatus, List<OrderItem> items, String status, Instant estimatedDelivery, Instant createdAt) {
        this.id = id;
        this.userId = userId;
        this.subtotal = subtotal;
        this.deliveryFee = deliveryFee;
        this.deliveryDiscount = deliveryDiscount;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.paymentId = paymentId;
        this.paymentStatus = paymentStatus;
        this.items = items;
        this.status = status;
        this.estimatedDelivery = estimatedDelivery;
        this.createdAt = createdAt;
    }
}

