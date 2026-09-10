/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.Cart
 *  com.vpnexues.model.Cart$CartItem
 *  org.springframework.data.annotation.Id
 *  org.springframework.data.mongodb.core.mapping.Document
 */
package com.vpnexues.model;

import com.vpnexues.model.Cart;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection="carts")
public class Cart {
    @Id
    private String id;
    private String userId;
    private List<CartItem> items = new ArrayList();
    private Instant updatedAt = Instant.now();

    public String getId() {
        return this.id;
    }

    public String getUserId() {
        return this.userId;
    }

    public List<CartItem> getItems() {
        return this.items;
    }

    public Instant getUpdatedAt() {
        return this.updatedAt;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setItems(List<CartItem> items) {
        this.items = items;
    }

    public void setUpdatedAt(Instant updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof Cart)) {
            return false;
        }
        Cart other = (Cart)o;
        if (!other.canEqual((Object)this)) {
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
        List this$items = this.getItems();
        List other$items = other.getItems();
        if (this$items == null ? other$items != null : !((Object)this$items).equals(other$items)) {
            return false;
        }
        Instant this$updatedAt = this.getUpdatedAt();
        Instant other$updatedAt = other.getUpdatedAt();
        return !(this$updatedAt == null ? other$updatedAt != null : !((Object)this$updatedAt).equals(other$updatedAt));
    }

    protected boolean canEqual(Object other) {
        return other instanceof Cart;
    }

    public int hashCode() {
        int PRIME = 59;
        int result = 1;
        String $id = this.getId();
        result = result * 59 + ($id == null ? 43 : $id.hashCode());
        String $userId = this.getUserId();
        result = result * 59 + ($userId == null ? 43 : $userId.hashCode());
        List $items = this.getItems();
        result = result * 59 + ($items == null ? 43 : ((Object)$items).hashCode());
        Instant $updatedAt = this.getUpdatedAt();
        result = result * 59 + ($updatedAt == null ? 43 : ((Object)$updatedAt).hashCode());
        return result;
    }

    public String toString() {
        return "Cart(id=" + this.getId() + ", userId=" + this.getUserId() + ", items=" + String.valueOf(this.getItems()) + ", updatedAt=" + String.valueOf(this.getUpdatedAt()) + ")";
    }

    public Cart() {
    }

    public Cart(String id, String userId, List<CartItem> items, Instant updatedAt) {
        this.id = id;
        this.userId = userId;
        this.items = items;
        this.updatedAt = updatedAt;
    }
}

