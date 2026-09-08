import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/data/sample_data.dart';
import 'package:vpnexues_pvt/core/models/product.dart';
import 'package:vpnexues_pvt/features/cart/providers/cart_provider.dart';
import 'package:vpnexues_pvt/core/services/api_service.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/shared/widgets/product_image.dart';
import '../product/product_details_screen.dart';

class AllProductsScreen extends StatefulWidget {
  final String? title;
  final String? initialCategory;

  const AllProductsScreen({super.key, this.title, this.initialCategory});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  Timer? _debounce;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _sortBy = 'name';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await _apiService.getProducts();
      if (mounted && products.isNotEmpty) {
        setState(() {
          _allProducts = products;
          _applyFilters();
          _isLoading = false;
        });
        return;
      }
    } catch (_) {}
    if (mounted) {
      setState(() {
        _allProducts = sampleProducts;
        _applyFilters();
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _applyFilters();
    });
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();
    List<Product> results = List.from(_allProducts);

    // Search filter
    if (query.isNotEmpty) {
      results = results
          .where((p) =>
              p.name.toLowerCase().contains(query) ||
              p.category.toLowerCase().contains(query))
          .toList();
    }

    // Category filter
    if (_selectedCategory != null) {
      results = results.where((p) => p.category == _selectedCategory).toList();
    }

    // Sort
    switch (_sortBy) {
      case 'price_low':
        results.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
        break;
      case 'price_high':
        results.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
        break;
      case 'name':
      default:
        results.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    setState(() => _filteredProducts = results);
  }

  @override
  Widget build(BuildContext context) {
    final categories = _allProducts.map((p) => p.category).toSet().toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildSortFilterBar(categories),
            const SizedBox(height: 8),
            Expanded(child: _buildResults()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.arrow_back_ios_new,
                  size: 18, color: AppColors.textColor(context)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.title ?? 'All Products',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor(context),
              ),
            ),
          ),
          Text(
            '${_filteredProducts.length} items',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor(context)),
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(fontSize: 14, color: AppColors.textColor(context)),
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: TextStyle(color: AppColors.textSecondaryColor(context), fontSize: 14),
            prefixIcon: Icon(Icons.search, color: AppColors.textSecondaryColor(context), size: 20),
            suffixIcon: _searchController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      _applyFilters();
                    },
                    child: Icon(Icons.close, color: AppColors.textSecondaryColor(context), size: 18),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildSortFilterBar(List<String> categories) {
    return Container(
      height: 44,
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildSortChip('A-Z', 'name'),
          const SizedBox(width: 8),
          _buildSortChip('Price ↑', 'price_low'),
          const SizedBox(width: 8),
          _buildSortChip('Price ↓', 'price_high'),
          if (categories.length > 1) ...[
            const SizedBox(width: 12),
            Container(width: 1, color: AppColors.borderColor(context)),
            const SizedBox(width: 12),
            _buildFilterChip('All', null),
            for (final cat in categories) ...[
              const SizedBox(width: 8),
              _buildFilterChip(cat[0].toUpperCase() + cat.substring(1), cat),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isActive = _sortBy == value;
    return GestureDetector(
      onTap: () {
        _sortBy = value;
        _applyFilters();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.borderColor(context),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sort, size: 13,
                color: isActive ? Colors.white : AppColors.textSecondaryColor(context)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value) {
    final isActive = _selectedCategory == value;
    return GestureDetector(
      onTap: () {
        _selectedCategory = value;
        _applyFilters();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.borderColor(context),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.textColor(context),
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (_filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: AppColors.textSecondaryColor(context)),
            const SizedBox(height: 12),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try a different search or filter',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondaryColor(context)),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 90),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return _ProductCard(product: _filteredProducts[index]);
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final quantity = cart.getQuantity(product.id);
    final discount = product.originalPrice > product.currentPrice
        ? (((product.originalPrice - product.currentPrice) / product.originalPrice) * 100).round()
        : 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderColor(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
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
                  if (discount > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.saleRed,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$discount% OFF',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
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
                        if (product.originalPrice > product.currentPrice) ...[
                          const SizedBox(width: 4),
                          Text(
                            '₹${product.originalPrice.toInt()}',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondaryColor(context),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          product.weight,
                          style: TextStyle(fontSize: 9, color: AppColors.textSecondaryColor(context)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    quantity == 0
                        ? GestureDetector(
                            onTap: () => cart.addItem(product),
                            child: Container(
                              height: 28,
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
                          )
                        : Container(
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () => cart.decrementItem(product.id),
                                  child: const Icon(Icons.remove, color: Colors.white, size: 13),
                                ),
                                Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => cart.addItem(product),
                                  child: const Icon(Icons.add, color: Colors.white, size: 13),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
