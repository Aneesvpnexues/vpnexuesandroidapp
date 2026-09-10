import 'package:flutter/material.dart';

class FarmFreshBanner extends StatelessWidget {
  const FarmFreshBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Image.asset(
        'assets/images/banner.png',
        width: double.infinity,
        fit: BoxFit.fitWidth,
        errorBuilder: (_, _, _) => Container(
          color: const Color(0xFFFFC107),
          child: const Center(
            child: Icon(Icons.shopping_basket, color: Colors.white54, size: 60),
          ),
        ),
      ),
    );
  }
}
