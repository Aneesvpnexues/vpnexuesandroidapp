import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vpnexues_pvt/features/cart/providers/cart_provider.dart';
import 'package:vpnexues_pvt/core/models/product.dart';

void main() {
  testWidgets('CartProvider state change triggers rebuild', (WidgetTester tester) async {
    final cart = CartProvider();
    int notifyCount = 0;

    cart.addListener(() => notifyCount++);

    await tester.pumpWidget(
      MaterialApp(
        home: ListenableBuilder(
          listenable: cart,
          builder: (context, _) {
            return Scaffold(
              body: Text('Items: ${cart.itemCount}'),
            );
          },
        ),
      ),
    );

    expect(find.text('Items: 0'), findsOneWidget);

    cart.addItem(const Product(
      id: 'p1',
      name: 'Tomato',
      subtitle: '',
      category: 'vegetables',
      imageUrl: '',
      currentPrice: 40,
      originalPrice: 50,
      discount: '',
      weight: '1 kg',
    ));

    await tester.pump();

    expect(find.text('Items: 1'), findsOneWidget);
    expect(notifyCount, greaterThan(0));
  });
}
