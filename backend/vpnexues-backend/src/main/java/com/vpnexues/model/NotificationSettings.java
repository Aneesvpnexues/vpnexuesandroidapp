package com.vpnexues.model;

import jakarta.persistence.*;

@Entity
@Table(name = "notification_settings")
public class NotificationSettings {

    @Id
    private String id;

    @Column(name = "user_id")
    private String userId;

    @Column(name = "order_updates")
    private boolean orderUpdates = true;

    @Column(name = "delivery_updates")
    private boolean deliveryUpdates = true;

    @Column(name = "coupons_deals")
    private boolean couponsDeals = true;

    private boolean promotions = false;

    @Column(name = "new_arrivals")
    private boolean newArrivals = true;

    @Column(name = "price_drop_alerts")
    private boolean priceDropAlerts = false;

    @Column(name = "weekly_deals")
    private boolean weeklyDeals = true;

    @Column(name = "email_notifications")
    private boolean emailNotifications = false;

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
