import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/core/services/api_service.dart';
import 'package:vpnexues_pvt/shared/widgets/product_image.dart';
import 'package:vpnexues_pvt/shared/localization/language_provider.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final ApiService _api = ApiService();
  Map<String, dynamic>? _order;
  bool _isLoading = true;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _loadOrder();
    _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _loadOrder();
    });
  }

  Future<void> _loadOrder() async {
    final order = await _api.getOrderById(widget.orderId);
    if (!mounted) return;
    setState(() {
      _order = order;
      _isLoading = false;
    });

    final status = _order?['status']?.toString() ?? '';
    if (status == 'delivered' || status == 'cancelled') {
      _pollTimer?.cancel();
    }
  }

  String _getTimeRemaining({required LanguageProvider lang}) {
    final estimatedStr = _order?['estimatedDelivery']?.toString();
    if (estimatedStr == null || estimatedStr.isEmpty) return '';

    try {
      final estimated = DateTime.parse(estimatedStr);
      final now = DateTime.now().toUtc();
      final diff = estimated.difference(now);
      final minutes = diff.inMinutes;

      if (minutes <= 0) return lang.t('orders_arriving_now');
      if (minutes <= 5) return lang.t('orders_arriving_now');
      if (minutes <= 20) return '$minutes min';
      return '$minutes min';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldColor(context),
        body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (_order == null) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldColor(context),
        body: Center(child: Text(lang.t('orders_not_found'))),
      );
    }

    final status = _order!['status']?.toString() ?? 'placed';
    final shortId = widget.orderId.length > 8
        ? widget.orderId.substring(widget.orderId.length - 8)
        : widget.orderId;
    final createdAt = _order!['createdAt']?.toString() ?? '';
    final totalAmount = (_order!['totalAmount'] as num?)?.toDouble() ?? 0;
    final paymentMethod = _order!['paymentMethod']?.toString() ?? 'N/A';
    final items = _order!['items'] as List<dynamic>? ?? [];
    final timeRemaining = _getTimeRemaining(lang: lang);
    final isCancelled = status == 'cancelled';
    final isDelivered = status == 'delivered';
    final canCancel = status == 'placed' || status == 'preparing';

    return Scaffold(
        backgroundColor: AppColors.scaffoldColor(context),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, shortId),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    children: [
                      if (!isCancelled && !isDelivered && timeRemaining.isNotEmpty)
                        _buildCountdownCard(timeRemaining, lang: lang),
                      if (!isCancelled && !isDelivered) ...[
                        const SizedBox(height: 16),
                        _buildProgressTracker(status, lang: lang),
                      ],
                      if (isCancelled)
                        _buildStatusBanner(lang.t('orders_order_cancelled'), Colors.red),
                      if (isDelivered)
                        _buildStatusBanner(lang.t('orders_order_delivered'), AppColors.primary),
                      const SizedBox(height: 16),
                      _buildTimeline(status, createdAt, lang: lang),
                      if (items.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildOrderItems(items, lang: lang),
                      ],
                      const SizedBox(height: 16),
                      _buildOrderDetails(totalAmount, paymentMethod, createdAt, lang: lang),
                    ],
                  ),
                ),
              ),
              if (canCancel) _buildCancelButton(lang: lang),
            ],
          ),
        ),
      );
  }

  Widget _buildHeader(BuildContext context, String shortId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
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
                color: AppColors.fieldFillColor(context),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textColor(context)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Order #ORD$shortId',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownCard(String timeRemaining, {required LanguageProvider lang}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0E5A35), Color(0xFF1B7A4A)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.access_time, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.t('orders_estimated_delivery'),
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  timeRemaining,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTracker(String status, {required LanguageProvider lang}) {
    final steps = [lang.t('orders_placed'), lang.t('orders_preparing'), lang.t('orders_out_delivery'), lang.t('orders_delivered')];
    final currentIndex = _statusIndex(status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final stepBefore = i ~/ 2;
            final isCompleted = stepBefore < currentIndex;
            return Expanded(
              child: Container(
                height: 3,
                color: isCompleted ? AppColors.primary : AppColors.borderGray,
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final isActive = stepIndex <= currentIndex;
          final isCurrent = stepIndex == currentIndex;

          return Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.cardColor(context),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive ? AppColors.primary : AppColors.borderGray,
                      width: 2,
                    ),
                  ),
                  child: isActive
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.borderGray,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 6),
                Text(
                  steps[stepIndex],
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? AppColors.textColor(context) : AppColors.textLightGray,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTimeline(String status, String createdAt, {required LanguageProvider lang}) {
    final steps = [
      {'label': lang.t('orders_placed'), 'status': 'placed', 'icon': Icons.receipt_long},
      {'label': lang.t('orders_preparing'), 'status': 'preparing', 'icon': Icons.inventory_2_outlined},
      {'label': lang.t('orders_out_delivery'), 'status': 'out_for_delivery', 'icon': Icons.local_shipping_outlined},
      {'label': lang.t('orders_delivered'), 'status': 'delivered', 'icon': Icons.check_circle_outline},
    ];

    final currentIdx = _statusIndex(status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.t('orders_order_progress'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor(context),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(steps.length, (i) {
            final step = steps[i];
            final isCompleted = i <= currentIdx;
            final isCurrent = i == currentIdx;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isCompleted ? AppColors.primary : AppColors.cardColor(context),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted ? AppColors.primary : AppColors.borderGray,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        step['icon'] as IconData,
                        color: isCompleted ? Colors.white : AppColors.borderGray,
                        size: 16,
                      ),
                    ),
                    if (i < steps.length - 1)
                      Container(
                        width: 2,
                        height: 32,
                        color: i < currentIdx ? AppColors.primary : AppColors.borderGray,
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['label'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                            color: isCompleted
                                ? AppColors.textColor(context)
                                : AppColors.textLightGray,
                          ),
                        ),
                        if (isCurrent)
                          Text(
                            lang.t('orders_in_progress'),
                            style: TextStyle(fontSize: 12, color: AppColors.textLightGray),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrderItems(List<dynamic> items, {required LanguageProvider lang}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.t('orders_order_items'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor(context),
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) {
            final name = item['name']?.toString() ?? '';
            final imageUrl = item['imageUrl']?.toString() ?? '';
            final qty = item['quantity'] ?? 1;
            final price = (item['currentPrice'] as num?)?.toDouble() ?? 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ProductImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: const Center(
                          child: Icon(Icons.eco, color: AppColors.textLightGray, size: 20),
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
                          name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Qty: $qty',
                          style: TextStyle(fontSize: 12, color: AppColors.textLightGray),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\u20B9${(price * qty).toInt()}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor(context),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(double totalAmount, String paymentMethod, String createdAt, {required LanguageProvider lang}) {
    final dateStr = createdAt.isNotEmpty ? _formatDate(createdAt) : '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.t('orders_order_details'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor(context),
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(lang.t('orders_order_id'), '#ORD${widget.orderId.length > 8 ? widget.orderId.substring(widget.orderId.length - 8) : widget.orderId}'),
          if (dateStr.isNotEmpty) _buildDetailRow(lang.t('orders_placed_on'), dateStr),
          _buildDetailRow(lang.t('orders_payment'), paymentMethod.replaceAll('_', ' ').toUpperCase()),
          const Divider(height: 20),
          _buildDetailRow(lang.t('cart_total_amount'), '\u20B9${totalAmount.toInt()}', isBold: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: AppColors.textLightGray)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: isBold ? AppColors.primary : AppColors.textColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            text.contains('Delivered') ? Icons.check_circle : Icons.cancel,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton({required LanguageProvider lang}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton(
          onPressed: () => _cancelOrder(lang: lang),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(
            lang.t('orders_cancel_order'),
            style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  Future<void> _cancelOrder({required LanguageProvider lang}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(lang.t('orders_cancel_confirm'), style: const TextStyle(fontWeight: FontWeight.w700)),
        content: Text(lang.t('orders_cancel_question')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(lang.t('common_cancel'), style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(lang.t('orders_yes_cancel'), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _api.cancelOrder(widget.orderId);
      _pollTimer?.cancel();
      _loadOrder();
    }
  }

  String _formatDate(String iso) {
    try {
      final date = DateTime.parse(iso);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }

  int _statusIndex(String status) {
    switch (status) {
      case 'placed':
        return 0;
      case 'preparing':
        return 1;
      case 'out_for_delivery':
        return 2;
      case 'delivered':
        return 3;
      default:
        return 0;
    }
  }
}
