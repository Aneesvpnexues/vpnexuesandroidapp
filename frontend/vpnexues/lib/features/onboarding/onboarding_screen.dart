import 'package:flutter/material.dart';
import 'onboarding_page1.dart';
import 'onboarding_page2.dart';
import '../auth/login/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        clipBehavior: Clip.hardEdge,
        children: [
          OnboardingPage1(onArrowTap: _goToNextPage),
          OnboardingPage2(onArrowTap: _goToLogin),
        ],
      ),
    );
  }
}
