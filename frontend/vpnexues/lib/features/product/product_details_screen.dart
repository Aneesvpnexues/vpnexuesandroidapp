import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/models/product.dart';
import 'package:vpnexues_pvt/features/cart/providers/cart_provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/shared/utils/responsive.dart';
import 'package:vpnexues_pvt/shared/widgets/product_image.dart';
import 'package:vpnexues_pvt/shared/localization/language_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String _selectedWeight = '1.0 kg';
  int _quantity = 1;
  bool _isFavorite = false;

  static const List<String> _weightOptions = [
    '0.5 kg',
    '1.0 kg',
    '2.0 kg',
    '5.0 kg',
  ];

  String get _displayPrice {
    final base = widget.product.currentPrice;
    final multiplier = _quantity.toDouble();
    return (base * multiplier).toInt().toString();
  }

  String get _unitLabel {
    if (_quantity == 1) return 'per $_selectedWeight';
    return '$_quantity × $_selectedWeight';
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, cart),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductInfo(context),
                    const SizedBox(height: 8),
                    _buildProductImage(),
                    const SizedBox(height: 20),
                    _buildWeightCard(),
                    const SizedBox(height: 16),
                    _buildPriceCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildAddToCartBar(cart),
            _buildBottomNav(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CartProvider cart) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: _buildIconBox(context, Icons.arrow_back_ios_new),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.of(context).maybePop();
            },
            child: _buildCartIcon(context, cart),
          ),
        ],
      ),
    );
  }

  Widget _buildIconBox(BuildContext context, IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.textColor(context), size: 20),
    );
  }

  Widget _buildCartIcon(BuildContext context, CartProvider cart) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Icon(Icons.shopping_cart_outlined, color: AppColors.textColor(context), size: 22),
          ),
          if (cart.totalQuantity > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.saleRed,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${cart.totalQuantity}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _getDescription(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLightGray,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Row(
          children: [
            _buildActionButton(context,
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              onTap: () => setState(() => _isFavorite = !_isFavorite),
              color: _isFavorite ? AppColors.saleRed : AppColors.textColor(context),
            ),
            const SizedBox(width: 8),
            _buildActionButton(context, Icons.share_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, {VoidCallback? onTap, Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderGray, width: 1),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color ?? AppColors.textColor(context), size: 20),
      ),
    );
  }

  Widget _buildProductImage() {
    final imageHeight = Responsive.isSmallPhone(context) ? 200.0 : (Responsive.isTablet(context) ? 320.0 : 250.0);

    return Center(
      child: Container(
        height: imageHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.lightGreen.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: ProductImage(
            imageUrl: widget.product.imageUrl,
            fit: BoxFit.contain,
            errorWidget: Center(
              child: Icon(Icons.image,                 color: AppColors.textLightGray, size: 60),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeightCard() {
    final lang = context.watch<LanguageProvider>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
                lang.t('product_weight'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
          const SizedBox(height: 16),
          _buildWeightStepper(),
          const SizedBox(height: 16),
          _buildWeightChips(),
        ],
      ),
    );
  }

  Widget _buildWeightStepper() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderGray, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_quantity > 1) {
                setState(() => _quantity--);
              }
            },
            child: Container(
              width: 52,
              height: double.infinity,
              decoration: BoxDecoration(
                color: _quantity > 1 ? AppColors.primary : AppColors.borderGray,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  bottomLeft: Radius.circular(11),
                ),
              ),
              child: const Icon(Icons.remove, color: Colors.white, size: 20),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                _selectedWeight,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor(context),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_quantity < 10) {
                setState(() => _quantity++);
              }
            },
            child: Container(
              width: 52,
              height: double.infinity,
              decoration: BoxDecoration(
                color: _quantity < 10 ? AppColors.primary : AppColors.borderGray,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                ),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightChips() {
    final w = Responsive.screenWidth(context);
    
    // Use Wrap on very narrow screens to prevent overflow
    if (w < 360) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _weightOptions.map((weight) {
          final isSelected = weight == _selectedWeight;
          return GestureDetector(
            onTap: () => setState(() => _selectedWeight = weight),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.cardColor(context),
                borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.borderGray,
                width: 1.2,
              ),
              ),
              child: Text(
                weight,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textLightGray,
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _weightOptions.map((weight) {
        final isSelected = weight == _selectedWeight;
        return GestureDetector(
          onTap: () => setState(() => _selectedWeight = weight),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.cardColor(context),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.borderGray,
                width: 1.2,
              ),
            ),
            child: Text(
              weight,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textLightGray,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceCard() {
    final lang = context.watch<LanguageProvider>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.t('product_price'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹$_displayPrice',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                  Text(
                    _unitLabel,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textLightGray,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.eco, color: AppColors.primary, size: 14),
                    SizedBox(width: 4),
                    Text(
                      lang.t('product_in_stock'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                lang.t('product_fresh_quality'),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textLightGray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartBar(CartProvider cart) {
    final lang = context.watch<LanguageProvider>();
    final inCartQty = cart.getQuantity(widget.product.id);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: inCartQty == 0
          ? GestureDetector(
              onTap: () {
                for (var i = 0; i < _quantity; i++) {
                  cart.addItem(widget.product);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.product.name} ${lang.t('product_added_cart')}'),
                    backgroundColor: AppColors.primary,
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              child: Container(
                height: 52,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      lang.t('product_add_to_cart'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        cart.decrementItem(widget.product.id);
                      },
                      child: Container(
                        height: 52,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(14),
                            bottomLeft: Radius.circular(14),
                          ),
                        ),
                        child: const Icon(Icons.remove, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 52,
                    alignment: Alignment.center,
                    child: Text(
                      '$inCartQty',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        cart.addItem(widget.product);
                      },
                      child: Container(
                        height: 52,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(14),
                            bottomRight: Radius.circular(14),
                          ),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final barHeight = Responsive.isSmallPhone(context) ? 58.0 : 65.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: barHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home, lang.t('nav_home'), false, () {
                Navigator.of(context).maybePop();
              }),
              _buildNavItem(Icons.grid_view_outlined, Icons.grid_view, lang.t('nav_categories'), true, () {
                Navigator.of(context).maybePop();
              }),
              _buildCartNavItem(context),
              _buildNavItem(Icons.receipt_long_outlined, Icons.receipt_long, lang.t('nav_orders'), false, () {
                Navigator.of(context).maybePop();
              }),
              _buildNavItem(Icons.person_outline, Icons.person, lang.t('nav_profile'), false, () {
                Navigator.of(context).maybePop();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    IconData activeIcon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.navActive : AppColors.navInactive,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.navActive : AppColors.navInactive,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartNavItem(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return GestureDetector(
      onTap: () {
        Navigator.of(context).maybePop();
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Center(
              child: Icon(Icons.shopping_cart, color: Colors.white, size: 26),
            ),
            if (cart.totalQuantity > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.saleRed,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${cart.totalQuantity}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getDescription() {
    switch (widget.product.category) {
      case 'fruits':
        return 'Fresh, juicy and crisp ${widget.product.name.toLowerCase()} perfect for healthy living.';
      case 'vegetables':
        return 'Farm fresh ${widget.product.name.toLowerCase()} handpicked for your daily meals.';
      case 'beverages':
        return 'Refreshing ${widget.product.name.toLowerCase()} made with natural ingredients.';
      case 'groceries':
        return 'Premium quality ${widget.product.name.toLowerCase()} for your kitchen essentials.';
      default:
        return 'Fresh, organic ${widget.product.name.toLowerCase()} handpicked for you.';
    }
  }
}
