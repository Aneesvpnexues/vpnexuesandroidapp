import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  // ── Breakpoints ──────────────────────────────────────────────────────
  static const double smallPhoneMax = 360;
  static const double normalPhoneMin = 360;
  static const double normalPhoneMax = 400;
  static const double largePhoneMin = 400;
  static const double largePhoneMax = 600;
  static const double tabletMin = 600;

  // ── Screen queries ───────────────────────────────────────────────────
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double pixelRatio(BuildContext context) =>
      MediaQuery.of(context).devicePixelRatio;

  // ── Device type checks ───────────────────────────────────────────────
  static bool isSmallPhone(BuildContext context) =>
      screenWidth(context) < smallPhoneMax;

  static bool isNormalPhone(BuildContext context) =>
      screenWidth(context) >= normalPhoneMin &&
      screenWidth(context) < normalPhoneMax;

  static bool isLargePhone(BuildContext context) =>
      screenWidth(context) >= largePhoneMin &&
      screenWidth(context) < largePhoneMax;

  static bool isTablet(BuildContext context) =>
      screenWidth(context) >= tabletMin;

  // ── Sizing helpers (proportional to 412dp reference width) ──────────
  static double width(BuildContext context, double base) {
    final w = screenWidth(context);
    return base * (w / 412);
  }

  static double height(BuildContext context, double base) {
    final h = screenHeight(context);
    return base * (h / 892);
  }

  static double fontSize(BuildContext context, double base) {
    final w = screenWidth(context);
    if (w < 360) return base * 0.9;
    if (w >= 600) return base * 1.1;
    return base;
  }

  static double padding(BuildContext context, double base) {
    final w = screenWidth(context);
    if (w < 360) return base * 0.85;
    if (w >= 600) return base * 1.15;
    return base;
  }

  // ── Grid helpers ─────────────────────────────────────────────────────
  static int gridCrossAxisCount(
    BuildContext context, {
    int smallPhone = 2,
    int normalPhone = 2,
    int largePhone = 2,
    int tablet = 3,
  }) {
    if (isSmallPhone(context)) return smallPhone;
    if (isNormalPhone(context)) return normalPhone;
    if (isLargePhone(context)) return largePhone;
    return tablet;
  }

  static double productCardAspectRatio(BuildContext context) {
    final w = screenWidth(context);
    if (w < 360) return 0.68;
    if (w < 400) return 0.74;
    if (w >= 600) return 0.82;
    return 0.76;
  }

  // ── Horizontal padding ───────────────────────────────────────────────
  static double horizontalPadding(BuildContext context) {
    final w = screenWidth(context);
    if (w < 360) return 16;
    if (w >= 600) return 24;
    return 20;
  }

  // ── Tablet content constraint ────────────────────────────────────────
  static double tabletMaxWidth(BuildContext context) {
    final w = screenWidth(context);
    if (w >= 600) return 600;
    return w;
  }

  // ── Scale factor for arbitrary values ────────────────────────────────
  static double scale(BuildContext context, double base) {
    final w = screenWidth(context);
    return base * (w / 412);
  }
}
