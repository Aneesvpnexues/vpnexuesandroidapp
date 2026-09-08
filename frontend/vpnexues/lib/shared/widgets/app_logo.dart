import 'package:flutter/material.dart';

/// Circular VPNexues company logo.
///
/// Displays the official logo image asset
/// (`assets/images/company_logo.png`).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 120});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/company_logo.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
