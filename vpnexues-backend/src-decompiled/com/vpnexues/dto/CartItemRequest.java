/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.dto.CartItemRequest
 *  jakarta.validation.constraints.Min
 *  jakarta.validation.constraints.NotBlank
 *  jakarta.validation.constraints.NotNull
 */
package com.vpnexues.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class CartItemRequest {
    @NotBlank(message="Product ID is required")
    private @NotBlank(message="Product ID is required") String productId;
    @NotNull(message="Quantity is required")
    @Min(value=1L, message="Quantity must be at least 1")
    private @NotNull(message="Quantity is required") @Min(value=1L, message="Quantity must be at least 1") int quantity;

    public String getProductId() {
        return this.productId;
    }

    public int getQuantity() {
        return this.quantity;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof CartItemRequest)) {
            return false;
        }
        CartItemRequest other = (CartItemRequest)o;
        if (!other.canEqual((Object)this)) {
            return false;
        }
        if (this.getQuantity() != other.getQuantity()) {
            return false;
        }
        String this$productId = this.getProductId();
        String other$productId = other.getProductId();
        return !(this$productId == null ? other$productId != null : !this$productId.equals(other$productId));
    }

    protected boolean canEqual(Object other) {
        return other instanceof CartItemRequest;
    }

    public int hashCode() {
        int PRIME = 59;
        int result = 1;
        result = result * 59 + this.getQuantity();
        String $productId = this.getProductId();
        result = result * 59 + ($productId == null ? 43 : $productId.hashCode());
        return result;
    }

    public String toString() {
        return "CartItemRequest(productId=" + this.getProductId() + ", quantity=" + this.getQuantity() + ")";
    }
}

