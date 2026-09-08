import 'package:flutter_test/flutter_test.dart';
import 'package:vpnexues_pvt/core/constants/country_configs.dart';

void main() {
  group('CountryConfigs', () {
    group('singapore config', () {
      test('has correct country code', () {
        expect(CountryConfigs.singapore.countryCode, 'SG');
      });

      test('has correct country name', () {
        expect(CountryConfigs.singapore.countryName, 'Singapore');
      });

      test('has locale prefix', () {
        expect(CountryConfigs.singapore.localePrefix, 'en');
      });

      test('has onboarding pages', () {
        expect(CountryConfigs.singapore.onboardingPages.length, 3);
      });

      test('has welcome text', () {
        expect(CountryConfigs.singapore.welcomeTitle, isNotEmpty);
        expect(CountryConfigs.singapore.welcomeSubtitle, isNotEmpty);
      });
    });

    group('uae config', () {
      test('has correct country code', () {
        expect(CountryConfigs.uae.countryCode, 'AE');
      });

      test('has correct country name', () {
        expect(CountryConfigs.uae.countryName, 'Dubai');
      });

      test('has locale prefix', () {
        expect(CountryConfigs.uae.localePrefix, 'ar');
      });

      test('has onboarding pages', () {
        expect(CountryConfigs.uae.onboardingPages.length, 3);
      });
    });

    group('tamilNadu config', () {
      test('has correct country code', () {
        expect(CountryConfigs.tamilNadu.countryCode, 'IN');
      });

      test('has correct country name', () {
        expect(CountryConfigs.tamilNadu.countryName, 'Tamil Nadu');
      });

      test('has locale prefix', () {
        expect(CountryConfigs.tamilNadu.localePrefix, 'ta');
      });

      test('has onboarding pages', () {
        expect(CountryConfigs.tamilNadu.onboardingPages.length, 3);
      });
    });

    group('allCountries', () {
      test('has 3 countries', () {
        expect(CountryConfigs.allCountries.length, 3);
      });

      test('contains SG, AE, IN', () {
        final codes = CountryConfigs.allCountries.map((c) => c.countryCode).toList();
        expect(codes, containsAll(['SG', 'AE', 'IN']));
      });
    });

    group('getByCountryCode', () {
      test('returns SG for SG', () {
        expect(CountryConfigs.getByCountryCode('SG').countryCode, 'SG');
      });

      test('returns AE for AE', () {
        expect(CountryConfigs.getByCountryCode('AE').countryCode, 'AE');
      });

      test('returns IN for IN', () {
        expect(CountryConfigs.getByCountryCode('IN').countryCode, 'IN');
      });

      test('defaults to Singapore for unknown code', () {
        expect(CountryConfigs.getByCountryCode('US').countryCode, 'SG');
      });
    });
  });
}
