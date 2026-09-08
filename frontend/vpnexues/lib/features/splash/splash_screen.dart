import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/models/country_config.dart';
import 'package:vpnexues_pvt/shared/providers/auth_provider.dart';
import 'package:vpnexues_pvt/core/services/api_service.dart';
import 'package:vpnexues_pvt/core/services/country_detection_service.dart';
import '../country/country_onboarding_screen.dart';
import '../navigation/main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CountryConfig? _detectedCountry;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ));
    _initialize();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _initialize() async {
    final country = await CountryDetectionService.detectCountry();

    if (!mounted) return;

    setState(() {
      _detectedCountry = country;
    });

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    final authProvider = context.read<AuthProvider>();
    final autoLoggedIn = await authProvider.tryAutoLogin();

    if (!mounted) return;

    if (autoLoggedIn) {
      ApiService().setToken(authProvider.token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CountryOnboardingScreen(
            countryConfig: _detectedCountry!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F0),
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/splash_screen.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
