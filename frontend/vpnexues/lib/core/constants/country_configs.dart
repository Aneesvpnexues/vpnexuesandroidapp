import 'package:flutter/material.dart';
import 'package:vpnexues_pvt/core/models/country_config.dart';

class CountryConfigs {
  CountryConfigs._();

  static const Color _primaryGreen = Color(0xFF1B5E20);
  static const Color _accentYellow = Color(0xFFFFC107);

  static final CountryConfig singapore = CountryConfig(
    countryCode: 'SG',
    countryName: 'Singapore',
    localePrefix: 'en',
    primaryColor: _primaryGreen,
    accentColor: _accentYellow,
    welcomeTitle: 'Welcome to VP Nexus Singapore',
    welcomeSubtitle: 'Fresh groceries delivered to your doorstep in Singapore.',
    welcomeButtonText: 'Get Started',
    welcomeDescription:
        'Experience the finest fresh produce, sourced globally and delivered with care to your home in Singapore.',
    onboardingPages: [
      OnboardingPage(
        headline: 'Fresh groceries\nmade for',
        emphasis: 'Singapore.',
        subtitle: 'Trusted sources.\nQuality every day.',
        imagePath: 'assets/images/singapore/marina_bay_sands.jpg',
      ),
      OnboardingPage(
        headline: 'Fresh',
        emphasis: 'Singapore.\nto every\nDestination.',
        subtitle: 'Connecting quality.\nDelivering worldwide.',
        imagePath: 'assets/images/singapore/merlion.jpg',
      ),
      OnboardingPage(
        headline: 'Your Everyday\nEssentials,\nDelivered',
        emphasis: 'Fresh.',
        subtitle: 'Fresh products,\nReliable delivery.',
        imagePath: 'assets/images/singapore/singapore_flyer.jpg',
      ),
    ],
  );

  static final CountryConfig uae = CountryConfig(
    countryCode: 'AE',
    countryName: 'Dubai',
    localePrefix: 'ar',
    primaryColor: _primaryGreen,
    accentColor: _accentYellow,
    welcomeTitle: 'Welcome to VP Nexus Dubai',
    welcomeSubtitle: 'Fresh groceries delivered to your doorstep in Dubai.',
    welcomeButtonText: 'Get Started',
    welcomeDescription:
        'Experience the finest fresh produce, sourced globally and delivered with care to your home in Dubai.',
    onboardingPages: [
      OnboardingPage(
        headline: 'Fresh Groceries\nMade for',
        emphasis: 'Dubai.',
        subtitle: 'Fresh markets.\nGlobal possibilities.',
        imagePath: 'assets/images/dubai/burj_khalifa.jpg',
      ),
      OnboardingPage(
        headline: 'From the world\nto',
        emphasis: 'Dubai,\nwith care.',
        subtitle: 'Connecting quality\nwith opportunity.',
        imagePath: 'assets/images/dubai/burj_al_arab.jpg',
      ),
      OnboardingPage(
        headline: 'Your everyday\nessentials,',
        emphasis: 'Delivered',
        subtitle: 'Bringing trusted products\ncloser to you.',
        imagePath: 'assets/images/dubai/museum_future.jpg',
      ),
    ],
  );

  static final CountryConfig tamilNadu = CountryConfig(
    countryCode: 'IN',
    countryName: 'Tamil Nadu',
    localePrefix: 'ta',
    primaryColor: _primaryGreen,
    accentColor: _accentYellow,
    welcomeTitle: 'Welcome to VP Nexus Tamil Nadu',
    welcomeSubtitle:
        'Fresh groceries delivered to your doorstep in Tamil Nadu.',
    welcomeButtonText: 'Get Started',
    welcomeDescription:
        'Experience the finest fresh produce, sourced globally and delivered with care to your home in Tamil Nadu.',
    onboardingPages: [
      OnboardingPage(
        headline: 'Fresh groceries\nmade for',
        emphasis: 'Tamil Nadu.',
        subtitle: 'Bringing trusted products\ncloser to you.',
        imagePath: 'assets/images/tamil_nadu/tea_plantation.jpg',
      ),
      OnboardingPage(
        headline: 'From',
        emphasis: 'Tamil Nadu\nto every\ndestination.',
        subtitle: 'Connecting quality with\nwider markets.',
        imagePath: 'assets/images/tamil_nadu/hindu_temple.jpg',
      ),
      OnboardingPage(
        headline: 'Your everyday\nessentials,\ndelivered',
        emphasis: 'Fresh.',
        subtitle: 'Reliable quality. Delivered\nwith care.',
        imagePath: 'assets/images/tamil_nadu/banana_plantation.jpg',
      ),
    ],
  );

  static final List<CountryConfig> allCountries = [
    singapore,
    uae,
    tamilNadu,
  ];

  static CountryConfig getByCountryCode(String code) {
    return allCountries.firstWhere(
      (c) => c.countryCode == code,
      orElse: () => singapore,
    );
  }
}
