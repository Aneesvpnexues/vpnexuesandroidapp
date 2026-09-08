package com.vpnexues.service;

import com.vpnexues.dto.CartItemRequest;
import com.vpnexues.model.CartItem;
import com.vpnexues.model.Product;
import com.vpnexues.repository.CartItemRepository;
import com.vpnexues.repository.ProductRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class CartService {

    private final CartItemRepository cartItemRepository;
    private final ProductRepository productRepository;

    public CartService(CartItemRepository cartItemRepository, ProductRepository productRepository) {
        this.cartItemRepository = cartItemRepository;
        this.productRepository = productRepository;
    }

    public List<Map<String, Object>> getCartItems(Long userId) {
        List<CartItem> cartItems = cartItemRepository.findByUserId(userId);
        List<Map<String, Object>> result = new ArrayList<>();

        for (CartItem item : cartItems) {
            Optional<Product> product = productRepository.findById(item.getProductId());
            if (product.isPresent()) {
                Map<String, Object> map = new java.util.HashMap<>();
                map.put("id", item.getId());
                map.put("userId", item.getUserId());
                map.put("productId", item.getProductId());
                map.put("quantity", item.getQuantity());
                map.put("product", product.get());
                result.add(map);
            }
        }
        return result;
    }

    public CartItem addToCart(CartItemRequest request) {
        Optional<CartItem> existing = cartItemRepository
                .findByUserIdAndProductId(request.getUserId(), request.getProductId());

        if (existing.isPresent()) {
            CartItem item = existing.get();
            item.setQuantity(request.getQuantity());
            return cartItemRepository.save(item);
        } else {
            CartItem item = new CartItem(request.getUserId(), request.getProductId(), request.getQuantity());
            return cartItemRepository.save(item);
        }
    }

    public CartItem updateQuantity(CartItemRequest request) {
        Optional<CartItem> existing = cartItemRepository
                .findByUserIdAndProductId(request.getUserId(), request.getProductId());

        if (existing.isPresent()) {
            CartItem item = existing.get();
            item.setQuantity(request.getQuantity());
            return cartItemRepository.save(item);
        }
        return null;
    }

    public void removeFromCart(Long userId, String productId) {
        cartItemRepository.deleteByUserIdAndProductId(userId, productId);
    }
}
