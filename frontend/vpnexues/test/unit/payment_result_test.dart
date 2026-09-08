import 'package:flutter_test/flutter_test.dart';
import 'package:vpnexues_pvt/core/services/payment_service.dart';

void main() {
  group('PaymentResult', () {
    test('success result has paymentId', () {
      const result = PaymentResult(
        success: true,
        paymentId: 'pay_abc123',
        orderId: 'order_xyz',
        signature: 'sig_123',
      );

      expect(result.success, true);
      expect(result.paymentId, 'pay_abc123');
      expect(result.orderId, 'order_xyz');
      expect(result.signature, 'sig_123');
      expect(result.error, null);
    });

    test('failure result has error', () {
      const result = PaymentResult(
        success: false,
        error: 'Payment cancelled',
        errorCode: 0,
      );

      expect(result.success, false);
      expect(result.error, 'Payment cancelled');
      expect(result.errorCode, 0);
      expect(result.paymentId, null);
    });

    test('empty result', () {
      const result = PaymentResult(success: false);

      expect(result.success, false);
      expect(result.paymentId, null);
      expect(result.error, null);
    });
  });
}
