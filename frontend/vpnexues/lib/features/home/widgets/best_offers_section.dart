import 'package:flutter/material.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/shared/utils/responsive.dart';
import '../all_products_screen.dart';

class BestOffersSection extends StatelessWidget {
  const BestOffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmall = Responsive.isSmallPhone(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Best Offers',
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
                      builder: (context) => const AllProductsScreen(title: 'Best Offers'),
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
          height: isSmall ? 100 : 120,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            children: [
              _OfferCard(
                title: 'Fruits',
                discount: 'Up to 30% OFF',
                color: Colors.red.shade50,
                iconColor: Colors.red,
                icon: Icons.apple,
                category: 'fruits',
              ),
              const SizedBox(width: 12),
              _OfferCard(
                title: 'Vegetables',
                discount: 'Up to 25% OFF',
                color: Colors.green.shade50,
                iconColor: Colors.green,
                icon: Icons.eco,
                category: 'vegetables',
              ),
              const SizedBox(width: 12),
              _OfferCard(
                title: 'Dairy & Eggs',
                discount: 'Up to 20% OFF',
                color: Colors.blue.shade50,
                iconColor: Colors.blue,
                icon: Icons.egg,
                category: 'groceries',
              ),
              const SizedBox(width: 12),
              _OfferCard(
                title: 'Beverages',
                discount: 'Up to 24% OFF',
                color: Colors.orange.shade50,
                iconColor: Colors.orange,
                icon: Icons.local_cafe,
                category: 'beverages',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({
    required this.title,
    required this.discount,
    required this.color,
    required this.iconColor,
    required this.icon,
    required this.category,
  });

  final String title;
  final String discount;
  final Color color;
  final Color iconColor;
  final IconData icon;
  final String category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllProductsScreen(title: title, initialCategory: category),
          ),
        );
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: iconColor.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor(context),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              discount,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
