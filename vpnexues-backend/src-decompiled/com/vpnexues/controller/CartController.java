/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.controller.CartController
 *  com.vpnexues.dto.CartItemRequest
 *  com.vpnexues.model.Cart$CartItem
 *  com.vpnexues.service.CartService
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

import com.vpnexues.dto.CartItemRequest;
import com.vpnexues.model.Cart;
import com.vpnexues.service.CartService;
import jakarta.validation.Valid;
import java.util.List;
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
@RequestMapping(value={"/api/cart"})
public class CartController {
    private final CartService cartService;

    private String getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getName();
    }

    @GetMapping
    public ResponseEntity<List<Cart.CartItem>> getCart() {
        String userId = this.getCurrentUserId();
        return ResponseEntity.ok((Object)this.cartService.getCart(userId));
    }

    @PostMapping
    public ResponseEntity<List<Cart.CartItem>> addItem(@Valid @RequestBody CartItemRequest request) {
        String userId = this.getCurrentUserId();
        return ResponseEntity.ok((Object)this.cartService.addItem(userId, request));
    }

    @PutMapping
    public ResponseEntity<List<Cart.CartItem>> updateQuantity(@Valid @RequestBody CartItemRequest request) {
        String userId = this.getCurrentUserId();
        return ResponseEntity.ok((Object)this.cartService.updateQuantity(userId, request));
    }

    @DeleteMapping(value={"/{productId}"})
    public ResponseEntity<List<Cart.CartItem>> removeItem(@PathVariable String productId) {
        String userId = this.getCurrentUserId();
        return ResponseEntity.ok((Object)this.cartService.removeItem(userId, productId));
    }

    public CartController(CartService cartService) {
        this.cartService = cartService;
    }
}

