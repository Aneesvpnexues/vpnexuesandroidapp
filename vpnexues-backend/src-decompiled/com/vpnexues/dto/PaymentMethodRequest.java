/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.dto.PaymentMethodRequest
 *  jakarta.validation.constraints.NotBlank
 */
package com.vpnexues.dto;

import jakarta.validation.constraints.NotBlank;

public class PaymentMethodRequest {
    @NotBlank(message="Payment type is required")
    private @NotBlank(message="Payment type is required") String type;
    private String cardNumber;
    private String cardHolderName;
    private String expiryMonth;
    private String expiryYear;
    private String upiId;
    private String bankName;
    private boolean isDefault;

    public String getType() {
        return this.type;
    }

    public String getCardNumber() {
        return this.cardNumber;
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

    public void setType(String type) {
        this.type = type;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
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

    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (!(o instanceof PaymentMethodRequest)) {
            return false;
        }
        PaymentMethodRequest other = (PaymentMethodRequest)o;
        if (!other.canEqual((Object)this)) {
            return false;
        }
        if (this.isDefault() != other.isDefault()) {
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
        return !(this$bankName == null ? other$bankName != null : !this$bankName.equals(other$bankName));
    }

    protected boolean canEqual(Object other) {
        return other instanceof PaymentMethodRequest;
    }

    public int hashCode() {
        int PRIME = 59;
        int result = 1;
        result = result * 59 + (this.isDefault() ? 79 : 97);
        String $type = this.getType();
        result = result * 59 + ($type == null ? 43 : $type.hashCode());
        String $cardNumber = this.getCardNumber();
        result = result * 59 + ($cardNumber == null ? 43 : $cardNumber.hashCode());
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
        return result;
    }

    public String toString() {
        return "PaymentMethodRequest(type=" + this.getType() + ", cardNumber=" + this.getCardNumber() + ", cardHolderName=" + this.getCardHolderName() + ", expiryMonth=" + this.getExpiryMonth() + ", expiryYear=" + this.getExpiryYear() + ", upiId=" + this.getUpiId() + ", bankName=" + this.getBankName() + ", isDefault=" + this.isDefault() + ")";
    }

    public PaymentMethodRequest() {
    }

    public PaymentMethodRequest(String type, String cardNumber, String cardHolderName, String expiryMonth, String expiryYear, String upiId, String bankName, boolean isDefault) {
        this.type = type;
        this.cardNumber = cardNumber;
        this.cardHolderName = cardHolderName;
        this.expiryMonth = expiryMonth;
        this.expiryYear = expiryYear;
        this.upiId = upiId;
        this.bankName = bankName;
        this.isDefault = isDefault;
    }
}

