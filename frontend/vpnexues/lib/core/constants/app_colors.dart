import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Light mode colors ─────────────────────────────────────────
  static const Color primary = Color(0xFF0E5A35);
  static const Color primaryDark = Color(0xFF0A4428);
  static const Color primaryLight = Color(0xFF2E8B57);
  static const Color lightGreen = Color(0xFFE6F4EA);
  static const Color mintTop = Color(0xFFF3FBF5);
  static const Color mintBottom = Color(0xFFDDF0E3);
  static const Color background = Color(0xFFF8F8F8);
  static const Color white = Colors.white;
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textGray = Color(0xFF6F7D75);
  static const Color textLightGray = Color(0xFF9CA3AF);
  static const Color borderGray = Color(0xFFE3E9E5);
  static const Color fieldFill = Color(0xFFFBFCFB);
  static const Color cardShadow = Color(0x11000000);

  static const Color organicGreen = Color(0xFF2E7D32);
  static const Color saleRed = Color(0xFFE53935);
  static const Color discountOrange = Color(0xFFE8722A);
  static const Color bannerGreen = Color(0xFF2E7D32);
  static const Color bannerYellow = Color(0xFFFFC107);
  static const Color filterGreen = Color(0xFF0E5A35);
  static const Color chipSelectedBg = Color(0xFF0E5A35);
  static const Color chipUnselectedBg = Colors.white;
  static const Color navInactive = Color(0xFF9CA3AF);
  static const Color navActive = Color(0xFF0E5A35);
  static const Color searchBarBg = Colors.white;
  static const Color searchBarBorder = Color(0xFFE3E9E5);
  static const Color trustIcon = Color(0xFF0E5A35);
  static const Color categoryCardBg = Color(0xFFF5F0E8);

  // Cart screen colors
  static const Color deliveryCardBg = Color(0xFFF0F7F2);
  static const Color couponCardBg = Color(0xFFF0F7F2);
  static const Color checkoutGreen = Color(0xFF1B5E3A);
  static const Color discountGreen = Color(0xFF2E7D32);

  // Onboarding / dialog constants
  static const Color dialogDark = Color(0xFF2C2C2E);
  static const Color mapDark = Color(0xFF242428);
  static const Color androidBlue = Color(0xFF4C8BF5);
  static const Color mapRoadYellow = Color(0xFFE8C25A);
  static const Color shopBackground = Color(0xFFF2F3F5);

  // ── Dark mode colors ──────────────────────────────────────────
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkSurface = Color(0xFF2C2C2C);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkTextGray = Color(0xFF9E9E9E);
  static const Color darkBorder = Color(0xFF3C3C3C);
  static const Color darkFieldFill = Color(0xFF2C2C2C);

  // ── Theme-aware helpers ───────────────────────────────────────
  static Color cardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkCard : white;
  }

  static Color scaffoldColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkBackground : background;
  }

  static Color textColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkText : textDark;
  }

  static Color textSecondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkTextGray : textGray;
  }

  static Color borderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkBorder : borderGray;
  }

  static Color fieldFillColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkFieldFill : fieldFill;
  }
}
