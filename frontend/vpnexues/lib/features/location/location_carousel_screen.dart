import 'package:flutter/material.dart';

import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/core/constants/app_strings.dart';
import 'package:vpnexues_pvt/shared/widgets/app_logo.dart';

/// A 3-slide horizontal carousel that showcases VPNexues' sourcing locations.
///
/// Slides:
///   1. Salem, Tamil Nadu  → Source
///   2. Singapore          → Connect
///   3. Dubai, UAE         → Expand  (shows Confirm button)
///
/// After the carousel the user continues to the next screen.
class LocationCarouselScreen extends StatefulWidget {
  const LocationCarouselScreen({super.key, this.initialLocation});

  /// Optional pre-selected location index (0 = Salem, 1 = Singapore, 2 = Dubai).
  /// If provided the carousel jumps straight to that slide.
  final int? initialLocation;

  @override
  State<LocationCarouselScreen> createState() => _LocationCarouselScreenState();
}

class _LocationCarouselScreenState extends State<LocationCarouselScreen> {
  late final PageController _controller;
  int _currentPage = 0;

  // ── Slide data ──────────────────────────────────────────────────────────
  static const _slides = [
    _SlideData(
      location: 'SALEM, TAMILNADU',
      heading: 'Source',
      description: 'Trusted sourcing from Salem. Quality you can rely on.',
      imageUrl:
          'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=1200&q=80',
      fallbackColor: Color(0xFF4A7C59),
    ),
    _SlideData(
      location: 'SINGAPORE',
      heading: 'Connect',
      description: 'Reliable movement. Consistent quality.',
      imageUrl:
          'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?auto=format&fit=crop&w=1200&q=80',
      fallbackColor: Color(0xFF3A6B8C),
    ),
    _SlideData(
      location: 'DUBAI, UAE',
      heading: 'Expand',
      description: 'Global trade. Premium delivery.',
      imageUrl:
          'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=1200&q=80',
      fallbackColor: Color(0xFF8C6B3A),
    ),
  ];

  static const _features = [
    _FeatureData(icon: Icons.public, label: 'Global Reach'),
    _FeatureData(icon: Icons.verified, label: 'Quality Assured'),
    _FeatureData(icon: Icons.local_shipping_outlined, label: 'Reliable Delivery'),
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialLocation ?? 0;
    _controller = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _skip() => _navigateNext();

  void _confirm() => _navigateNext();

  void _navigateNext() {
    // Navigate to the next screen in the flow.
    // For now we pop; the caller decides what comes after.
    Navigator.of(context).pop(_currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment(0, 0.45),
            colors: [AppColors.primaryDark, AppColors.primary],
            stops: [0.0, 0.55],
          ),
        ),
        child: Column(
          children: [
            // ── Top bar: Skip ─────────────────────────────────────
            SizedBox(height: topPadding + 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _skip,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // ── Logo + company name ──────────────────────────────
            const SizedBox(height: 8),
            const AppLogo(size: 72),
            const SizedBox(height: 10),
            const Text(
              AppStrings.appName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),

            // ── Location badge ───────────────────────────────────
            const SizedBox(height: 14),
            _LocationBadge(location: _slides[_currentPage].location),

            // ── Main card (PageView) ─────────────────────────────
            const SizedBox(height: 18),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) => _SlideCard(
                  data: _slides[index],
                  isLast: index == _slides.length - 1,
                  onConfirm: _confirm,
                ),
              ),
            ),

            // ── Bottom panel: features + indicators ──────────────
            _BottomPanel(
              features: _features,
              currentPage: _currentPage,
              slideCount: _slides.length,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Slide data model ──────────────────────────────────────────────────────

class _SlideData {
  const _SlideData({
    required this.location,
    required this.heading,
    required this.description,
    required this.imageUrl,
    required this.fallbackColor,
  });

  final String location;
  final String heading;
  final String description;
  final String imageUrl;
  final Color fallbackColor;
}

class _FeatureData {
  const _FeatureData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

// ── Location badge ────────────────────────────────────────────────────────

class _LocationBadge extends StatelessWidget {
  const _LocationBadge({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.location_on, color: Colors.white70, size: 18),
        const SizedBox(width: 6),
        Text(
          location,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
          ),
        ),
      ],
    );
  }
}

// ── Slide card ────────────────────────────────────────────────────────────

class _SlideCard extends StatelessWidget {
  const _SlideCard({
    required this.data,
    required this.isLast,
    required this.onConfirm,
  });

  final _SlideData data;
  final bool isLast;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image with fallback color.
            Image.network(
              data.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: data.fallbackColor),
            ),

            // Dark gradient overlay.
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x55000000), Color(0xBB000000)],
                ),
              ),
            ),

            // Text content.
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    data.heading,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (isLast)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom panel ──────────────────────────────────────────────────────────

class _BottomPanel extends StatelessWidget {
  const _BottomPanel({
    required this.features,
    required this.currentPage,
    required this.slideCount,
  });

  final List<_FeatureData> features;
  final int currentPage;
  final int slideCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Feature icons row.
          Row(
            children: [
              for (var i = 0; i < features.length; i++) ...[
                if (i > 0) const Spacer(),
                _FeatureBadge(
                  icon: features[i].icon,
                  label: features[i].label,
                ),
              ],
            ],
          ),
          const SizedBox(height: 22),

          // Page indicators.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(slideCount, (i) {
              final active = i == currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: active ? 28 : 10,
                height: 10,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : AppColors.borderGray,
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  const _FeatureBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.lightGreen,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor(context),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
