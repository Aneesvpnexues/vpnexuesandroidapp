package com.vpnexues.service;

import com.vpnexues.dto.CartItemRequest;
import com.vpnexues.model.Cart;
import com.vpnexues.model.Cart.CartItem;
import com.vpnexues.model.Product;
import com.vpnexues.repository.CartRepository;
import com.vpnexues.repository.ProductRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Service
public class CartService {

    private final CartRepository cartRepository;
    private final ProductRepository productRepository;

    public CartService(CartRepository cartRepository, ProductRepository productRepository) {
        this.cartRepository = cartRepository;
        this.productRepository = productRepository;
    }

    public List<CartItem> getCartItems(String userId) {
        Cart cart = getOrCreateCart(userId);
        return cart.getItems();
    }

    @Transactional
    public Cart addItem(String userId, CartItemRequest request) {
        Cart cart = getOrCreateCart(userId);
        Product product = productRepository.findById(request.getProductId())
                .orElseThrow(() -> new RuntimeException("Product not found"));

        for (CartItem item : cart.getItems()) {
            if (item.getProductId().equals(request.getProductId())) {
                item.setQuantity(item.getQuantity() + request.getQuantity());
                cart.setUpdatedAt(Instant.now());
                return cartRepository.save(cart);
            }
        }

        CartItem item = new CartItem();
        item.setId(UUID.randomUUID().toString());
        item.setCart(cart);
        item.setProductId(product.getId());
        item.setName(product.getName());
        item.setImageUrl(product.getImageUrl());
        item.setCurrentPrice(product.getCurrentPrice());
        item.setWeight(product.getWeight());
        item.setQuantity(request.getQuantity());
        cart.getItems().add(item);
        cart.setUpdatedAt(Instant.now());
        return cartRepository.save(cart);
    }

    @Transactional
    public Cart updateItem(String userId, CartItemRequest request) {
        Cart cart = getOrCreateCart(userId);
        for (CartItem item : cart.getItems()) {
            if (item.getProductId().equals(request.getProductId())) {
                if (request.getQuantity() <= 0) {
                    cart.getItems().remove(item);
                } else {
                    item.setQuantity(request.getQuantity());
                }
                cart.setUpdatedAt(Instant.now());
                return cartRepository.save(cart);
            }
        }
        throw new RuntimeException("Item not found in cart");
    }

    @Transactional
    public Cart removeItem(String userId, String productId) {
        Cart cart = getOrCreateCart(userId);
        cart.getItems().removeIf(item -> item.getProductId().equals(productId));
        cart.setUpdatedAt(Instant.now());
        return cartRepository.save(cart);
    }

    private Cart getOrCreateCart(String userId) {
        return cartRepository.findByUserId(userId).orElseGet(() -> {
            Cart cart = new Cart();
            cart.setId(UUID.randomUUID().toString());
            cart.setUserId(userId);
            return cartRepository.save(cart);
        });
    }
}
