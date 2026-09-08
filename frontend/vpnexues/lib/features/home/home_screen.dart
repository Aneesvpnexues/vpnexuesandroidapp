import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/data/sample_data.dart';
import 'package:vpnexues_pvt/core/models/product.dart';
import 'package:vpnexues_pvt/features/cart/providers/cart_provider.dart';
import 'package:vpnexues_pvt/core/services/api_service.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/shared/utils/responsive.dart';
import 'package:vpnexues_pvt/shared/localization/language_provider.dart';
import 'package:vpnexues_pvt/features/home/widgets/home_header.dart';
import 'package:vpnexues_pvt/shared/widgets/search_bar_widget.dart';
import 'package:vpnexues_pvt/features/home/widgets/farm_fresh_banner.dart';
import 'package:vpnexues_pvt/features/home/widgets/trust_section.dart';
import 'package:vpnexues_pvt/features/product/widgets/product_card.dart';
import 'package:vpnexues_pvt/features/home/widgets/popular_section.dart';
import 'package:vpnexues_pvt/features/home/widgets/flash_sale_section.dart';
import 'package:vpnexues_pvt/features/home/widgets/best_offers_section.dart';
import 'all_products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onNavigateToCart});

  final VoidCallback? onNavigateToCart;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  List<Product> _allProducts = sampleProducts;
  List<Product> _popularProducts =
      sampleProducts.where((p) => p.category == 'groceries').toList();
  List<Product> _flashSaleProducts = [];

  String? _selectedCategory;
  String _sortBy = 'name';

  @override
  void initState() {
    super.initState();
    _flashSaleProducts = sampleProducts.take(8).toList();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final all = await _apiService.getProducts();
      final popular = await _apiService.getPopularProducts();
      if (mounted && all.isNotEmpty) {
        final sorted = List<Product>.from(all)..sort((a, b) {
            final da = int.tryParse(RegExp(r'(\d+)').firstMatch(a.discount)?.group(1) ?? '0') ?? 0;
            final db = int.tryParse(RegExp(r'(\d+)').firstMatch(b.discount)?.group(1) ?? '0') ?? 0;
            return db.compareTo(da);
          });
        setState(() {
          _allProducts = sorted;
          _popularProducts = popular.isNotEmpty
              ? popular
              : sorted.where((p) => p.category == 'groceries').toList();
          _flashSaleProducts = sorted.where((p) => p.isSale).toList();
          if (_flashSaleProducts.isEmpty) {
            _flashSaleProducts = sorted.take(8).toList();
          }
        });
      }
    } catch (_) {}
  }

  List<Product> get _filteredProducts {
    List<Product> results = List.from(_allProducts);

    if (_selectedCategory != null) {
      results = results.where((p) => p.category == _selectedCategory).toList();
    }

    switch (_sortBy) {
      case 'price_low':
        results.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
        break;
      case 'price_high':
        results.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
        break;
      case 'discount':
        results.sort((a, b) {
          final da = int.tryParse(RegExp(r'(\d+)').firstMatch(a.discount)?.group(1) ?? '0') ?? 0;
          final db = int.tryParse(RegExp(r'(\d+)').firstMatch(b.discount)?.group(1) ?? '0') ?? 0;
          return db.compareTo(da);
        });
        break;
      case 'name':
      default:
        results.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return results;
  }

  void _showFilterSheet() {
    final lang = context.watch<LanguageProvider>();
    final categories = _allProducts.map((p) => p.category).toSet().toList();
    String tempSort = _sortBy;
    String? tempCategory = _selectedCategory;

    final sortOptions = [
      {'label': lang.t('sort_az'), 'value': 'name', 'icon': Icons.sort_by_alpha},
      {'label': lang.t('home_price_low'), 'value': 'price_low', 'icon': Icons.trending_down},
      {'label': lang.t('home_price_high'), 'value': 'price_high', 'icon': Icons.trending_up},
    ];

    final categoryIcons = {
      'vegetables': '🥬',
      'fruits': '🍎',
      'beverages': '🥤',
      'groceries': '🛒',
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          height: MediaQuery.of(ctx).size.height * 0.55,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      lang.t('home_filter_sort'),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, size: 18, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    lang.t('home_sort_by'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: sortOptions.map((opt) {
                    final isActive = tempSort == opt['value'];
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setSheetState(() => tempSort = opt['value'] as String),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.primary : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isActive ? AppColors.primary : Colors.grey[200]!,
                              width: isActive ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                opt['icon'] as IconData,
                                size: 20,
                                color: isActive ? Colors.white : Colors.grey[500],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                opt['label'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isActive ? Colors.white : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    lang.t('home_category'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildCategoryChip(ctx, lang.t('home_all'), null, null, tempCategory, setSheetState, (v) {
                      setSheetState(() => tempCategory = v);
                    }),
                    for (final cat in categories)
                      _buildCategoryChip(
                        ctx,
                        cat[0].toUpperCase() + cat.substring(1),
                        cat,
                        categoryIcons[cat],
                        tempCategory,
                        setSheetState,
                        (v) => setSheetState(() => tempCategory = v),
                      ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setSheetState(() {
                            tempSort = 'name';
                            tempCategory = null;
                          });
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              lang.t('home_clear_all'),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _sortBy = tempSort;
                            _selectedCategory = tempCategory;
                          });
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0E5A35), Color(0xFF1B7A4A)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              lang.t('home_apply'),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext ctx,
    String label,
    String? value,
    String? emoji,
    String? currentValue,
    StateSetter setSheetState,
    ValueChanged<String?> onTap,
  ) {
    final isActive = currentValue == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.grey[50],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.grey[200]!,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final lang = context.watch<LanguageProvider>();
    final crossCount = Responsive.gridCrossAxisCount(context, smallPhone: 2, normalPhone: 2, largePhone: 2, tablet: 3);
    final aspectRatio = Responsive.productCardAspectRatio(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                const SliverToBoxAdapter(child: HomeHeader()),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(
                  child: SearchBarWidget(onFilterTap: _showFilterSheet),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                const SliverToBoxAdapter(child: FarmFreshBanner()),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                const SliverToBoxAdapter(child: TrustSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: FlashSaleSection(products: _flashSaleProducts),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text(
                        lang.t('home_todays_pick'),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textColor(context),
                        ),
                      ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AllProductsScreen(title: "Today's Best Picks"),
                              ),
                            );
                          },
                          child: Text(
                            lang.t('home_view_all'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossCount,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: aspectRatio,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = _filteredProducts[index];
                        return ProductCard(product: product);
                      },
                      childCount: _filteredProducts.length > 6 ? 6 : _filteredProducts.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                const SliverToBoxAdapter(child: BestOffersSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverToBoxAdapter(
                  child: PopularSection(products: _popularProducts),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
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

  Widget _buildViewCartBar(CartProvider cart) {
    final lang = context.watch<LanguageProvider>();
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
                  '${cart.totalQuantity} ${lang.t('cart_items')}',
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
                onTap: widget.onNavigateToCart,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    lang.t('cart_checkout'),
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
