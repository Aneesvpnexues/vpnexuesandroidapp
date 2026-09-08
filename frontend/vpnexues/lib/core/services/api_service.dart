import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:vpnexues_pvt/core/models/product.dart';
import 'package:vpnexues_pvt/core/services/api_config.dart';

class ApiService {
  static String get baseUrl => ApiConfig.baseUrl;

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // ── Products ──────────────────────────────────────────────────────

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/list'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('getProducts error: $e');
      return [];
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/category/$category/list'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('getProductsByCategory error: $e');
      return [];
    }
  }

  Future<List<Product>> getPopularProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/popular'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('getPopularProducts error: $e');
      return [];
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/search?q=$query'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('searchProducts error: $e');
      return [];
    }
  }

  // ── Auth ──────────────────────────────────────────────────────────

  Future<void> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        throw Exception('Failed to send OTP (server error ${response.statusCode})');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please check your connection.');
    } on Exception catch (e) {
      if (e.toString().contains('TimeoutException') ||
          e.toString().contains('SocketException')) {
        throw Exception('Cannot connect to server. Please check your connection.');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'otp': otp}),
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      String? serverMessage;
      try {
        final body = json.decode(response.body);
        if (body is Map) {
          serverMessage = body['message'] as String? ?? body['error'] as String?;
        }
      } catch (e) {
        debugPrint('verifyOtp response parse error: $e');
      }
      if (response.statusCode == 400) {
        throw Exception(serverMessage ?? 'Invalid OTP. Please check and try again.');
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else if (response.statusCode == 500) {
        throw Exception('Server error. Please try again.');
      }
      throw Exception(serverMessage ?? 'Server error (${response.statusCode})');
    } on TimeoutException {
      throw Exception('Connection timed out. Please check your connection.');
    } on Exception catch (e) {
      if (e.toString().contains('TimeoutException') ||
          e.toString().contains('SocketException')) {
        throw Exception('Cannot connect to server. Please check your connection.');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('getCurrentUser error: $e');
      return null;
    }
  }

  // ── Cart (JWT-authenticated, no userId needed) ────────────────────

  Future<List<Map<String, dynamic>>> getCartItems() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cart'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      debugPrint('getCartItems error: $e');
      return [];
    }
  }

  Future<void> addToCart(String productId, int quantity) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/cart'),
        headers: _headers,
        body: json.encode({'productId': productId, 'quantity': quantity}),
      );
    } catch (e) {
      debugPrint('addToCart error: $e');
    }
  }

  Future<void> updateCartQuantity(String productId, int quantity) async {
    try {
      await http.put(
        Uri.parse('$baseUrl/cart'),
        headers: _headers,
        body: json.encode({'productId': productId, 'quantity': quantity}),
      );
    } catch (e) {
      debugPrint('updateCartQuantity error: $e');
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      await http.delete(
        Uri.parse('$baseUrl/cart/$productId'),
        headers: _headers,
      );
    } catch (e) {
      debugPrint('removeFromCart error: $e');
    }
  }

  // ── Orders (JWT-authenticated) ───────────────────────────────────

  Future<Map<String, dynamic>?> placeOrder({
    required double subtotal,
    required double deliveryFee,
    required double deliveryDiscount,
    required double totalAmount,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
    String? paymentId,
    String? paymentStatus,
  }) async {
    try {
      final body = <String, dynamic>{
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'deliveryDiscount': deliveryDiscount,
        'totalAmount': totalAmount,
        'paymentMethod': paymentMethod,
        'items': items,
      };
      if (paymentId != null) body['paymentId'] = paymentId;
      if (paymentStatus != null) body['paymentStatus'] = paymentStatus;

      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: _headers,
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('placeOrder error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      debugPrint('getOrders error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getOrderById(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/$orderId'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('getOrderById error: $e');
      return null;
    }
  }

  // ── Cancel Order ─────────────────────────────────────────────

  Future<Map<String, dynamic>?> cancelOrder(String orderId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/orders/$orderId/cancel'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('cancelOrder error: $e');
      return null;
    }
  }

  // ── Addresses ───────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getAddresses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/addresses'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      debugPrint('getAddresses error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getDefaultAddress() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/addresses/default'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('getDefaultAddress error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> addAddress(Map<String, dynamic> addressData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addresses'),
        headers: _headers,
        body: json.encode(addressData),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('addAddress error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateAddress(String id, Map<String, dynamic> addressData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/addresses/$id'),
        headers: _headers,
        body: json.encode(addressData),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('updateAddress error: $e');
      return null;
    }
  }

  Future<bool> deleteAddress(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/addresses/$id'),
        headers: _headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('deleteAddress error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> setDefaultAddress(String id) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/addresses/$id/default'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('setDefaultAddress error: $e');
      return null;
    }
  }

  // ── Profile ────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> updateProfile({String? name, String? phone, String? language}) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (phone != null) body['phone'] = phone;
      if (language != null) body['language'] = language;
      final response = await http.put(
        Uri.parse('$baseUrl/auth/profile'),
        headers: _headers,
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('updateProfile error: $e');
      return null;
    }
  }

  // ── Product by ID ──────────────────────────────────────────────

  Future<Product?> getProductById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      debugPrint('getProductById error: $e');
      return null;
    }
  }

  // ── Notifications ──────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      debugPrint('getNotifications error: $e');
      return [];
    }
  }

  Future<int> getUnreadNotificationCount() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications/unread-count'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['count'] ?? 0;
      }
      return 0;
    } catch (e) {
      debugPrint('getUnreadNotificationCount error: $e');
      return 0;
    }
  }

  Future<void> markNotificationRead(String id) async {
    try {
      await http.put(
        Uri.parse('$baseUrl/notifications/$id/read'),
        headers: _headers,
      );
    } catch (e) {
      debugPrint('markNotificationRead error: $e');
    }
  }

  Future<void> markAllNotificationsRead() async {
    try {
      await http.put(
        Uri.parse('$baseUrl/notifications/read-all'),
        headers: _headers,
      );
    } catch (e) {
      debugPrint('markAllNotificationsRead error: $e');
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await http.delete(
        Uri.parse('$baseUrl/notifications/$id'),
        headers: _headers,
      );
    } catch (e) {
      debugPrint('deleteNotification error: $e');
    }
  }

  Future<Map<String, dynamic>> getNotificationSettings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications/settings'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {};
    } catch (e) {
      debugPrint('getNotificationSettings error: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>?> updateNotificationSettings(Map<String, dynamic> settings) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/notifications/settings'),
        headers: _headers,
        body: json.encode(settings),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('updateNotificationSettings error: $e');
      return null;
    }
  }

  // ── Payment Methods ────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/payment-methods'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      debugPrint('getPaymentMethods error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> addPaymentMethod(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payment-methods'),
        headers: _headers,
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('addPaymentMethod error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updatePaymentMethod(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/payment-methods/$id'),
        headers: _headers,
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('updatePaymentMethod error: $e');
      return null;
    }
  }

  Future<bool> deletePaymentMethod(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/payment-methods/$id'),
        headers: _headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('deletePaymentMethod error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> setDefaultPaymentMethod(String id) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/payment-methods/$id/default'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('setDefaultPaymentMethod error: $e');
      return null;
    }
  }

  // ── FCM Token Registration ─────────────────────────────────

  Future<bool> registerFcmToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notifications/register'),
        headers: _headers,
        body: json.encode({'fcmToken': token}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('registerFcmToken error: $e');
      return false;
    }
  }

  Future<bool> removeFcmToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notifications/unregister'),
        headers: _headers,
        body: json.encode({'fcmToken': token}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('removeFcmToken error: $e');
      return false;
    }
  }
}
