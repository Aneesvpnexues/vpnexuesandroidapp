import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/models/product.dart';
import 'package:vpnexues_pvt/features/cart/providers/cart_provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/shared/widgets/product_image.dart';
import 'package:vpnexues_pvt/shared/localization/language_provider.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final lang = context.watch<LanguageProvider>();
    final quantity = cart.getQuantity(product.id);

    return Container(
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
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: ProductImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: Container(
                        color: AppColors.lightGreen,
                        child: Center(
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.organicGreen,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        lang.t('product_organic'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                if (product.isSale)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.saleRed,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        lang.t('product_sale'),
                        style: TextStyle(
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
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  product.subtitle,
                  style: TextStyle(
                    fontSize: 11,
                  color: AppColors.textLightGray,
                ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.discount,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.discountOrange,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '₹${product.currentPrice.toInt()}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '₹${product.originalPrice.toInt()}',
                      style: TextStyle(
                        fontSize: 11,
                  color: AppColors.textLightGray,
                  decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      product.weight,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textLightGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                quantity == 0
                    ? _buildAddButton(cart, lang)
                    : _buildQuantityStepper(context, cart, quantity),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(CartProvider cart, LanguageProvider lang) {
    return GestureDetector(
      onTap: () => cart.addItem(product),
      child: Container(
        width: double.infinity,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 16),
            SizedBox(width: 6),
            Text(
              lang.t('product_add'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.add, color: Colors.white, size: 16),
          ],
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
              width: 36,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: const Icon(Icons.remove, color: Colors.white, size: 16),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '$quantity',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor(context),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => cart.addItem(product),
            child: Container(
              width: 36,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
