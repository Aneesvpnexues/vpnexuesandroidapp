/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.dto.NotificationSettingsRequest
 */
package com.vpnexues.dto;

public class NotificationSettingsRequest {
    private boolean orderUpdates;
    private boolean deliveryUpdates;
    private boolean couponsDeals;
    private boolean promotions;
    private boolean newArrivals;
    private boolean priceDropAlerts;
    private boolean weeklyDeals;
    private boolean emailNotifications;

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
        if (!(o instanceof NotificationSettingsRequest)) {
            return false;
        }
        NotificationSettingsRequest other = (NotificationSettingsRequest)o;
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
        return this.isEmailNotifications() == other.isEmailNotifications();
    }

    protected boolean canEqual(Object other) {
        return other instanceof NotificationSettingsRequest;
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
        return result;
    }

    public String toString() {
        return "NotificationSettingsRequest(orderUpdates=" + this.isOrderUpdates() + ", deliveryUpdates=" + this.isDeliveryUpdates() + ", couponsDeals=" + this.isCouponsDeals() + ", promotions=" + this.isPromotions() + ", newArrivals=" + this.isNewArrivals() + ", priceDropAlerts=" + this.isPriceDropAlerts() + ", weeklyDeals=" + this.isWeeklyDeals() + ", emailNotifications=" + this.isEmailNotifications() + ")";
    }

    public NotificationSettingsRequest() {
    }

    public NotificationSettingsRequest(boolean orderUpdates, boolean deliveryUpdates, boolean couponsDeals, boolean promotions, boolean newArrivals, boolean priceDropAlerts, boolean weeklyDeals, boolean emailNotifications) {
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

