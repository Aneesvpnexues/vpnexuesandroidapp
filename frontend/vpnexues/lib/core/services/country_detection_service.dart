import 'package:vpnexues_pvt/core/models/country_config.dart';
import 'package:vpnexues_pvt/core/constants/country_configs.dart';
import 'country_detection_helper.dart';
import 'geoip_helper.dart';

class CountryDetectionService {
  CountryDetectionService._();

  // Auto-detection is enabled. To test a specific country, set to
  // 'IN' (Tamil Nadu), 'AE' (UAE), or 'SG' (Singapore).
  // Set to null for auto-detection (production).
  static String? forceOverride = 'SG';

  static double get defaultLatitude {
    final code = forceOverride ?? 'SG';
    switch (code) {
      case 'IN':
        return 11.6643;
      case 'AE':
        return 25.2048;
      case 'SG':
      default:
        return 1.3521;
    }
  }

  static double get defaultLongitude {
    final code = forceOverride ?? 'SG';
    switch (code) {
      case 'IN':
        return 78.1465;
      case 'AE':
        return 55.2708;
      case 'SG':
      default:
        return 103.8198;
    }
  }

  static String get defaultCountryName {
    final code = forceOverride ?? 'SG';
    switch (code) {
      case 'IN':
        return 'India';
      case 'AE':
        return 'UAE';
      case 'SG':
      default:
        return 'Singapore';
    }
  }

  static Future<CountryConfig> detectCountry() async {
    // Step 1: Check force override (for testing)
    if (forceOverride != null) {
      return _mapCountryCode(forceOverride!);
    }

    // Step 2: Try GeoIP detection
    try {
      final countryCode = await GeoIPHelper.getCountryCode();
      if (countryCode != null && countryCode.isNotEmpty) {
        return _mapCountryCode(countryCode);
      }
    } catch (_) {}

    // Step 3: Fall back to locale detection
    return _detectByLocale();
  }

  static CountryConfig _detectByLocale() {
    try {
      final String lowerLocale = CountryDetectionHelper.getLocale().toLowerCase();

      if (lowerLocale.startsWith('ar')) {
        return CountryConfigs.uae;
      }

      if (lowerLocale.startsWith('ta')) {
        return CountryConfigs.tamilNadu;
      }

      return CountryConfigs.singapore;
    } catch (e) {
      return CountryConfigs.singapore;
    }
  }

  static CountryConfig _mapCountryCode(String code) {
    switch (code.toUpperCase()) {
      case 'IN':
        return CountryConfigs.tamilNadu;
      case 'AE':
      case 'SA':
      case 'QA':
      case 'KW':
      case 'BH':
      case 'OM':
        return CountryConfigs.uae;
      case 'SG':
      case 'MY':
      case 'ID':
      case 'TH':
      case 'PH':
      case 'VN':
        return CountryConfigs.singapore;
      default:
        return CountryConfigs.singapore;
    }
  }

  static Future<String> getDetectedCountryName() async {
    final country = await detectCountry();
    return country.countryName;
  }
}
