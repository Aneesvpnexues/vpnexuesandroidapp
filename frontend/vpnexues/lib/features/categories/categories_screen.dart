import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/features/cart/providers/cart_provider.dart';
import 'package:vpnexues_pvt/shared/utils/responsive.dart';
import 'package:vpnexues_pvt/shared/widgets/search_bar_widget.dart';
import 'package:vpnexues_pvt/features/settings/settings_screen.dart';
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor(context),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _CategoriesBackgroundPainter(),
                size: size,
              ),
            ),
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(context)),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                const SliverToBoxAdapter(child: SearchBarWidget()),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                const SliverToBoxAdapter(child: _IntroText()),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(child: _CategoryGrid()),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => widget.onBackHome?.call(),
            child: Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textColor(context)),
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
            child: _buildIconCircle(context, Icons.notifications_none_outlined),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
            child: _buildIconCircle(context, Icons.settings_outlined),
          ),
        ],
      ),
    );
  }

  static Widget _buildIconCircle(BuildContext context, IconData icon) {
    return Container(
      width: 40,
      height: 40,
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
                onTap: () => widget.onNavigateToCart?.call(),
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
      padding: EdgeInsets.symmetric(horizontal: 20),
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
          SizedBox(height: 4),
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
  @override
  Widget build(BuildContext context) {
    final fullHeight = Responsive.isSmallPhone(context) ? 190.0 : 210.0;
    final halfHeight = Responsive.isSmallPhone(context) ? 155.0 : 170.0;

    return Column(
      children: [
        // Row 1: Vegetables - EDGE-TO-EDGE
        _CategoryCard(
          title: 'Vegetables',
          description: 'Farm fresh vegetables,\nhandpicked for you.',
          icon: Icons.eco,
          imageUrl:
              'https://res.cloudinary.com/z4a2u6bz/image/upload/v1787574596/WhatsApp_Image_2026-08-24_at_5.53.30_PM.jpg',
          height: fullHeight,
          isFullWidth: true,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const CategoryProductsScreen(
                      categoryName: 'vegetables', title: 'Fresh Vegetables')),
            );
          },
        ),
        const SizedBox(height: 14),
        // Row 2: Fruits + Beverages - WITH PADDING
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: _CategoryCard(
                  title: 'Fruits',
                  description: 'Juicy, full of\nnatural goodness.',
                  icon: Icons.apple,
                  imageUrl:
                      'https://res.cloudinary.com/z4a2u6bz/image/upload/f_auto,q_auto/WhatsApp_Image_2026-08-24_at_5.53.29_PM',
                  height: halfHeight,
                  isFullWidth: false,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const CategoryProductsScreen(
                              categoryName: 'fruits', title: 'Fresh Fruits')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _CategoryCard(
                  title: 'Beverages',
                  description: 'Refreshing drinks,\nfor every moment.',
                  icon: Icons.local_drink,
                  imageUrl:
                      'https://res.cloudinary.com/uni7fqrr/image/upload/c_fill,w_400,h_500,g_auto/v1785408151/vp-nexues/Cold-Pressed-Juice-Mix.png',
                  height: halfHeight,
                  isFullWidth: false,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const CategoryProductsScreen(
                              categoryName: 'beverages', title: 'Fresh Beverages')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // Row 3: Groceries - EDGE-TO-EDGE
        _CategoryCard(
          title: 'Groceries',
          description: 'Daily essentials\nfor your home.',
          icon: Icons.shopping_basket,
          imageUrl:
              'https://res.cloudinary.com/z4a2u6bz/image/upload/v1787574552/WhatsApp_Image_2026-08-24_at_5.53.30_PM_1.jpg',
          height: fullHeight,
          isFullWidth: true,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const CategoryProductsScreen(
                      categoryName: 'groceries', title: 'Fresh Groceries')),
            );
          },
        ),
        const SizedBox(height: 14),
        // Row 4: Scratch & Win - WITH PADDING
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: _ScratchWinCard(),
        ),
      ],
    );
  }
}

class _ScratchWinCard extends StatelessWidget {
  const _ScratchWinCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE082), width: 1),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 130, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB74D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.card_giftcard, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Scratch & Win',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF3E2723)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'A little surprise awaits you!',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF5D4037)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                const Text(
                  'Scratch the card and\nreveal your reward.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF8D6E63), height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 130,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
              child: Image.network(
                'https://cdn-icons-png.flaticon.com/512/4140/4140037.png',
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Center(child: Icon(Icons.redeem, color: Color(0xFFFFB74D), size: 50)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.imageUrl,
    required this.onTap,
    this.height = 170,
    this.isFullWidth = false,
  });

  final String title;
  final String description;
  final IconData icon;
  final String imageUrl;
  final VoidCallback onTap;
  final double height;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final imageWidth = isFullWidth ? (Responsive.isSmallPhone(context) ? 150.0 : 170.0) : 85.0;
    final textRightPadding = imageWidth + 10;
    final leftPadding = isFullWidth ? 20.0 : 14.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(isFullWidth ? 0 : 16),
          border: Border.all(color: AppColors.borderColor(context), width: 1),
          boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isFullWidth ? 0 : 16),
          child: Stack(
            children: [
              // Image on right - may slightly overflow but clipped by parent
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: imageWidth,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4, top: 8, bottom: 8),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerRight,
                    errorBuilder: (_, _, _) => const Center(
                      child: Icon(Icons.image, color: AppColors.textLightGray, size: 32),
                    ),
                  ),
                ),
              ),
              // Text content
              Padding(
                padding: EdgeInsets.fromLTRB(leftPadding, 14, textRightPadding, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: AppColors.primary, size: isFullWidth ? 20 : 18),
                    SizedBox(height: isFullWidth ? 8 : 6),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isFullWidth ? 22 : 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isFullWidth ? 14 : 13,
                          color: AppColors.textLightGray,
                          height: 1.3,
                        ),
                      ),
                    ),
                    Container(
                      width: isFullWidth ? 30 : 26,
                      height: isFullWidth ? 30 : 26,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: Icon(Icons.arrow_forward, color: Colors.white, size: isFullWidth ? 15 : 13),
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
}

class _CategoriesBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final bgGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFFF8F8F8),
        const Color(0xFFEDF2E6),
        const Color(0xFFE2EBD5),
      ],
      stops: const [0.0, 0.6, 1.0],
    );

    canvas.drawRect(bgRect, Paint()..shader = bgGradient.createShader(bgRect));

    final hillStartY = size.height * 0.68;

    final hillPath1 = Path()
      ..moveTo(0, hillStartY + 40)
      ..quadraticBezierTo(size.width * 0.15, hillStartY - 20, size.width * 0.35, hillStartY + 20)
      ..quadraticBezierTo(size.width * 0.55, hillStartY + 60, size.width * 0.75, hillStartY)
      ..quadraticBezierTo(size.width * 0.9, hillStartY - 30, size.width, hillStartY + 10)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    paint.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF2E7D4F), Color(0xFF1B5E3A)],
    ).createShader(Rect.fromLTWH(0, hillStartY - 30, size.width, size.height - hillStartY + 30));
    canvas.drawPath(hillPath1, paint);

    final hillPath2 = Path()
      ..moveTo(0, hillStartY + 70)
      ..quadraticBezierTo(size.width * 0.2, hillStartY + 30, size.width * 0.4, hillStartY + 60)
      ..quadraticBezierTo(size.width * 0.6, hillStartY + 90, size.width * 0.85, hillStartY + 40)
      ..quadraticBezierTo(size.width * 0.95, hillStartY + 20, size.width, hillStartY + 50)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    paint.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF3A8C5C), Color(0xFF256B43)],
    ).createShader(Rect.fromLTWH(0, hillStartY + 20, size.width, size.height - hillStartY - 20));
    canvas.drawPath(hillPath2, paint);

    final hillPath3 = Path()
      ..moveTo(0, hillStartY + 100)
      ..quadraticBezierTo(size.width * 0.25, hillStartY + 70, size.width * 0.5, hillStartY + 90)
      ..quadraticBezierTo(size.width * 0.75, hillStartY + 110, size.width, hillStartY + 80)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    paint.shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1B5E3A), Color(0xFF0D4225)],
    ).createShader(Rect.fromLTWH(0, hillStartY + 60, size.width, size.height - hillStartY - 60));
    canvas.drawPath(hillPath3, paint);

    _drawTree(canvas, size.width * 0.1, hillStartY + 20, 0.6);
    _drawTree(canvas, size.width * 0.88, hillStartY - 5, 0.8);
    _drawTree(canvas, size.width * 0.65, hillStartY + 35, 0.5);
    _drawTree(canvas, size.width * 0.03, hillStartY + 60, 0.45);
    _drawTree(canvas, size.width * 0.95, hillStartY + 55, 0.5);
    _drawTree(canvas, size.width * 0.42, hillStartY + 15, 0.55);

    final sunCenter = Offset(size.width * 0.5, hillStartY + 20);
    final sunPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFF8E1).withValues(alpha: 0.6),
          const Color(0xFFFFF3C4).withValues(alpha: 0.2),
          const Color(0xFFFFF8E1).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: 100));
    canvas.drawCircle(sunCenter, 100, sunPaint);
  }

  void _drawTree(Canvas canvas, double x, double y, double scale) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = const Color(0xFF154D2C);
    canvas.drawRect(Rect.fromLTWH(x - 2 * scale, y, 4 * scale, 14 * scale), paint);

    final treePath = Path()
      ..moveTo(x, y - 22 * scale)
      ..lineTo(x - 10 * scale, y + 3 * scale)
      ..lineTo(x + 10 * scale, y + 3 * scale)
      ..close();
    paint.color = const Color(0xFF2E7D4F);
    canvas.drawPath(treePath, paint);

    final treePath2 = Path()
      ..moveTo(x, y - 16 * scale)
      ..lineTo(x - 8 * scale, y + 1 * scale)
      ..lineTo(x + 8 * scale, y + 1 * scale)
      ..close();
    paint.color = const Color(0xFF3A9D5E);
    canvas.drawPath(treePath2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
