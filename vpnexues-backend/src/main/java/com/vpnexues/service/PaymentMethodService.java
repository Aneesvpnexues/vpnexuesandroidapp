package com.vpnexues.service;

import com.vpnexues.dto.PaymentMethodRequest;
import com.vpnexues.model.PaymentMethod;
import com.vpnexues.repository.PaymentMethodRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
public class PaymentMethodService {

    private final PaymentMethodRepository paymentMethodRepository;

    public PaymentMethodService(PaymentMethodRepository paymentMethodRepository) {
        this.paymentMethodRepository = paymentMethodRepository;
    }

    public List<PaymentMethod> getPaymentMethods(String userId) {
        return paymentMethodRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId);
    }

    @Transactional
    public PaymentMethod addPaymentMethod(String userId, PaymentMethodRequest request) {
        if (request.isDefault()) {
            unsetAllDefaults(userId);
        }
        PaymentMethod method = new PaymentMethod();
        method.setId(UUID.randomUUID().toString());
        method.setUserId(userId);
        method.setType(request.getType());
        method.setCardHolderName(request.getCardHolderName());
        method.setExpiryMonth(request.getExpiryMonth());
        method.setExpiryYear(request.getExpiryYear());
        method.setUpiId(request.getUpiId());
        method.setBankName(request.getBankName());
        method.setDefault(request.isDefault());

        if (request.getCardNumber() != null && request.getCardNumber().length() >= 4) {
            method.setCardNumber(request.getCardNumber());
            method.setLast4Digits(request.getCardNumber().substring(request.getCardNumber().length() - 4));
        }

        return paymentMethodRepository.save(method);
    }

    @Transactional
    public PaymentMethod updatePaymentMethod(String userId, String id, PaymentMethodRequest request) {
        PaymentMethod method = paymentMethodRepository.findById(id)
                .filter(m -> m.getUserId().equals(userId))
                .orElseThrow(() -> new RuntimeException("Payment method not found"));
        if (request.isDefault()) {
            unsetAllDefaults(userId);
        }
        method.setType(request.getType());
        method.setCardHolderName(request.getCardHolderName());
        method.setExpiryMonth(request.getExpiryMonth());
        method.setExpiryYear(request.getExpiryYear());
        method.setUpiId(request.getUpiId());
        method.setBankName(request.getBankName());
        method.setDefault(request.isDefault());

        if (request.getCardNumber() != null && request.getCardNumber().length() >= 4) {
            method.setCardNumber(request.getCardNumber());
            method.setLast4Digits(request.getCardNumber().substring(request.getCardNumber().length() - 4));
        }

        return paymentMethodRepository.save(method);
    }

    @Transactional
    public void deletePaymentMethod(String userId, String id) {
        paymentMethodRepository.deleteByUserIdAndId(userId, id);
    }

    @Transactional
    public void setDefault(String userId, String id) {
        unsetAllDefaults(userId);
        PaymentMethod method = paymentMethodRepository.findById(id)
                .filter(m -> m.getUserId().equals(userId))
                .orElseThrow(() -> new RuntimeException("Payment method not found"));
        method.setDefault(true);
        paymentMethodRepository.save(method);
    }

    private void unsetAllDefaults(String userId) {
        List<PaymentMethod> methods = paymentMethodRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId);
        for (PaymentMethod method : methods) {
            if (method.isDefault()) {
                method.setDefault(false);
                paymentMethodRepository.save(method);
            }
        }
    }
}
