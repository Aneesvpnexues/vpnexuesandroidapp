class PaymentConfig {
  PaymentConfig._();

  // Razorpay API Key (test mode)
  // Get your key from: https://dashboard.razorpay.com/app/keys
  // This is the key_id, NOT the secret key. Safe to have in client code.
  // Replace with your actual test key before running payment flows.
  static const String razorpayKeyId = 'rzp_test_REPLACE_ME';

  static const Map<String, CurrencyConfig> currencies = {
    'IN': CurrencyConfig(
      currencyCode: 'INR',
      currencySymbol: '₹',
      razorpayCurrency: 'INR',
    ),
    'SG': CurrencyConfig(
      currencyCode: 'SGD',
      currencySymbol: 'S\$',
      razorpayCurrency: 'SGD',
    ),
    'AE': CurrencyConfig(
      currencyCode: 'AED',
      currencySymbol: 'د.إ',
      razorpayCurrency: 'AED',
    ),
  };

  static CurrencyConfig getCurrency(String countryCode) {
    return currencies[countryCode] ?? currencies['IN']!;
  }
}

class CurrencyConfig {
  final String currencyCode;
  final String currencySymbol;
  final String razorpayCurrency;

  const CurrencyConfig({
    required this.currencyCode,
    required this.currencySymbol,
    required this.razorpayCurrency,
  });
}
