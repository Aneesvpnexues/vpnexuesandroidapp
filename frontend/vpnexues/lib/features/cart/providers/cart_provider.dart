import 'package:flutter/foundation.dart';
import 'package:vpnexues_pvt/core/models/product.dart';
import 'package:vpnexues_pvt/core/services/api_service.dart';

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  final ApiService _api = ApiService();
  bool _syncing = false;

  Map<String, CartItem> get items => Map.unmodifiable(_items);
  bool get isSyncing => _syncing;

  int get itemCount => _items.length;

  int get totalQuantity =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.values.fold(0, (sum, item) => sum + item.product.currentPrice * item.quantity);

  double get totalSaved => _items.values.fold(
        0,
        (sum, item) =>
            sum + (item.product.originalPrice - item.product.currentPrice) * item.quantity,
      );

  // Load cart from backend
  Future<void> loadCart() async {
    _syncing = true;
    notifyListeners();

    try {
      final cartItems = await _api.getCartItems();
      _items.clear();

      for (final item in cartItems) {
        final productId = item['productId'] as String? ?? '';
        final quantity = item['quantity'] as int? ?? 1;
        final name = item['name'] as String? ?? '';
        final imageUrl = item['imageUrl'] as String? ?? '';
        final currentPrice = (item['currentPrice'] as num?)?.toDouble() ?? 0;
        final weight = item['weight'] as String? ?? '';

        if (productId.isNotEmpty) {
          final product = Product(
            id: productId,
            name: name,
            subtitle: '',
            category: '',
            imageUrl: imageUrl,
            currentPrice: currentPrice,
            originalPrice: currentPrice,
            discount: '',
            weight: weight,
          );
          _items[productId] = CartItem(product: product, quantity: quantity);
        }
      }
    } catch (e) {
      debugPrint('loadCart error: $e');
    }

    _syncing = false;
    notifyListeners();
  }

  // Add item to cart (optimistic update + backend sync)
  void addItem(Product product) {
    final isNew = !_items.containsKey(product.id);
    if (isNew) {
      _items[product.id] = CartItem(product: product);
      notifyListeners();
      _addToBackend(product.id, 1);
    } else {
      final existing = _items[product.id]!;
      _items[product.id] = CartItem(
        product: product,
        quantity: existing.quantity + 1,
      );
      notifyListeners();
      _syncToBackend(product.id, existing.quantity + 1);
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
    _removeFromBackend(productId);
  }

  void decrementItem(String productId) {
    if (!_items.containsKey(productId)) return;
    final existing = _items[productId]!;
    if (existing.quantity <= 1) {
      _items.remove(productId);
      _removeFromBackend(productId);
    } else {
      _items[productId] = CartItem(
        product: existing.product,
        quantity: existing.quantity - 1,
      );
      _syncToBackend(productId, existing.quantity - 1);
    }
    notifyListeners();
  }

  int getQuantity(String productId) {
    return _items[productId]?.quantity ?? 0;
  }

  // Sync quantity to backend
  Future<void> _syncToBackend(String productId, int quantity) async {
    try {
      await _api.updateCartQuantity(productId, quantity);
    } catch (e) {
      debugPrint('Cart sync error: $e');
    }
  }

  // Add to backend (for new items)
  Future<void> _addToBackend(String productId, int quantity) async {
    try {
      await _api.addToCart(productId, quantity);
    } catch (e) {
      debugPrint('Cart add error: $e');
    }
  }

  // Remove from backend
  Future<void> _removeFromBackend(String productId) async {
    try {
      await _api.removeFromCart(productId);
    } catch (e) {
      debugPrint('Cart remove error: $e');
    }
  }

  // Clear cart (after order placed)
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Place order
  Future<bool> placeOrder({
    String paymentMethod = 'cash_on_delivery',
    String? paymentId,
    String? paymentStatus,
  }) async {
    final deliveryFee = 40.0;
    final deliveryDiscount = 40.0;
    final subtotal = totalPrice;
    final totalAmount = subtotal + deliveryFee - deliveryDiscount;

    final orderItems = _items.values.map((item) => {
      'productId': item.product.id,
      'name': item.product.name,
      'imageUrl': item.product.imageUrl,
      'currentPrice': item.product.currentPrice,
      'quantity': item.quantity,
    }).toList();

    try {
      final result = await _api.placeOrder(
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        deliveryDiscount: deliveryDiscount,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        items: orderItems,
        paymentId: paymentId,
        paymentStatus: paymentStatus,
      );
      if (result != null) {
        clear();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('placeOrder error: $e');
      return false;
    }
  }

  // Place order and return full result
  Future<Map<String, dynamic>?> placeOrderWithResult({
    String paymentMethod = 'cash_on_delivery',
    String? paymentId,
    String? paymentStatus,
  }) async {
    final deliveryFee = 40.0;
    final deliveryDiscount = 40.0;
    final subtotal = totalPrice;
    final totalAmount = subtotal + deliveryFee - deliveryDiscount;

    final orderItems = _items.values.map((item) => {
      'productId': item.product.id,
      'name': item.product.name,
      'imageUrl': item.product.imageUrl,
      'currentPrice': item.product.currentPrice,
      'quantity': item.quantity,
    }).toList();

    try {
      final result = await _api.placeOrder(
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        deliveryDiscount: deliveryDiscount,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        items: orderItems,
        paymentId: paymentId,
        paymentStatus: paymentStatus,
      );
      if (result != null) {
        clear();
        return result;
      }
      return null;
    } catch (e) {
      debugPrint('placeOrderWithResult error: $e');
      return null;
    }
  }
}
