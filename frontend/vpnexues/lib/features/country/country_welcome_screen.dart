import 'package:flutter/material.dart';
import 'package:vpnexues_pvt/core/models/country_config.dart';
import 'package:vpnexues_pvt/shared/utils/responsive.dart';
import '../auth/login/login_screen.dart';

class CountryWelcomeScreen extends StatelessWidget {
  final CountryConfig countryConfig;

  const CountryWelcomeScreen({
    super.key,
    required this.countryConfig,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [
                    Color(0xFFF5F0E8),
                    Color(0xFFE8E0D0),
                  ],
                ),
              ),
            ),
          ),

          // Decorative circles
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1B5E20).withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -60,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFC107).withValues(alpha: 0.08),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(height: Responsive.isSmallPhone(context) ? 20 : 30),

                  // Logo
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF0E5A35),
                            ),
                            child: const Icon(
                              Icons.eco,
                              color: Colors.white,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // App name
                  Text(
                    'VP NEXUES',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1B5E20),
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'IMPORT & EXPORT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4CAF50),
                      letterSpacing: 2,
                    ),
                  ),

                  const Spacer(),

                  // Welcome text
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Welcome to',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          countryConfig.welcomeTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1B5E20),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          countryConfig.welcomeDescription,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Get Started button
                  Padding(
                    padding: EdgeInsets.only(bottom: Responsive.isSmallPhone(context) ? 30 : 50),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B5E20),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              countryConfig.welcomeButtonText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
