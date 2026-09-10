package com.vpnexues.controller;

import com.vpnexues.dto.ApiResponse;
import com.vpnexues.dto.PaymentMethodRequest;
import com.vpnexues.model.PaymentMethod;
import com.vpnexues.service.PaymentMethodService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/payment-methods")
public class PaymentMethodController {

    private final PaymentMethodService paymentMethodService;

    public PaymentMethodController(PaymentMethodService paymentMethodService) {
        this.paymentMethodService = paymentMethodService;
    }

    @GetMapping
    public ResponseEntity<List<PaymentMethod>> getPaymentMethods() {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(paymentMethodService.getPaymentMethods(userId));
    }

    @PostMapping
    public ResponseEntity<PaymentMethod> addPaymentMethod(@Valid @RequestBody PaymentMethodRequest request) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(paymentMethodService.addPaymentMethod(userId, request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<PaymentMethod> updatePaymentMethod(@PathVariable String id,
                                                             @Valid @RequestBody PaymentMethodRequest request) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(paymentMethodService.updatePaymentMethod(userId, id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse> deletePaymentMethod(@PathVariable String id) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        paymentMethodService.deletePaymentMethod(userId, id);
        return ResponseEntity.ok(ApiResponse.success("Payment method deleted"));
    }

    @PutMapping("/{id}/default")
    public ResponseEntity<ApiResponse> setDefault(@PathVariable String id) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        paymentMethodService.setDefault(userId, id);
        return ResponseEntity.ok(ApiResponse.success("Default payment method updated"));
    }
}
