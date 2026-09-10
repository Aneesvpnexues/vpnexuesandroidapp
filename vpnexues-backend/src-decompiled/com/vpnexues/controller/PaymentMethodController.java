/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.controller.PaymentMethodController
 *  com.vpnexues.dto.PaymentMethodRequest
 *  com.vpnexues.model.PaymentMethod
 *  com.vpnexues.service.PaymentMethodService
 *  jakarta.validation.Valid
 *  org.springframework.http.ResponseEntity
 *  org.springframework.security.core.Authentication
 *  org.springframework.security.core.context.SecurityContextHolder
 *  org.springframework.web.bind.annotation.DeleteMapping
 *  org.springframework.web.bind.annotation.GetMapping
 *  org.springframework.web.bind.annotation.PathVariable
 *  org.springframework.web.bind.annotation.PostMapping
 *  org.springframework.web.bind.annotation.PutMapping
 *  org.springframework.web.bind.annotation.RequestBody
 *  org.springframework.web.bind.annotation.RequestMapping
 *  org.springframework.web.bind.annotation.RestController
 */
package com.vpnexues.controller;

import com.vpnexues.dto.PaymentMethodRequest;
import com.vpnexues.model.PaymentMethod;
import com.vpnexues.service.PaymentMethodService;
import jakarta.validation.Valid;
import java.util.List;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value={"/api/payment-methods"})
public class PaymentMethodController {
    private final PaymentMethodService paymentMethodService;

    private String getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getName();
    }

    @GetMapping
    public ResponseEntity<List<PaymentMethod>> getPaymentMethods() {
        String userId = this.getCurrentUserId();
        return ResponseEntity.ok((Object)this.paymentMethodService.getPaymentMethods(userId));
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> addPaymentMethod(@Valid @RequestBody PaymentMethodRequest request) {
        String userId = this.getCurrentUserId();
        PaymentMethod paymentMethod = this.paymentMethodService.addPaymentMethod(userId, request);
        return ResponseEntity.ok(Map.of("message", "Payment method added successfully", "paymentMethod", paymentMethod));
    }

    @PutMapping(value={"/{id}"})
    public ResponseEntity<Map<String, Object>> updatePaymentMethod(@PathVariable String id, @Valid @RequestBody PaymentMethodRequest request) {
        String userId = this.getCurrentUserId();
        PaymentMethod paymentMethod = this.paymentMethodService.updatePaymentMethod(userId, id, request);
        return ResponseEntity.ok(Map.of("message", "Payment method updated successfully", "paymentMethod", paymentMethod));
    }

    @DeleteMapping(value={"/{id}"})
    public ResponseEntity<Map<String, String>> deletePaymentMethod(@PathVariable String id) {
        String userId = this.getCurrentUserId();
        this.paymentMethodService.deletePaymentMethod(userId, id);
        return ResponseEntity.ok(Map.of("message", "Payment method deleted successfully"));
    }

    @PutMapping(value={"/{id}/default"})
    public ResponseEntity<Map<String, Object>> setDefault(@PathVariable String id) {
        String userId = this.getCurrentUserId();
        PaymentMethod paymentMethod = this.paymentMethodService.setDefault(userId, id);
        return ResponseEntity.ok(Map.of("message", "Default payment method updated", "paymentMethod", paymentMethod));
    }

    public PaymentMethodController(PaymentMethodService paymentMethodService) {
        this.paymentMethodService = paymentMethodService;
    }
}

