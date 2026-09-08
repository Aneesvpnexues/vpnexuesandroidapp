import 'package:flutter/material.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key, required this.onArrowTap});

  final VoidCallback onArrowTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/onboarding2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: onArrowTap,
              child: Container(
                width: 76,
                height: 76,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
