/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.dto.PaymentMethodRequest
 *  com.vpnexues.model.PaymentMethod
 *  com.vpnexues.repository.PaymentMethodRepository
 *  com.vpnexues.service.PaymentMethodService
 *  org.springframework.stereotype.Service
 */
package com.vpnexues.service;

import com.vpnexues.dto.PaymentMethodRequest;
import com.vpnexues.model.PaymentMethod;
import com.vpnexues.repository.PaymentMethodRepository;
import java.time.Instant;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class PaymentMethodService {
    private final PaymentMethodRepository paymentMethodRepository;

    public List<PaymentMethod> getPaymentMethods(String userId) {
        return this.paymentMethodRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId);
    }

    public PaymentMethod addPaymentMethod(String userId, PaymentMethodRequest request) {
        PaymentMethod paymentMethod = new PaymentMethod();
        paymentMethod.setUserId(userId);
        paymentMethod.setType(request.getType());
        paymentMethod.setCardHolderName(request.getCardHolderName());
        paymentMethod.setExpiryMonth(request.getExpiryMonth());
        paymentMethod.setExpiryYear(request.getExpiryYear());
        paymentMethod.setUpiId(request.getUpiId());
        paymentMethod.setBankName(request.getBankName());
        paymentMethod.setDefault(request.isDefault());
        paymentMethod.setCreatedAt(Instant.now());
        if (request.getCardNumber() != null && !request.getCardNumber().isEmpty()) {
            String cleaned = request.getCardNumber().replaceAll("\\s", "");
            paymentMethod.setLast4Digits(cleaned.substring(Math.max(0, cleaned.length() - 4)));
        }
        if (request.isDefault()) {
            this.unsetAllDefaults(userId);
        }
        if (this.paymentMethodRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId).isEmpty()) {
            paymentMethod.setDefault(true);
        }
        return (PaymentMethod)this.paymentMethodRepository.save((Object)paymentMethod);
    }

    public PaymentMethod updatePaymentMethod(String userId, String id, PaymentMethodRequest request) {
        PaymentMethod paymentMethod = (PaymentMethod)this.paymentMethodRepository.findById((Object)id).orElseThrow(() -> new RuntimeException("Payment method not found"));
        if (!paymentMethod.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized: payment method does not belong to this user");
        }
        paymentMethod.setType(request.getType());
        paymentMethod.setCardHolderName(request.getCardHolderName());
        paymentMethod.setExpiryMonth(request.getExpiryMonth());
        paymentMethod.setExpiryYear(request.getExpiryYear());
        paymentMethod.setUpiId(request.getUpiId());
        paymentMethod.setBankName(request.getBankName());
        if (request.getCardNumber() != null && !request.getCardNumber().isEmpty()) {
            String cleaned = request.getCardNumber().replaceAll("\\s", "");
            paymentMethod.setLast4Digits(cleaned.substring(Math.max(0, cleaned.length() - 4)));
        }
        if (request.isDefault() && !paymentMethod.isDefault()) {
            this.unsetAllDefaults(userId);
            paymentMethod.setDefault(true);
        }
        return (PaymentMethod)this.paymentMethodRepository.save((Object)paymentMethod);
    }

    public void deletePaymentMethod(String userId, String id) {
        List remaining;
        PaymentMethod paymentMethod = (PaymentMethod)this.paymentMethodRepository.findById((Object)id).orElseThrow(() -> new RuntimeException("Payment method not found"));
        if (!paymentMethod.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized: payment method does not belong to this user");
        }
        boolean wasDefault = paymentMethod.isDefault();
        this.paymentMethodRepository.delete((Object)paymentMethod);
        if (wasDefault && !(remaining = this.paymentMethodRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId)).isEmpty()) {
            PaymentMethod next = (PaymentMethod)remaining.get(0);
            next.setDefault(true);
            this.paymentMethodRepository.save((Object)next);
        }
    }

    public PaymentMethod setDefault(String userId, String id) {
        PaymentMethod paymentMethod = (PaymentMethod)this.paymentMethodRepository.findById((Object)id).orElseThrow(() -> new RuntimeException("Payment method not found"));
        if (!paymentMethod.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized: payment method does not belong to this user");
        }
        this.unsetAllDefaults(userId);
        paymentMethod.setDefault(true);
        return (PaymentMethod)this.paymentMethodRepository.save((Object)paymentMethod);
    }

    private void unsetAllDefaults(String userId) {
        List methods = this.paymentMethodRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId);
        for (PaymentMethod method : methods) {
            if (!method.isDefault()) continue;
            method.setDefault(false);
            this.paymentMethodRepository.save((Object)method);
        }
    }

    public PaymentMethodService(PaymentMethodRepository paymentMethodRepository) {
        this.paymentMethodRepository = paymentMethodRepository;
    }
}

