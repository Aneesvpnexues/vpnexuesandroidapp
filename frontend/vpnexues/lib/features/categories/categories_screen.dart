import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/core/data/sample_data.dart';
import 'package:vpnexues_pvt/core/models/category.dart';
import 'package:vpnexues_pvt/features/cart/providers/cart_provider.dart';
import 'package:vpnexues_pvt/shared/utils/responsive.dart';
import 'package:vpnexues_pvt/shared/widgets/search_bar_widget.dart';
import 'package:vpnexues_pvt/features/settings/settings_screen.dart';
import 'package:vpnexues_pvt/features/cart/cart_screen.dart';
import 'category_products_screen.dart';

class CategoriesScreen extends StatefulWidget {
  final VoidCallback? onNavigateToCart;
  final VoidCallback? onBackHome;

  const CategoriesScreen({super.key, this.onNavigateToCart, this.onBackHome});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.categoriesBgColor(context),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 8),
                  const SearchBarWidget(showFilter: false),
                  const SizedBox(height: 16),
                  const _IntroText(),
                  const SizedBox(height: 20),
                  _CategoryGrid(categories: sampleCategories),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            if (cart.totalQuantity > 0)
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: _buildViewCartBar(cart),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => widget.onBackHome?.call(),
            child: Icon(Icons.arrow_back_ios_new, size: 22, color: AppColors.textColor(context)),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textColor(context)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Icon(Icons.notifications_none_outlined, color: AppColors.textColor(context), size: 24),
          ),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
            child: Icon(Icons.settings_outlined, color: AppColors.textColor(context), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildViewCartBar(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.shopping_cart, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${cart.totalQuantity} Items Selected',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white70, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      'Yay! You saved ₹${cart.totalSaved.toInt()}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '₹${cart.totalPrice.toInt()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: () {
                  if (widget.onNavigateToCart != null) {
                    widget.onNavigateToCart!.call();
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'View Cart >',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IntroText extends StatelessWidget {
  const _IntroText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What are you looking for today?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose a category to explore fresh & quality products',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLightGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final List<AppCategory> categories;
  const _CategoryGrid({required this.categories});

  @override
  Widget build(BuildContext context) {
    final fullHeight = Responsive.isSmallPhone(context) ? 190.0 : 210.0;
    final halfHeight = Responsive.isSmallPhone(context) ? 155.0 : 170.0;

    final displayCategories = categories.where((c) => c.id != 'all').toList();

    final categoryAssetMap = <String, String>{
      'vegetables': 'assets/images/categories/vegetables.jpg',
      'fruits': 'assets/images/categories/fruits.jpg',
      'beverages': 'assets/images/categories/beverages.jpg',
      'groceries': 'assets/images/categories/groceries.jpg',
    };

    final categoryTitleMap = <String, String>{
      'vegetables': 'Fresh Vegetables',
      'fruits': 'Fresh Fruits',
      'beverages': 'Fresh Beverages',
      'groceries': 'Fresh Groceries',
    };

    return Column(
      children: [
        if (displayCategories.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _CategoryCard(
              assetPath: categoryAssetMap[displayCategories[0].id] ?? '',
              height: fullHeight,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => CategoryProductsScreen(
                          categoryName: displayCategories[0].id,
                          title: categoryTitleMap[displayCategories[0].id] ?? displayCategories[0].name)),
                );
              },
            ),
          ),
        if (displayCategories.length >= 3) ...[
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: _HalfCategoryCard(
                    assetPath: categoryAssetMap[displayCategories[1].id] ?? '',
                    height: halfHeight,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => CategoryProductsScreen(
                                categoryName: displayCategories[1].id,
                                title: categoryTitleMap[displayCategories[1].id] ?? displayCategories[1].name)),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _HalfCategoryCard(
                    assetPath: categoryAssetMap[displayCategories[2].id] ?? '',
                    height: halfHeight,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => CategoryProductsScreen(
                                categoryName: displayCategories[2].id,
                                title: categoryTitleMap[displayCategories[2].id] ?? displayCategories[2].name)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
        if (displayCategories.length >= 4) ...[
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _CategoryCard(
              assetPath: categoryAssetMap[displayCategories[3].id] ?? '',
              height: fullHeight,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => CategoryProductsScreen(
                          categoryName: displayCategories[3].id,
                          title: categoryTitleMap[displayCategories[3].id] ?? displayCategories[3].name)),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.assetPath,
    required this.onTap,
    this.height = 170,
  });

  final String assetPath;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
            alignment: Alignment.centerLeft,
            errorBuilder: (_, _, _) => Container(
              color: AppColors.lightGreen,
              child: const Center(
                child: Icon(Icons.image, color: AppColors.textLightGray, size: 32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HalfCategoryCard extends StatelessWidget {
  const _HalfCategoryCard({
    required this.assetPath,
    required this.onTap,
    this.height = 170,
  });

  final String assetPath;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
            alignment: Alignment.centerLeft,
            errorBuilder: (_, _, _) => Container(
              color: AppColors.lightGreen,
              child: const Center(
                child: Icon(Icons.image, color: AppColors.textLightGray, size: 28),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
