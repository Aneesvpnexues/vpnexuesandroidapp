/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.model.PaymentMethod
 *  org.springframework.data.annotation.CreatedDate
 *  org.springframework.data.annotation.Id
 *  org.springframework.data.mongodb.core.index.Indexed
 *  org.springframework.data.mongodb.core.mapping.Document
 */
package com.vpnexues.model;

import java.time.Instant;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection="payment_methods")
public class PaymentMethod {
    @Id
    private String id;
    @Indexed
    private String userId;
    private String type = "cash_on_delivery";
    private String cardNumber;
    private String last4Digits;
    private String cardHolderName;
    private String expiryMonth;
    private String expiryYear;
    private String upiId;
    private String bankName;
    private boolean isDefault = false;
    @CreatedDate
    private Instant createdAt;

    public String getId() {
        return this.id;
    }

    public String getUserId() {
        return this.userId;
    }

    public String getType() {
        return this.type;
    }

    public String getCardNumber() {
        return this.cardNumber;
    }

    public String getLast4Digits() {
        return this.last4Digits;
    }

    public String getCardHolderName() {
        return this.cardHolderName;
    }

    public String getExpiryMonth() {
        return this.expiryMonth;
    }

    public String getExpiryYear() {
        return this.expiryYear;
    }

    public String getUpiId() {
        return this.upiId;
    }

    public String getBankName() {
        return this.bankName;
    }

    public boolean isDefault() {
        return this.isDefault;
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

    public void setType(String type) {
        this.type = type;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public void setLast4Digits(String last4Digits) {
        this.last4Digits = last4Digits;
    }

    public void setCardHolderName(String cardHolderName) {
        this.cardHolderName = cardHolderName;
    }

    public void setExpiryMonth(String expiryMonth) {
        this.expiryMonth = expiryMonth;
    }

    public void setExpiryYear(String expiryYear) {
        this.expiryYear = expiryYear;
    }

    public void setUpiId(String upiId) {
        this.upiId = upiId;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public void setDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof PaymentMethod)) {
            return false;
        }
        PaymentMethod other = (PaymentMethod)o;
        if (!other.canEqual((Object)this)) {
            return false;
        }
        if (this.isDefault() != other.isDefault()) {
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
        String this$type = this.getType();
        String other$type = other.getType();
        if (this$type == null ? other$type != null : !this$type.equals(other$type)) {
            return false;
        }
        String this$cardNumber = this.getCardNumber();
        String other$cardNumber = other.getCardNumber();
        if (this$cardNumber == null ? other$cardNumber != null : !this$cardNumber.equals(other$cardNumber)) {
            return false;
        }
        String this$last4Digits = this.getLast4Digits();
        String other$last4Digits = other.getLast4Digits();
        if (this$last4Digits == null ? other$last4Digits != null : !this$last4Digits.equals(other$last4Digits)) {
            return false;
        }
        String this$cardHolderName = this.getCardHolderName();
        String other$cardHolderName = other.getCardHolderName();
        if (this$cardHolderName == null ? other$cardHolderName != null : !this$cardHolderName.equals(other$cardHolderName)) {
            return false;
        }
        String this$expiryMonth = this.getExpiryMonth();
        String other$expiryMonth = other.getExpiryMonth();
        if (this$expiryMonth == null ? other$expiryMonth != null : !this$expiryMonth.equals(other$expiryMonth)) {
            return false;
        }
        String this$expiryYear = this.getExpiryYear();
        String other$expiryYear = other.getExpiryYear();
        if (this$expiryYear == null ? other$expiryYear != null : !this$expiryYear.equals(other$expiryYear)) {
            return false;
        }
        String this$upiId = this.getUpiId();
        String other$upiId = other.getUpiId();
        if (this$upiId == null ? other$upiId != null : !this$upiId.equals(other$upiId)) {
            return false;
        }
        String this$bankName = this.getBankName();
        String other$bankName = other.getBankName();
        if (this$bankName == null ? other$bankName != null : !this$bankName.equals(other$bankName)) {
            return false;
        }
        Instant this$createdAt = this.getCreatedAt();
        Instant other$createdAt = other.getCreatedAt();
        return !(this$createdAt == null ? other$createdAt != null : !((Object)this$createdAt).equals(other$createdAt));
    }

    protected boolean canEqual(Object other) {
        return other instanceof PaymentMethod;
    }

    public int hashCode() {
        int PRIME = 59;
        int result = 1;
        result = result * 59 + (this.isDefault() ? 79 : 97);
        String $id = this.getId();
        result = result * 59 + ($id == null ? 43 : $id.hashCode());
        String $userId = this.getUserId();
        result = result * 59 + ($userId == null ? 43 : $userId.hashCode());
        String $type = this.getType();
        result = result * 59 + ($type == null ? 43 : $type.hashCode());
        String $cardNumber = this.getCardNumber();
        result = result * 59 + ($cardNumber == null ? 43 : $cardNumber.hashCode());
        String $last4Digits = this.getLast4Digits();
        result = result * 59 + ($last4Digits == null ? 43 : $last4Digits.hashCode());
        String $cardHolderName = this.getCardHolderName();
        result = result * 59 + ($cardHolderName == null ? 43 : $cardHolderName.hashCode());
        String $expiryMonth = this.getExpiryMonth();
        result = result * 59 + ($expiryMonth == null ? 43 : $expiryMonth.hashCode());
        String $expiryYear = this.getExpiryYear();
        result = result * 59 + ($expiryYear == null ? 43 : $expiryYear.hashCode());
        String $upiId = this.getUpiId();
        result = result * 59 + ($upiId == null ? 43 : $upiId.hashCode());
        String $bankName = this.getBankName();
        result = result * 59 + ($bankName == null ? 43 : $bankName.hashCode());
        Instant $createdAt = this.getCreatedAt();
        result = result * 59 + ($createdAt == null ? 43 : ((Object)$createdAt).hashCode());
        return result;
    }

    public String toString() {
        return "PaymentMethod(id=" + this.getId() + ", userId=" + this.getUserId() + ", type=" + this.getType() + ", cardNumber=" + this.getCardNumber() + ", last4Digits=" + this.getLast4Digits() + ", cardHolderName=" + this.getCardHolderName() + ", expiryMonth=" + this.getExpiryMonth() + ", expiryYear=" + this.getExpiryYear() + ", upiId=" + this.getUpiId() + ", bankName=" + this.getBankName() + ", isDefault=" + this.isDefault() + ", createdAt=" + String.valueOf(this.getCreatedAt()) + ")";
    }

    public PaymentMethod() {
    }

    public PaymentMethod(String id, String userId, String type, String cardNumber, String last4Digits, String cardHolderName, String expiryMonth, String expiryYear, String upiId, String bankName, boolean isDefault, Instant createdAt) {
        this.id = id;
        this.userId = userId;
        this.type = type;
        this.cardNumber = cardNumber;
        this.last4Digits = last4Digits;
        this.cardHolderName = cardHolderName;
        this.expiryMonth = expiryMonth;
        this.expiryYear = expiryYear;
        this.upiId = upiId;
        this.bankName = bankName;
        this.isDefault = isDefault;
        this.createdAt = createdAt;
    }
}

