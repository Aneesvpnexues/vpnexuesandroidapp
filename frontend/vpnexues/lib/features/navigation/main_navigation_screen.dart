import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/features/cart/providers/cart_provider.dart';
import 'package:vpnexues_pvt/shared/widgets/bottom_nav_bar.dart';
import '../home/home_screen.dart';
import '../categories/categories_screen.dart';
import '../cart/cart_screen.dart';
import '../orders/orders_screen.dart';
import '../profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialTab;
  const MainNavigationScreen({super.key, this.initialTab = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex = widget.initialTab;
  final GlobalKey<OrdersScreenState> _ordersKey = GlobalKey<OrdersScreenState>();

  void _switchToTab(int index) {
    setState(() => _currentIndex = index);
    if (index == 3) {
      _ordersKey.currentState?.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(onNavigateToCart: () => _switchToTab(2)),
          CategoriesScreen(onNavigateToCart: () => _switchToTab(2), onBackHome: () => _switchToTab(0)),
          CartScreen(
            onNavigateToOrders: () => _switchToTab(3),
            onNavigateToHome: () => _switchToTab(0),
            onNavigateBack: () => _switchToTab(1),
          ),
          OrdersScreen(key: _ordersKey, onBackHome: () => _switchToTab(0)),
          ProfileScreen(onNavigateToOrders: () => _switchToTab(3), onNavigateToHome: () => _switchToTab(0)),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        cartCount: cart.totalQuantity,
        onTap: _switchToTab,
      ),
    );
  }
}
