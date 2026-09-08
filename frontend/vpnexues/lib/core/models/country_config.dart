import 'package:flutter/material.dart';

class OnboardingPage {
  final String headline;
  final String emphasis;
  final String subtitle;
  final String imagePath;
  final String? imageUrl;

  const OnboardingPage({
    required this.headline,
    required this.emphasis,
    required this.subtitle,
    required this.imagePath,
    this.imageUrl,
  });
}

class CountryConfig {
  final String countryCode;
  final String countryName;
  final String localePrefix;
  final List<OnboardingPage> onboardingPages;
  final String welcomeTitle;
  final String welcomeSubtitle;
  final Color primaryColor;
  final Color accentColor;
  final String welcomeButtonText;
  final String welcomeDescription;

  const CountryConfig({
    required this.countryCode,
    required this.countryName,
    required this.localePrefix,
    required this.onboardingPages,
    required this.welcomeTitle,
    required this.welcomeSubtitle,
    this.primaryColor = const Color(0xFF1B5E20),
    this.accentColor = const Color(0xFFFFC107),
    this.welcomeButtonText = 'Get Started',
    this.welcomeDescription = '',
  });
}
