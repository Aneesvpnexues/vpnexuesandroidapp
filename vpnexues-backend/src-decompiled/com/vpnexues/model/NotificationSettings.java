/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.NotificationSettings
 *  org.springframework.data.annotation.Id
 *  org.springframework.data.mongodb.core.index.Indexed
 *  org.springframework.data.mongodb.core.mapping.Document
 */
package com.vpnexues.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection="notification_settings")
public class NotificationSettings {
    @Id
    private String id;
    @Indexed
    private String userId;
    private boolean orderUpdates = true;
    private boolean deliveryUpdates = true;
    private boolean couponsDeals = true;
    private boolean promotions = false;
    private boolean newArrivals = true;
    private boolean priceDropAlerts = false;
    private boolean weeklyDeals = true;
    private boolean emailNotifications = false;

    public String getId() {
        return this.id;
    }

    public String getUserId() {
        return this.userId;
    }

    public boolean isOrderUpdates() {
        return this.orderUpdates;
    }

    public boolean isDeliveryUpdates() {
        return this.deliveryUpdates;
    }

    public boolean isCouponsDeals() {
        return this.couponsDeals;
    }

    public boolean isPromotions() {
        return this.promotions;
    }

    public boolean isNewArrivals() {
        return this.newArrivals;
    }

    public boolean isPriceDropAlerts() {
        return this.priceDropAlerts;
    }

    public boolean isWeeklyDeals() {
        return this.weeklyDeals;
    }

    public boolean isEmailNotifications() {
        return this.emailNotifications;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setOrderUpdates(boolean orderUpdates) {
        this.orderUpdates = orderUpdates;
    }

    public void setDeliveryUpdates(boolean deliveryUpdates) {
        this.deliveryUpdates = deliveryUpdates;
    }

    public void setCouponsDeals(boolean couponsDeals) {
        this.couponsDeals = couponsDeals;
    }

    public void setPromotions(boolean promotions) {
        this.promotions = promotions;
    }

    public void setNewArrivals(boolean newArrivals) {
        this.newArrivals = newArrivals;
    }

    public void setPriceDropAlerts(boolean priceDropAlerts) {
        this.priceDropAlerts = priceDropAlerts;
    }

    public void setWeeklyDeals(boolean weeklyDeals) {
        this.weeklyDeals = weeklyDeals;
    }

    public void setEmailNotifications(boolean emailNotifications) {
        this.emailNotifications = emailNotifications;
    }

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof NotificationSettings)) {
            return false;
        }
        NotificationSettings other = (NotificationSettings)o;
        if (!other.canEqual((Object)this)) {
            return false;
        }
        if (this.isOrderUpdates() != other.isOrderUpdates()) {
            return false;
        }
        if (this.isDeliveryUpdates() != other.isDeliveryUpdates()) {
            return false;
        }
        if (this.isCouponsDeals() != other.isCouponsDeals()) {
            return false;
        }
        if (this.isPromotions() != other.isPromotions()) {
            return false;
        }
        if (this.isNewArrivals() != other.isNewArrivals()) {
            return false;
        }
        if (this.isPriceDropAlerts() != other.isPriceDropAlerts()) {
            return false;
        }
        if (this.isWeeklyDeals() != other.isWeeklyDeals()) {
            return false;
        }
        if (this.isEmailNotifications() != other.isEmailNotifications()) {
            return false;
        }
        String this$id = this.getId();
        String other$id = other.getId();
        if (this$id == null ? other$id != null : !this$id.equals(other$id)) {
            return false;
        }
        String this$userId = this.getUserId();
        String other$userId = other.getUserId();
        return !(this$userId == null ? other$userId != null : !this$userId.equals(other$userId));
    }

    protected boolean canEqual(Object other) {
        return other instanceof NotificationSettings;
    }

    public int hashCode() {
        int PRIME = 59;
        int result = 1;
        result = result * 59 + (this.isOrderUpdates() ? 79 : 97);
        result = result * 59 + (this.isDeliveryUpdates() ? 79 : 97);
        result = result * 59 + (this.isCouponsDeals() ? 79 : 97);
        result = result * 59 + (this.isPromotions() ? 79 : 97);
        result = result * 59 + (this.isNewArrivals() ? 79 : 97);
        result = result * 59 + (this.isPriceDropAlerts() ? 79 : 97);
        result = result * 59 + (this.isWeeklyDeals() ? 79 : 97);
        result = result * 59 + (this.isEmailNotifications() ? 79 : 97);
        String $id = this.getId();
        result = result * 59 + ($id == null ? 43 : $id.hashCode());
        String $userId = this.getUserId();
        result = result * 59 + ($userId == null ? 43 : $userId.hashCode());
        return result;
    }

    public String toString() {
        return "NotificationSettings(id=" + this.getId() + ", userId=" + this.getUserId() + ", orderUpdates=" + this.isOrderUpdates() + ", deliveryUpdates=" + this.isDeliveryUpdates() + ", couponsDeals=" + this.isCouponsDeals() + ", promotions=" + this.isPromotions() + ", newArrivals=" + this.isNewArrivals() + ", priceDropAlerts=" + this.isPriceDropAlerts() + ", weeklyDeals=" + this.isWeeklyDeals() + ", emailNotifications=" + this.isEmailNotifications() + ")";
    }

    public NotificationSettings() {
    }

    public NotificationSettings(String id, String userId, boolean orderUpdates, boolean deliveryUpdates, boolean couponsDeals, boolean promotions, boolean newArrivals, boolean priceDropAlerts, boolean weeklyDeals, boolean emailNotifications) {
        this.id = id;
        this.userId = userId;
        this.orderUpdates = orderUpdates;
        this.deliveryUpdates = deliveryUpdates;
        this.couponsDeals = couponsDeals;
        this.promotions = promotions;
        this.newArrivals = newArrivals;
        this.priceDropAlerts = priceDropAlerts;
        this.weeklyDeals = weeklyDeals;
        this.emailNotifications = emailNotifications;
    }
}

