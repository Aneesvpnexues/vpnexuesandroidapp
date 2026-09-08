import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/shared/utils/responsive.dart';
import 'package:vpnexues_pvt/features/settings/settings_screen.dart';
import 'package:vpnexues_pvt/features/address/providers/address_provider.dart';
import 'package:vpnexues_pvt/features/address/address_picker_screen.dart';
import 'package:vpnexues_pvt/core/services/country_detection_service.dart';
import 'package:vpnexues_pvt/shared/localization/language_provider.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().loadAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final iconBoxSize = Responsive.isSmallPhone(context) ? 38.0 : 42.0;
    final addressProvider = context.watch<AddressProvider>();
    final lang = context.watch<LanguageProvider>();
    String addressText = CountryDetectionService.defaultCountryName;
    if (addressProvider.defaultAddress != null) {
      final city = addressProvider.defaultAddress!.city.trim();
      final state = addressProvider.defaultAddress!.state.trim();
      if (city.isNotEmpty && state.isNotEmpty) {
        addressText = '$city, $state';
      } else if (city.isNotEmpty) {
        addressText = city;
      } else if (state.isNotEmpty) {
        addressText = state;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.primary, size: 22),
          const SizedBox(width: 6),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressPickerScreen(),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.t('home_deliver_to'),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textLightGray,
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          addressText,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            child: _buildIconBox(context, Icons.settings_outlined, iconBoxSize),
          ),
        ],
      ),
    );
  }

  static Widget _buildIconBox(BuildContext context, IconData icon, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.textColor(context), size: 22),
    );
  }
}
