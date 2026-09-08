import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vpnexues_pvt/core/models/product.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/shared/widgets/product_image.dart';
import 'package:vpnexues_pvt/shared/utils/responsive.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/features/cart/providers/cart_provider.dart';
import '../all_products_screen.dart';

class FlashSaleSection extends StatefulWidget {
  const FlashSaleSection({super.key, required this.products});

  final List<Product> products;

  @override
  State<FlashSaleSection> createState() => _FlashSaleSectionState();
}

class _FlashSaleSectionState extends State<FlashSaleSection> {
  late Timer _timer;
  Duration _remaining = const Duration(hours: 12, minutes: 45, seconds: 30);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds > 0) {
        setState(() {
          _remaining = _remaining - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final listHeight = Responsive.isSmallPhone(context) ? 240.0 : (Responsive.isTablet(context) ? 280.0 : 260.0);
    final cardWidth = Responsive.isSmallPhone(context) ? 130.0 : (Responsive.isTablet(context) ? 160.0 : 145.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.flash_on, color: Colors.orange, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    'Flash Sale',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textColor(context),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildTimerBox(_twoDigits(_remaining.inHours)),
                  const SizedBox(width: 4),
                  const Text(':', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 4),
                  _buildTimerBox(_twoDigits(_remaining.inMinutes % 60)),
                  const SizedBox(width: 4),
                  const Text(':', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 4),
                  _buildTimerBox(_twoDigits(_remaining.inSeconds % 60)),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllProductsScreen(title: 'Flash Sale'),
                    ),
                  );
                },
                child: const Text(
                  'View all >',
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
        const SizedBox(height: 14),
        SizedBox(
          height: listHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: widget.products.length > 8 ? 8 : widget.products.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _FlashSaleCard(
                product: widget.products[index],
                cardWidth: cardWidth,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimerBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _FlashSaleCard extends StatelessWidget {
  const _FlashSaleCard({required this.product, required this.cardWidth});

  final Product product;
  final double cardWidth;

  int get _discountPercent {
    final match = RegExp(r'(\d+)').firstMatch(product.discount);
    return match != null ? int.parse(match.group(1)!) : 0;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
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
                        child: Center(
                          child: Icon(Icons.image, color: AppColors.textLightGray, size: 30),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$_discountPercent% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  product.weight,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textLightGray,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${product.currentPrice.toInt()}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textColor(context),
                          ),
                        ),
                        Text(
                          '₹${product.originalPrice.toInt()}',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textLightGray,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => cart.addItem(product),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
