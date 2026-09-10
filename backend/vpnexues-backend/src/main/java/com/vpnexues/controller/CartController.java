package com.vpnexues.controller;

import com.vpnexues.dto.ApiResponse;
import com.vpnexues.dto.CartItemRequest;
import com.vpnexues.model.Cart;
import com.vpnexues.service.CartService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cart")
public class CartController {

    private final CartService cartService;

    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    @GetMapping
    public ResponseEntity<List<Cart.CartItem>> getCart() {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(cartService.getCartItems(userId));
    }

    @PostMapping
    public ResponseEntity<Cart> addItem(@Valid @RequestBody CartItemRequest request) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(cartService.addItem(userId, request));
    }

    @PutMapping
    public ResponseEntity<Cart> updateItem(@Valid @RequestBody CartItemRequest request) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        return ResponseEntity.ok(cartService.updateItem(userId, request));
    }

    @DeleteMapping("/{productId}")
    public ResponseEntity<ApiResponse> removeItem(@PathVariable String productId) {
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        cartService.removeItem(userId, productId);
        return ResponseEntity.ok(ApiResponse.success("Item removed from cart"));
    }
}
