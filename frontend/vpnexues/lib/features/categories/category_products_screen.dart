import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/data/sample_data.dart';
import 'package:vpnexues_pvt/core/models/product.dart';
import 'package:vpnexues_pvt/features/cart/providers/cart_provider.dart';
import 'package:vpnexues_pvt/core/services/api_service.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/shared/widgets/product_image.dart';
import 'package:vpnexues_pvt/features/settings/settings_screen.dart';
import 'package:vpnexues_pvt/features/cart/cart_screen.dart';
import '../product/product_details_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
    required this.title,
  });

  final String categoryName;
  final String title;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _sortBy = 'default';
  String? _errorMessage;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadProducts() async {
    if (!mounted) return;
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      final products = await _apiService.getProductsByCategory(widget.categoryName);
      if (mounted && products.isNotEmpty) {
        setState(() {
          _allProducts = products;
          _filteredProducts = List.from(_allProducts);
          _isLoading = false;
        });
        return;
      }
    } catch (e) {
      debugPrint('getProductsByCategory error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load products. Please try again.';
        });
      }
    }
    final fallback = sampleProducts
        .where((p) => p.category == widget.categoryName)
        .toList();
    if (mounted) {
      setState(() {
        _allProducts = fallback;
        _filteredProducts = List.from(_allProducts);
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text.toLowerCase().trim();
      setState(() {
        if (query.isEmpty) {
          _filteredProducts = List.from(_allProducts);
        } else {
          _filteredProducts = _allProducts
              .where((p) => p.name.toLowerCase().contains(query))
              .toList();
        }
        _applySort();
      });
    });
  }

  void _applySort() {
    switch (_sortBy) {
      case 'price_low':
        _filteredProducts.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
        break;
      case 'price_high':
        _filteredProducts.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
        break;
      case 'name_az':
        _filteredProducts.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'name_za':
        _filteredProducts.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'popularity':
        _filteredProducts.sort((a, b) => (b.isSale ? 1 : 0).compareTo(a.isSale ? 1 : 0));
        break;
    }
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      barrierColor: Colors.black54,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSortOption(context, setModalState, 'default', 'Default', Icons.sort),
                  _buildSortOption(context, setModalState, 'price_low', 'Price: Low to High', Icons.arrow_upward),
                  _buildSortOption(context, setModalState, 'price_high', 'Price: High to Low', Icons.arrow_downward),
                  _buildSortOption(context, setModalState, 'name_az', 'Name: A to Z', Icons.sort_by_alpha),
                  _buildSortOption(context, setModalState, 'name_za', 'Name: Z to A', Icons.text_fields),
                  _buildSortOption(context, setModalState, 'popularity', 'Popularity', Icons.trending_up),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortOption(BuildContext context, StateSetter setModalState, String value, String label, IconData icon) {
    final isSelected = _sortBy == value;
    return GestureDetector(
      onTap: () {
        setModalState(() => _sortBy = value);
        setState(() => _applySort());
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderColor(context),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.textSecondaryColor(context),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textColor(context),
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor(context),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : _errorMessage != null && _allProducts.isEmpty
                          ? _buildErrorState()
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildBanner(),
                                  const SizedBox(height: 12),
                                  _buildSearchBar(),
                                  const SizedBox(height: 16),
                                  _filteredProducts.isEmpty
                                      ? _buildEmptyState()
                                      : _buildGrid(),
                                  const SizedBox(height: 16),
                                  _buildTrustBar(),
                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
                ),
              ],
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textColor(context)),
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor(context),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            child: Icon(Icons.settings_outlined, size: 22, color: AppColors.textColor(context)),
          ),
        ],
      ),
    );
  }

  String get _bannerImage {
    final title = widget.title.toLowerCase();
    if (title.contains('fruit')) return 'assets/images/banner_fruits.jpg';
    if (title.contains('beverage')) return 'assets/images/banner_beverages.jpg';
    if (title.contains('grocer')) return 'assets/images/banner_groceries.jpg';
    return 'assets/images/category_banner.jpg';
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 110,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Image.asset(
        _bannerImage,
        width: double.infinity,
        height: 110,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          color: const Color(0xFF2E7D32),
          child: const Center(
            child: Icon(Icons.image, color: Colors.white54, size: 40),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.cardColor(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderColor(context), width: 1),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(Icons.search, color: AppColors.textLightGray, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: AppColors.textColor(context), fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search ${widget.title[0].toUpperCase()}${widget.title.substring(1).toLowerCase()}...',
                        hintStyle: TextStyle(color: AppColors.textLightGray, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () => _searchController.clear(),
                      child: Icon(Icons.close, color: AppColors.textLightGray, size: 20),
                    ),
                  const SizedBox(width: 14),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _showSortBottomSheet,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.cardColor(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderColor(context), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sort',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textColor(context)),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.sort, size: 18, color: AppColors.textColor(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          return _ProductCard(product: _filteredProducts[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 60, color: AppColors.textLightGray),
            const SizedBox(height: 12),
            Text(
              'No ${widget.title.toLowerCase()} found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textColor(context)),
            ),
            const SizedBox(height: 4),
            Text(
              'Try a different search term',
              style: TextStyle(fontSize: 13, color: AppColors.textLightGray),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 60, color: AppColors.saleRed),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? 'Something went wrong',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textColor(context)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Check your connection and try again',
              style: TextStyle(fontSize: 13, color: AppColors.textLightGray),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _loadProducts,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.cardColor(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderColor(context), width: 1),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TrustItem(icon: Icons.eco, label: '100% Fresh', sublabel: 'Premium quality'),
          _TrustItem(icon: Icons.verified, label: 'Best Quality', sublabel: 'Carefully checked'),
          _TrustItem(icon: Icons.local_shipping_outlined, label: 'Fast Delivery', sublabel: 'On time, every time'),
        ],
      ),
    );
  }

  Widget _buildViewCartBar(CartProvider cart) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            width: 42,
            height: 42,
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
                Text(
                  '🎉 Yay! You saved ₹${cart.totalSaved.toInt()}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${cart.totalPrice.toInt()}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF2B233),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'View Cart >',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({required this.icon, required this.label, required this.sublabel});
  final IconData icon;
  final String label;
  final String sublabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textColor(context)),
        ),
        const SizedBox(height: 1),
        Text(
          sublabel,
          style: TextStyle(fontSize: 9, color: AppColors.textLightGray),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final quantity = cart.getQuantity(product.id);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
        );
      },
      child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardColor(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderColor(context), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                      child: ProductImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: Container(
                          color: AppColors.lightGreen,
                          child: const Center(
                            child: Icon(Icons.image, color: AppColors.textLightGray, size: 40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (product.isOrganic)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.organicGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.eco, color: Colors.white, size: 10),
                            SizedBox(width: 3),
                            Text(
                              'ORGANIC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.subtitle,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondaryColor(context),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        '₹${product.currentPrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '₹${product.originalPrice.toInt()}',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondaryColor(context),
                            decoration: TextDecoration.lineThrough,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        product.weight,
                        style: TextStyle(fontSize: 9, color: AppColors.textSecondaryColor(context)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  quantity == 0
                      ? _buildAddToCartButton(cart)
                      : _buildQuantityStepper(context, cart, quantity),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(CartProvider cart) {
    return GestureDetector(
      onTap: () => cart.addItem(product),
      child: Container(
        width: double.infinity,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 12),
              SizedBox(width: 4),
              Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityStepper(BuildContext context, CartProvider cart, int quantity) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => cart.decrementItem(product.id),
            child: Container(
              width: 32,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: const Icon(Icons.remove, color: Colors.white, size: 14),
            ),
          ),
          Expanded(
              child: Center(
                child: Text(
                  '$quantity',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor(context),
                  ),
                ),
              ),
          ),
          GestureDetector(
            onTap: () => cart.addItem(product),
            child: Container(
              width: 32,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}
