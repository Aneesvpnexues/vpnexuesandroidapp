import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/features/cart/providers/cart_provider.dart';
import 'package:vpnexues_pvt/features/cart/providers/payment_method_provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/shared/widgets/product_image.dart';
import 'package:vpnexues_pvt/features/orders/order_confirmed_screen.dart';
import 'package:vpnexues_pvt/features/settings/settings_screen.dart';
import 'package:vpnexues_pvt/core/services/payment_service.dart';
import 'package:vpnexues_pvt/core/services/country_detection_service.dart';
import 'package:vpnexues_pvt/shared/providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    this.onNavigateToOrders,
    this.onNavigateToHome,
    this.couponCode,
    this.couponDiscount = 0,
  });

  final VoidCallback? onNavigateToOrders;
  final VoidCallback? onNavigateToHome;
  final String? couponCode;
  final double couponDiscount;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'card';
  bool _ordering = false;

  final PaymentService _paymentService = PaymentService();

  @override
  void initState() {
    super.initState();
    _paymentService.initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentMethodProvider>().loadPaymentMethods();
    });
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items.values.toList();
    final itemTotal = cart.totalPrice;
    const deliveryFee = 40.0;
    const deliveryDiscount = 40.0;
    final total = itemTotal + deliveryFee - deliveryDiscount;

    return Theme(
      data: Theme.of(context).copyWith(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        cardColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSecurityBanner(context),
                    const SizedBox(height: 20),
                    _buildOrderSummary(context, items),
                    const SizedBox(height: 20),
                    _buildPaymentMethod(context),
                    const SizedBox(height: 20),
                    _buildBillSummary(itemTotal, deliveryFee, deliveryDiscount, items.length),
                  ],
                ),
              ),
            ),
            _buildPlaceOrderButton(cart, total),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.arrow_back_ios_new,
                  size: 18, color: AppColors.textColor(context)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Payment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor(context),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.settings_outlined,
                  size: 18, color: AppColors.textColor(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FAF0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD0E8D0)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.verified_user, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Safe, secure & trustworthy',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor(context),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  '100% secure payments',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondaryColor(context),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Need help?',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor(context),
                ),
              ),
              const SizedBox(height: 1),
              GestureDetector(
                onTap: () => _showContactSupport(context),
                child: Text(
                  'Contact support',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor(context),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderColor(context)),
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                if (i > 0) const Divider(height: 20),
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ProductImage(
                          imageUrl: items[i].product.imageUrl,
                          fit: BoxFit.cover,
                          errorWidget: const Center(
                            child: Icon(Icons.image, color: AppColors.textLightGray, size: 24),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            items[i].product.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            items[i].product.weight,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondaryColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${(items[i].product.currentPrice * items[i].quantity).toInt()}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textColor(context),
                      ),
                    ),
                  ],
                ),
              ],
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total (${items.length} items)',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondaryColor(context),
                    ),
                  ),
                  Text(
                    '₹${items.fold<double>(0, (sum, item) => sum + item.product.currentPrice * item.quantity).toInt()}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(BuildContext context) {
    final savedMethods = context.watch<PaymentMethodProvider>().paymentMethods;
    final defaultMethod = context.watch<PaymentMethodProvider>().defaultPaymentMethod;

    final methods = [
      {'id': 'card', 'icon': Icons.credit_card_outlined, 'title': 'Credit / Debit card', 'subtitle': 'Visa, Mastercard, Rupay & more'},
      {'id': 'netbanking', 'icon': Icons.account_balance_outlined, 'title': 'Net Banking', 'subtitle': 'All major banks supported'},
      {'id': 'cod', 'icon': Icons.payments_outlined, 'title': 'Cash on Delivery', 'subtitle': 'Pay in cash upon delivery'},
    ];

    if (savedMethods.isNotEmpty && defaultMethod != null) {
      final type = defaultMethod['type'] ?? 'card';
      String title;
      String subtitle;
      IconData icon;

      switch (type) {
        case 'card':
          title = 'Card ending in ${defaultMethod['last4Digits'] ?? '****'}';
          subtitle = defaultMethod['cardHolderName'] ?? '';
          icon = Icons.credit_card_outlined;
          break;
        case 'upi':
          title = 'UPI';
          subtitle = defaultMethod['upiId'] ?? '';
          icon = Icons.phone_android_outlined;
          break;
        case 'netbanking':
          title = 'Net Banking';
          subtitle = defaultMethod['bankName'] ?? '';
          icon = Icons.account_balance_outlined;
          break;
        default:
          title = 'Cash on Delivery';
          subtitle = 'Pay on delivery';
          icon = Icons.payments_outlined;
      }

      methods.insert(0, {
        'id': 'saved_${defaultMethod['id']}',
        'icon': icon,
        'title': title,
        'subtitle': subtitle,
      });

      if (_selectedMethod == 'card') {
        _selectedMethod = 'saved_${defaultMethod['id']}';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor(context),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderColor(context)),
          ),
          child: Column(
            children: [
              for (int i = 0; i < methods.length; i++) ...[
                if (i > 0)
                  Divider(height: 1, color: AppColors.borderColor(context)),
                _buildPaymentOption(
                  context,
                  id: methods[i]['id'] as String,
                  icon: methods[i]['icon'] as IconData,
                  title: methods[i]['title'] as String,
                  subtitle: methods[i]['subtitle'] as String,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required String id,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.borderColor(context),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Container(
                      margin: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.lightGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor(context),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondaryColor(context),
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

  Widget _buildBillSummary(double itemTotal, double deliveryFee, double deliveryDiscount, int count) {
    final total = itemTotal + deliveryFee - deliveryDiscount;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Column(
        children: [
          _buildBillRow('Item Total ($count items)', '₹${itemTotal.toInt()}'),
          _buildBillRow('Delivery Fee', '₹${deliveryFee.toInt()}'),
          _buildBillRow('Delivery Discount', '-₹${deliveryDiscount.toInt()}'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textColor(context),
                ),
              ),
              Text(
                '₹${total.toInt()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondaryColor(context)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(CartProvider cart, double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: _ordering ? null : () => _placeOrder(cart, total),
        child: _ordering
            ? Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  ),
                ),
              )
            : Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0E5A35), Color(0xFF1B7A4A)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Place order',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.chevron_right, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _showContactSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Contact Support', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () => launchUrl(Uri.parse('tel:+919876543210')),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.phone, color: AppColors.primary, size: 20),
              ),
              title: const Text('Call Us', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('+91 98765 43210'),
            ),
            ListTile(
              onTap: () => launchUrl(Uri.parse('mailto:support@vpnexues.com')),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.email_outlined, color: AppColors.primary, size: 20),
              ),
              title: const Text('Email Us', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('support@vpnexues.com'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder(CartProvider cart, double total) async {
    setState(() => _ordering = true);

    String paymentMethod = _selectedMethod;
    if (_selectedMethod.startsWith('saved_')) {
      paymentMethod = 'saved_card';
    }

    // Check if this is an online payment (not COD)
    final isOnlinePayment = _selectedMethod != 'cod';

    if (isOnlinePayment) {
      // Open Razorpay checkout
      await _placeOnlineOrder(cart, total, paymentMethod);
    } else {
      // COD - place order directly
      await _placeCodOrder(cart, paymentMethod);
    }
  }

  Future<void> _placeOnlineOrder(CartProvider cart, double total, String paymentMethod) async {
    try {
      // Get user info for Razorpay prefill (before async gap)
      final authProvider = context.read<AuthProvider>();
      final customerEmail = authProvider.userEmail ?? '';
      final customerPhone = authProvider.userPhone ?? '';

      // Detect country for currency
      final country = await CountryDetectionService.detectCountry();
      final countryCode = country.countryCode;

      // Generate a temporary order ID for Razorpay
      final tempOrderId = 'order_${DateTime.now().millisecondsSinceEpoch}';

      // Open Razorpay checkout
      final result = await _paymentService.openCheckout(
        countryCode: countryCode,
        amount: total,
        orderId: tempOrderId,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
      );

      if (!mounted) return;

      if (result.success) {
        // Payment succeeded - place order with payment ID
        final orderResult = await cart.placeOrderWithResult(
          paymentMethod: paymentMethod,
          paymentId: result.paymentId,
          paymentStatus: 'completed',
        );

        if (!mounted) return;
        setState(() => _ordering = false);

        if (orderResult != null) {
          final orderId = orderResult['_id']?.toString() ?? orderResult['id']?.toString() ?? 'UNKNOWN';
          final totalAmount = (orderResult['totalAmount'] as num?)?.toDouble() ?? cart.totalPrice;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrderConfirmedScreen(
                orderId: orderId,
                totalAmount: totalAmount,
                paymentMethod: paymentMethod,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order failed after payment. Contact support.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Payment failed
        setState(() => _ordering = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${result.error ?? "Unknown error"}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _ordering = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _placeCodOrder(CartProvider cart, String paymentMethod) async {
    final result = await cart.placeOrderWithResult(
      paymentMethod: 'cash_on_delivery',
    );

    if (!mounted) return;
    setState(() => _ordering = false);

    if (result != null) {
      final orderId = result['_id']?.toString() ?? result['id']?.toString() ?? 'UNKNOWN';
      final totalAmount = (result['totalAmount'] as num?)?.toDouble() ?? cart.totalPrice;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmedScreen(
            orderId: orderId,
            totalAmount: totalAmount,
            paymentMethod: paymentMethod,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
