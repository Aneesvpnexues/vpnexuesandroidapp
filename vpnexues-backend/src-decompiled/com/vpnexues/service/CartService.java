/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  com.vpnexues.dto.CartItemRequest
 *  com.vpnexues.model.Cart
 *  com.vpnexues.model.Cart$CartItem
 *  com.vpnexues.model.Product
 *  com.vpnexues.repository.CartRepository
 *  com.vpnexues.repository.ProductRepository
 *  com.vpnexues.service.CartService
 *  org.springframework.stereotype.Service
 */
package com.vpnexues.service;

import com.vpnexues.dto.CartItemRequest;
import com.vpnexues.model.Cart;
import com.vpnexues.model.Product;
import com.vpnexues.repository.CartRepository;
import com.vpnexues.repository.ProductRepository;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class CartService {
    private final CartRepository cartRepository;
    private final ProductRepository productRepository;

    public List<Cart.CartItem> getCart(String userId) {
        return this.cartRepository.findByUserId(userId).map(Cart::getItems).orElse(new ArrayList());
    }

    public List<Cart.CartItem> addItem(String userId, CartItemRequest request) {
        Cart cart = this.cartRepository.findByUserId(userId).orElseGet(() -> {
            Cart newCart = new Cart();
            newCart.setUserId(userId);
            newCart.setItems(new ArrayList());
            return newCart;
        });
        boolean found = false;
        for (Cart.CartItem item : cart.getItems()) {
            if (!item.getProductId().equals(request.getProductId())) continue;
            item.setQuantity(item.getQuantity() + request.getQuantity());
            found = true;
            break;
        }
        if (!found) {
            Product product = (Product)this.productRepository.findById((Object)request.getProductId()).orElseThrow(() -> new RuntimeException("Product not found"));
            Cart.CartItem newItem = new Cart.CartItem();
            newItem.setProductId(product.getId());
            newItem.setName(product.getName());
            newItem.setImageUrl(product.getImageUrl());
            newItem.setCurrentPrice(product.getCurrentPrice());
            newItem.setWeight(product.getWeight());
            newItem.setQuantity(request.getQuantity());
            cart.getItems().add(newItem);
        }
        cart.setUpdatedAt(Instant.now());
        this.cartRepository.save((Object)cart);
        return cart.getItems();
    }

    public List<Cart.CartItem> updateQuantity(String userId, CartItemRequest request) {
        Cart cart = (Cart)this.cartRepository.findByUserId(userId).orElseThrow(() -> new RuntimeException("Cart not found"));
        for (Cart.CartItem item : cart.getItems()) {
            if (!item.getProductId().equals(request.getProductId())) continue;
            if (request.getQuantity() <= 0) {
                cart.getItems().remove(item);
                break;
            }
            item.setQuantity(request.getQuantity());
            break;
        }
        cart.setUpdatedAt(Instant.now());
        this.cartRepository.save((Object)cart);
        return cart.getItems();
    }

    public List<Cart.CartItem> removeItem(String userId, String productId) {
        Cart cart = (Cart)this.cartRepository.findByUserId(userId).orElseThrow(() -> new RuntimeException("Cart not found"));
        cart.getItems().removeIf(item -> item.getProductId().equals(productId));
        cart.setUpdatedAt(Instant.now());
        this.cartRepository.save((Object)cart);
        return cart.getItems();
    }

    public void clearCart(String userId) {
        this.cartRepository.deleteByUserId(userId);
    }

    public CartService(CartRepository cartRepository, ProductRepository productRepository) {
        this.cartRepository = cartRepository;
        this.productRepository = productRepository;
    }
}

