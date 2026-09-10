/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.dto.PlaceOrderRequest
 *  com.vpnexues.dto.PlaceOrderRequest$OrderItemDto
 *  jakarta.validation.constraints.Min
 *  jakarta.validation.constraints.NotNull
 */
package com.vpnexues.dto;

import com.vpnexues.dto.PlaceOrderRequest;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.util.List;

public class PlaceOrderRequest {
    @NotNull(message="Subtotal is required")
    @Min(value=0L, message="Subtotal must be positive")
    private @NotNull(message="Subtotal is required") @Min(value=0L, message="Subtotal must be positive") double subtotal;
    private double deliveryFee;
    private double deliveryDiscount;
    @NotNull(message="Total amount is required")
    @Min(value=0L, message="Total must be positive")
    private @NotNull(message="Total amount is required") @Min(value=0L, message="Total must be positive") double totalAmount;
    private String paymentMethod = "cash_on_delivery";
    private String paymentId;
    private String paymentStatus;
    @NotNull(message="Items are required")
    private @NotNull(message="Items are required") List<// Could not load outer class - annotation placement on inner may be incorrect
    OrderItemDto> items;

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

    public List<OrderItemDto> getItems() {
        return this.items;
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

    public void setItems(List<OrderItemDto> items) {
        this.items = items;
    }

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof PlaceOrderRequest)) {
            return false;
        }
        PlaceOrderRequest other = (PlaceOrderRequest)o;
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
        return !(this$items == null ? other$items != null : !((Object)this$items).equals(other$items));
    }

    protected boolean canEqual(Object other) {
        return other instanceof PlaceOrderRequest;
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
        String $paymentMethod = this.getPaymentMethod();
        result = result * 59 + ($paymentMethod == null ? 43 : $paymentMethod.hashCode());
        String $paymentId = this.getPaymentId();
        result = result * 59 + ($paymentId == null ? 43 : $paymentId.hashCode());
        String $paymentStatus = this.getPaymentStatus();
        result = result * 59 + ($paymentStatus == null ? 43 : $paymentStatus.hashCode());
        List $items = this.getItems();
        result = result * 59 + ($items == null ? 43 : ((Object)$items).hashCode());
        return result;
    }

    public String toString() {
        return "PlaceOrderRequest(subtotal=" + this.getSubtotal() + ", deliveryFee=" + this.getDeliveryFee() + ", deliveryDiscount=" + this.getDeliveryDiscount() + ", totalAmount=" + this.getTotalAmount() + ", paymentMethod=" + this.getPaymentMethod() + ", paymentId=" + this.getPaymentId() + ", paymentStatus=" + this.getPaymentStatus() + ", items=" + String.valueOf(this.getItems()) + ")";
    }
}

