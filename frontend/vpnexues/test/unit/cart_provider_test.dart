import 'package:flutter_test/flutter_test.dart';
import 'package:vpnexues_pvt/core/models/product.dart';
import 'package:vpnexues_pvt/features/cart/providers/cart_provider.dart';

Product _makeProduct({
  String id = 'p1',
  String name = 'Tomato',
  double price = 40,
  double originalPrice = 50,
}) {
  return Product(
    id: id,
    name: name,
    subtitle: '',
    category: 'vegetables',
    imageUrl: '',
    currentPrice: price,
    originalPrice: originalPrice,
    discount: '',
    weight: '1 kg',
  );
}

void main() {
  group('CartProvider', () {
    late CartProvider cart;

    setUp(() {
      cart = CartProvider();
    });

    group('addItem', () {
      test('adds new item to cart', () {
        final product = _makeProduct();
        cart.addItem(product);

        expect(cart.itemCount, 1);
        expect(cart.totalQuantity, 1);
        expect(cart.getQuantity('p1'), 1);
      });

      test('increments quantity when adding same product', () {
        final product = _makeProduct();
        cart.addItem(product);
        cart.addItem(product);

        expect(cart.itemCount, 1);
        expect(cart.totalQuantity, 2);
        expect(cart.getQuantity('p1'), 2);
      });

      test('adds different products separately', () {
        final p1 = _makeProduct(id: 'p1', name: 'Tomato');
        final p2 = _makeProduct(id: 'p2', name: 'Onion');
        cart.addItem(p1);
        cart.addItem(p2);

        expect(cart.itemCount, 2);
        expect(cart.totalQuantity, 2);
      });

      test('notifies listeners on add', () {
        var notified = false;
        cart.addListener(() => notified = true);

        cart.addItem(_makeProduct());
        expect(notified, true);
      });
    });

    group('removeItem', () {
      test('removes item from cart', () {
        cart.addItem(_makeProduct(id: 'p1'));
        cart.addItem(_makeProduct(id: 'p2'));
        cart.removeItem('p1');

        expect(cart.itemCount, 1);
        expect(cart.getQuantity('p1'), 0);
        expect(cart.getQuantity('p2'), 1);
      });

      test('notifies listeners on remove', () {
        cart.addItem(_makeProduct());
        var notified = false;
        cart.addListener(() => notified = true);

        cart.removeItem('p1');
        expect(notified, true);
      });

      test('does nothing when removing non-existent item', () {
        cart.addItem(_makeProduct(id: 'p1'));
        cart.removeItem('nonexistent');

        expect(cart.itemCount, 1);
      });
    });

    group('decrementItem', () {
      test('decrements quantity when > 1', () {
        cart.addItem(_makeProduct(id: 'p1'));
        cart.addItem(_makeProduct(id: 'p1'));
        expect(cart.getQuantity('p1'), 2);

        cart.decrementItem('p1');
        expect(cart.getQuantity('p1'), 1);
        expect(cart.itemCount, 1);
      });

      test('removes item when quantity is 1', () {
        cart.addItem(_makeProduct(id: 'p1'));
        expect(cart.getQuantity('p1'), 1);

        cart.decrementItem('p1');
        expect(cart.getQuantity('p1'), 0);
        expect(cart.itemCount, 0);
      });

      test('does nothing for non-existent item', () {
        cart.decrementItem('nonexistent');
        expect(cart.itemCount, 0);
      });

      test('notifies listeners on decrement', () {
        cart.addItem(_makeProduct());
        var notified = false;
        cart.addListener(() => notified = true);

        cart.decrementItem('p1');
        expect(notified, true);
      });
    });

    group('totalPrice', () {
      test('returns 0 for empty cart', () {
        expect(cart.totalPrice, 0);
      });

      test('calculates single item total', () {
        cart.addItem(_makeProduct(price: 40));
        expect(cart.totalPrice, 40);
      });

      test('calculates multiple items total', () {
        cart.addItem(_makeProduct(id: 'p1', price: 40));
        cart.addItem(_makeProduct(id: 'p2', price: 60));
        expect(cart.totalPrice, 100);
      });

      test('calculates total with quantities', () {
        cart.addItem(_makeProduct(id: 'p1', price: 40));
        cart.addItem(_makeProduct(id: 'p1', price: 40));
        cart.addItem(_makeProduct(id: 'p1', price: 40));

        expect(cart.totalPrice, 120);
      });
    });

    group('totalSaved', () {
      test('returns 0 when no discount', () {
        cart.addItem(_makeProduct(price: 40, originalPrice: 40));
        expect(cart.totalSaved, 0);
      });

      test('calculates savings correctly', () {
        cart.addItem(_makeProduct(price: 40, originalPrice: 50));
        expect(cart.totalSaved, 10);
      });

      test('calculates savings with quantities', () {
        cart.addItem(_makeProduct(id: 'p1', price: 40, originalPrice: 50));
        cart.addItem(_makeProduct(id: 'p1', price: 40, originalPrice: 50));
        expect(cart.totalSaved, 20);
      });
    });

    group('clear', () {
      test('removes all items', () {
        cart.addItem(_makeProduct(id: 'p1'));
        cart.addItem(_makeProduct(id: 'p2'));
        cart.clear();

        expect(cart.itemCount, 0);
        expect(cart.totalPrice, 0);
      });

      test('notifies listeners on clear', () {
        cart.addItem(_makeProduct());
        var notified = false;
        cart.addListener(() => notified = true);

        cart.clear();
        expect(notified, true);
      });
    });

    group('getQuantity', () {
      test('returns 0 for empty cart', () {
        expect(cart.getQuantity('p1'), 0);
      });

      test('returns correct quantity', () {
        cart.addItem(_makeProduct(id: 'p1'));
        cart.addItem(_makeProduct(id: 'p1'));
        expect(cart.getQuantity('p1'), 2);
      });

      test('returns 0 for non-existent item', () {
        cart.addItem(_makeProduct(id: 'p1'));
        expect(cart.getQuantity('nonexistent'), 0);
      });
    });
  });
}
