import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/shared/utils/responsive.dart';
import 'package:vpnexues_pvt/shared/widgets/app_logo.dart';
import '../auth/login/login_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _searchController = TextEditingController();
  int _selectedAddress = 0;

  static const _addresses = [
    (
      icon: Icons.home_outlined,
      title: 'Home',
      line1: '123 Green Street, Vegetable Market,',
      line2: 'Your City - 123456',
    ),
    (
      icon: Icons.work_outline,
      title: 'Work',
      line1: '456 Office Road, Business Park,',
      line2: 'Your City - 123456',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.mintBottom, Colors.white],
            ),
          ),
          child: Stack(
            children: [
              // ── Subtle logo watermark (upper-right, ~7% opacity) ──
              const Positioned(
                top: -60,
                right: -80,
                child: Opacity(
                  opacity: 0.07,
                  child: AppLogo(size: 300),
                ),
              ),

              // ── Main content ──
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button.
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: Icon(Icons.arrow_back,
                            color: AppColors.textColor(context)),
                      ),
                    ),

                    // Header text.
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Delivery Location',
                            style: TextStyle(
                              fontSize: Responsive.isSmallPhone(context) ? 24 : 30,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryDark,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Enter your location to see\navailable products',
                            style: TextStyle(
                              fontSize: 14.5,
                              height: 1.4,
                              color: AppColors.textSecondaryColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Scrollable content.
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Search bar.
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x11000000),
                                    blurRadius: 14,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search your area or location',
                                  prefixIcon: const Icon(Icons.search,
                                      color: AppColors.primary),
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.gps_fixed,
                                        color: AppColors.primary),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.2),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 26),

                            const _SectionLabel('Current Location',
                                icon: Icons.location_on),
                            const SizedBox(height: 12),
                            _ActionCard(
                              onTap: () {},
                              child: Row(
                                children: [
                                  const _IconBadge(icon: Icons.location_on),
                                  const SizedBox(width: 14),
                                   Expanded(
                                     child: Column(
                                       crossAxisAlignment:
                                           CrossAxisAlignment.start,
                                       children: [
                                         Text(
                                           'Use My Current Location',
                                           style: TextStyle(
                                             fontSize: 16,
                                             fontWeight: FontWeight.w700,
                                             color: AppColors.textColor(context),
                                           ),
                                         ),
                                         SizedBox(height: 4),
                                         Text(
                                           'Detect my location automatically',
                                           style: TextStyle(
                                             fontSize: 13,
                                             color: AppColors.textSecondaryColor(context),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                  const Icon(Icons.chevron_right,
                                      color: AppColors.primary),
                                ],
                              ),
                            ),
                            const SizedBox(height: 26),

                            const _SectionLabel('Saved Addresses',
                                icon: Icons.bookmark_border),
                            const SizedBox(height: 12),
                            for (var i = 0; i < _addresses.length; i++) ...[
                              _ActionCard(
                                onTap: () =>
                                    setState(() => _selectedAddress = i),
                                child: Row(
                                  children: [
                                    _IconBadge(icon: _addresses[i].icon),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _addresses[i].title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textColor(context),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${_addresses[i].line1}\n${_addresses[i].line2}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              height: 1.35,
                                              color: AppColors.textSecondaryColor(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      i == _selectedAddress
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      color: i == _selectedAddress
                                          ? AppColors.primary
                                          : AppColors.borderGray,
                                    ),
                                  ],
                                ),
                              ),
                              if (i < _addresses.length - 1)
                                const SizedBox(height: 14),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // Confirm button pinned at the bottom.
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, size: 20),
                            SizedBox(width: 8),
                            Text('Confirm Location'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryDark),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor(context),
          ),
        ),
      ],
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: AppColors.lightGreen,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primary, size: 24),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: child,
          ),
        ),
      ),
    );
  }
}
