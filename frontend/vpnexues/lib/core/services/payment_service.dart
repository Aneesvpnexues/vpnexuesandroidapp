import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:vpnexues_pvt/core/constants/payment_config.dart';

class PaymentService {
  PaymentService._();
  static final PaymentService _instance = PaymentService._();
  factory PaymentService() => _instance;

  final Razorpay _razorpay = Razorpay();

  Completer<PaymentResult>? _paymentCompleter;

  void initialize() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  /// Opens Razorpay checkout. Returns PaymentResult on completion.
  Future<PaymentResult> openCheckout({
    required String countryCode,
    required double amount,
    required String orderId,
    required String customerEmail,
    required String customerPhone,
  }) async {
    _paymentCompleter = Completer<PaymentResult>();

    final currency = PaymentConfig.getCurrency(countryCode);

    // Razorpay expects amount in smallest currency unit (paise for INR, cents for SGD)
    final amountInSmallestUnit = (amount * 100).toInt();

    final options = {
      'key': PaymentConfig.razorpayKeyId,
      'amount': amountInSmallestUnit,
      'currency': currency.razorpayCurrency,
      'name': 'VP Nexus',
      'description': 'Order #$orderId',
      'order_id': orderId,
      'prefill': {
        'email': customerEmail,
        'contact': customerPhone,
      },
      'theme': {
        'color': '#1B5E20',
      },
      'notes': {
        'order_id': orderId,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      if (!_paymentCompleter!.isCompleted) {
        _paymentCompleter!.complete(PaymentResult(
          success: false,
          error: 'Failed to open payment: $e',
        ));
      }
    }

    return _paymentCompleter!.future;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Payment Success: ${response.paymentId}');
    if (!_paymentCompleter!.isCompleted) {
      _paymentCompleter!.complete(PaymentResult(
        success: true,
        paymentId: response.paymentId,
        orderId: response.orderId,
        signature: response.signature,
      ));
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Error: ${response.code} - ${response.message}');
    if (!_paymentCompleter!.isCompleted) {
      _paymentCompleter!.complete(PaymentResult(
        success: false,
        error: response.message ?? 'Payment failed',
        errorCode: response.code,
      ));
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
    if (!_paymentCompleter!.isCompleted) {
      _paymentCompleter!.complete(PaymentResult(
        success: false,
        error: 'External wallet not supported yet',
      ));
    }
  }
}

class PaymentResult {
  final bool success;
  final String? paymentId;
  final String? orderId;
  final String? signature;
  final String? error;
  final int? errorCode;

  const PaymentResult({
    required this.success,
    this.paymentId,
    this.orderId,
    this.signature,
    this.error,
    this.errorCode,
  });
}
