import 'package:flutter/material.dart';
import 'package:vpnexues_pvt/core/models/country_config.dart';
import 'package:vpnexues_pvt/shared/utils/responsive.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;
  final int pageIndex;
  final int totalPages;
  final VoidCallback? onNext;

  const OnboardingPageWidget({
    super.key,
    required this.page,
    required this.pageIndex,
    required this.totalPages,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: Stack(
        children: [
          // Background cityscape image - sits behind text in the sky area
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: page.imageUrl != null
                ? Image.network(
                    page.imageUrl!,
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF1B5E20),
                          strokeWidth: 2,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  )
                : Image.asset(
                    page.imagePath,
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
          ),

          // Gradient overlay: cream at top fading to transparent, so text is readable
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF5F0E8), // solid cream at top
                    Color(0xF0F5F0E8), // mostly transparent at bottom
                    Color(0x00F5F0E8), // fully transparent
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Responsive.isSmallPhone(context) ? 20 : 30),

                // Logo section - centered
                Center(
                  child: Column(
                    children: [
                      // Logo circle with semi-transparent backdrop
                      Container(
                        width: Responsive.isSmallPhone(context) ? 65 : 80,
                        height: Responsive.isSmallPhone(context) ? 65 : 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
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
                      const SizedBox(height: 8),
                      const Text(
                        'VP NEXUES',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1B5E20),
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'IMPORT & EXPORT',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4CAF50),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Responsive.isSmallPhone(context) ? 28 : 40),

                // Headline section - left aligned
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.isSmallPhone(context) ? 24 : 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Headline - use Text.rich for proper wrapping
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: page.headline,
                              style: TextStyle(
                                fontSize: Responsive.isSmallPhone(context) ? 26 : 34,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1B5E20),
                                height: 1.15,
                              ),
                            ),
                            TextSpan(
                              text: page.emphasis,
                              style: TextStyle(
                                fontSize: Responsive.isSmallPhone(context) ? 26 : 34,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                                color: const Color(0xFF1B5E20),
                                height: 1.15,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Yellow underline bar
                      Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Subtitle
                      Text(
                        page.subtitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4A5568),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Bottom panel with trust badges
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.isSmallPhone(context) ? 18 : 24,
                    vertical: Responsive.isSmallPhone(context) ? 16 : 20,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Trust badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _TrustBadge(
                            icon: Icons.language,
                            label: 'Global\nReach',
                          ),
                          _TrustBadge(
                            icon: Icons.verified,
                            label: 'Quality\nAssured',
                          ),
                          _TrustBadge(
                            icon: Icons.local_shipping_outlined,
                            label: 'Reliable\nDelivery',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Dots and arrow
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Page indicators
                          Row(
                            children: List.generate(
                              totalPages,
                              (index) => Container(
                                width: index == pageIndex ? 24 : 10,
                                height: 10,
                                margin: const EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  color: index == pageIndex
                                      ? const Color(0xFF1B5E20)
                                      : const Color(0xFFD4D4D4),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),

                          // Arrow button
                          GestureDetector(
                            onTap: onNext,
                            child: Container(
                              width: Responsive.isSmallPhone(context) ? 42 : 48,
                              height: Responsive.isSmallPhone(context) ? 42 : 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF1B5E20),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Color(0xFF1B5E20),
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: const Color(0xFF1B5E20),
          size: Responsive.isSmallPhone(context) ? 24 : 28,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A5568),
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
