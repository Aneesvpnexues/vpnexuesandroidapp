import 'package:flutter_test/flutter_test.dart';
import 'package:vpnexues_pvt/core/constants/payment_config.dart';

void main() {
  group('PaymentConfig', () {
    test('has razorpay key defined', () {
      expect(PaymentConfig.razorpayKeyId, isNotEmpty);
      expect(PaymentConfig.razorpayKeyId, startsWith('rzp_'));
    });

    group('getCurrency', () {
      test('returns INR for India', () {
        final currency = PaymentConfig.getCurrency('IN');
        expect(currency.currencyCode, 'INR');
        expect(currency.razorpayCurrency, 'INR');
      });

      test('returns SGD for Singapore', () {
        final currency = PaymentConfig.getCurrency('SG');
        expect(currency.currencyCode, 'SGD');
        expect(currency.razorpayCurrency, 'SGD');
      });

      test('returns AED for UAE', () {
        final currency = PaymentConfig.getCurrency('AE');
        expect(currency.currencyCode, 'AED');
        expect(currency.razorpayCurrency, 'AED');
      });

      test('defaults to INR for unknown country', () {
        final currency = PaymentConfig.getCurrency('US');
        expect(currency.currencyCode, 'INR');
        expect(currency.razorpayCurrency, 'INR');
      });

      test('defaults to INR for empty string', () {
        final currency = PaymentConfig.getCurrency('');
        expect(currency.currencyCode, 'INR');
      });
    });

    test('currencies map has 3 entries', () {
      expect(PaymentConfig.currencies.length, 3);
      expect(PaymentConfig.currencies.containsKey('IN'), true);
      expect(PaymentConfig.currencies.containsKey('SG'), true);
      expect(PaymentConfig.currencies.containsKey('AE'), true);
    });
  });

  group('CurrencyConfig', () {
    test('stores all fields correctly', () {
      const config = CurrencyConfig(
        currencyCode: 'USD',
        currencySymbol: '\$',
        razorpayCurrency: 'USD',
      );

      expect(config.currencyCode, 'USD');
      expect(config.currencySymbol, '\$');
      expect(config.razorpayCurrency, 'USD');
    });
  });
}
