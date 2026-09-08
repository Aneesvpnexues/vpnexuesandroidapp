import 'package:flutter/material.dart';
import 'package:vpnexues_pvt/core/models/country_config.dart';
import 'package:vpnexues_pvt/shared/widgets/onboarding_page_widget.dart';
import '../country/country_welcome_screen.dart';

class CountryOnboardingScreen extends StatefulWidget {
  final CountryConfig countryConfig;

  const CountryOnboardingScreen({
    super.key,
    required this.countryConfig,
  });

  @override
  State<CountryOnboardingScreen> createState() => _CountryOnboardingScreenState();
}

class _CountryOnboardingScreenState extends State<CountryOnboardingScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < widget.countryConfig.onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToWelcome();
    }
  }

  void _navigateToWelcome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CountryWelcomeScreen(
          countryConfig: widget.countryConfig,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.countryConfig.onboardingPages.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return OnboardingPageWidget(
            page: widget.countryConfig.onboardingPages[index],
            pageIndex: index,
            totalPages: widget.countryConfig.onboardingPages.length,
            onNext: _nextPage,
          );
        },
      ),
    );
  }
}
