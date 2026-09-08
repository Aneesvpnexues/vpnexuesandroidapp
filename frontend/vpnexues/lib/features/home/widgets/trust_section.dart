import 'package:flutter/material.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/shared/utils/responsive.dart';

class TrustSection extends StatelessWidget {
  const TrustSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = Responsive.screenWidth(context);
    
    // Use Wrap on very narrow screens to prevent cramping
    if (w < 400) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Wrap(
          spacing: 4,
          runSpacing: 12,
          alignment: WrapAlignment.spaceEvenly,
          children: const [
            _TrustItem(
              icon: Icons.local_shipping_outlined,
              title: 'Free Delivery',
              subtitle: 'On orders above ₹499',
            ),
            _TrustItem(
              icon: Icons.eco_outlined,
              title: '100% Fresh',
              subtitle: 'Handpicked daily',
            ),
            _TrustItem(
              icon: Icons.verified_outlined,
              title: 'Quality Assured',
              subtitle: 'Trusted by 50K+',
            ),
            _TrustItem(
              icon: Icons.headset_mic_outlined,
              title: '24/7 Support',
              subtitle: "We're here for you",
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TrustItem(
            icon: Icons.local_shipping_outlined,
            title: 'Free Delivery',
            subtitle: 'On orders above ₹499',
            wide: w >= 400,
          ),
          _TrustItem(
            icon: Icons.eco_outlined,
            title: '100% Fresh',
            subtitle: 'Handpicked daily',
            wide: w >= 400,
          ),
          _TrustItem(
            icon: Icons.verified_outlined,
            title: 'Quality Assured',
            subtitle: 'Trusted by 50K+ users',
            wide: w >= 400,
          ),
          _TrustItem(
            icon: Icons.headset_mic_outlined,
            title: '24/7 Support',
            subtitle: "We're here for you",
            wide: w >= 400,
          ),
        ],
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.wide = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final iconSize = wide ? 24.0 : 22.0;
    final titleSize = wide ? 11.0 : 10.0;
    final subtitleSize = wide ? 9.0 : 8.0;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.trustIcon, size: iconSize),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: subtitleSize,
              color: AppColors.textLightGray,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
