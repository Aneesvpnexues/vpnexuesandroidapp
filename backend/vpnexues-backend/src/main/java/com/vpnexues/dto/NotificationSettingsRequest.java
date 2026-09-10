package com.vpnexues.dto;

public class NotificationSettingsRequest {

    private boolean orderUpdates = true;
    private boolean deliveryUpdates = true;
    private boolean couponsDeals = true;
    private boolean promotions = false;
    private boolean newArrivals = true;
    private boolean priceDropAlerts = false;
    private boolean weeklyDeals = true;
    private boolean emailNotifications = false;

    public boolean isOrderUpdates() {
        return orderUpdates;
    }

    public void setOrderUpdates(boolean orderUpdates) {
        this.orderUpdates = orderUpdates;
    }

    public boolean isDeliveryUpdates() {
        return deliveryUpdates;
    }

    public void setDeliveryUpdates(boolean deliveryUpdates) {
        this.deliveryUpdates = deliveryUpdates;
    }

    public boolean isCouponsDeals() {
        return couponsDeals;
    }

    public void setCouponsDeals(boolean couponsDeals) {
        this.couponsDeals = couponsDeals;
    }

    public boolean isPromotions() {
        return promotions;
    }

    public void setPromotions(boolean promotions) {
        this.promotions = promotions;
    }

    public boolean isNewArrivals() {
        return newArrivals;
    }

    public void setNewArrivals(boolean newArrivals) {
        this.newArrivals = newArrivals;
    }

    public boolean isPriceDropAlerts() {
        return priceDropAlerts;
    }

    public void setPriceDropAlerts(boolean priceDropAlerts) {
        this.priceDropAlerts = priceDropAlerts;
    }

    public boolean isWeeklyDeals() {
        return weeklyDeals;
    }

    public void setWeeklyDeals(boolean weeklyDeals) {
        this.weeklyDeals = weeklyDeals;
    }

    public boolean isEmailNotifications() {
        return emailNotifications;
    }

    public void setEmailNotifications(boolean emailNotifications) {
        this.emailNotifications = emailNotifications;
    }
}
