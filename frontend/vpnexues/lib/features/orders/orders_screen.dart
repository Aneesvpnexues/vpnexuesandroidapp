import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/services/api_service.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/features/settings/settings_screen.dart';
import 'package:vpnexues_pvt/features/orders/order_tracking_screen.dart';
import 'package:vpnexues_pvt/shared/localization/language_provider.dart';

class OrdersScreen extends StatefulWidget {
  final VoidCallback? onBackHome;
  const OrdersScreen({super.key, this.onBackHome});

  @override
  OrdersScreenState createState() => OrdersScreenState();
}

class OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;
  late TabController _tabController;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadOrders();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _loadOrders();
    });
  }

  void refresh() {
    _loadOrders();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final orders = await _apiService.getOrders();
      if (mounted) {
        setState(() {
          _orders = orders;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _orders = [];
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> get _activeOrders =>
      _orders.where((o) {
        final status = o['status']?.toString().toLowerCase() ?? '';
        return status != 'delivered' && status != 'cancelled';
      }).toList();

  List<Map<String, dynamic>> get _pastOrders =>
      _orders.where((o) {
        final status = o['status']?.toString().toLowerCase() ?? '';
        return status == 'delivered' || status == 'cancelled';
      }).toList();

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(lang),
            _buildTabs(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOrderList(_activeOrders, isEmpty: _activeOrders.isEmpty, lang: lang),
                        _buildOrderList(_pastOrders, isEmpty: _pastOrders.isEmpty, lang: lang),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(LanguageProvider lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => widget.onBackHome?.call(),
            child: Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textColor(context)),
          ),
          Expanded(
            child: Center(
              child: Text(
                lang.t('orders_title'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textColor(context)),
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
            child: Icon(Icons.settings_outlined, size: 22, color: AppColors.textColor(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderGray, width: 1)),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textLightGray,
        labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        tabs: [
          Tab(text: 'Active Orders (${_activeOrders.length})'),
          Tab(text: 'Past Orders'),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders, {required bool isEmpty, required LanguageProvider lang}) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isEmpty ? Icons.local_shipping_outlined : Icons.receipt_long_outlined,
              size: 70,
              color: AppColors.textLightGray,
            ),
            const SizedBox(height: 16),
            Text(
              isEmpty ? lang.t('orders_empty') : lang.t('orders_empty'),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textColor(context)),
            ),
            const SizedBox(height: 4),
            Text(
              lang.t('orders_start_shopping'),
              style: const TextStyle(fontSize: 13, color: AppColors.textLightGray),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 90),
      itemCount: orders.length,
      itemBuilder: (context, index) => _buildOrderCard(orders[index], lang: lang),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, {required LanguageProvider lang}) {
    final orderId = order['_id']?.toString() ?? order['id']?.toString() ?? '';
    final status = order['status']?.toString() ?? 'placed';
    final createdAt = order['createdAt']?.toString() ?? '';
    final totalAmount = (order['totalAmount'] as num?)?.toDouble() ?? 0;
    final paymentMethod = order['paymentMethod']?.toString() ?? 'N/A';
    final deliveryFee = (order['deliveryFee'] as num?)?.toDouble() ?? 0;
    final items = order['items'] as List<dynamic>? ?? [];

    final shortId = orderId.length > 8 ? orderId.substring(orderId.length - 8) : orderId;
    final dateStr = createdAt.isNotEmpty ? _formatDate(createdAt) : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNotificationBanner(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order: #ORD$shortId',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textColor(context)),
                    ),
                    _buildStatusBadge(status),
                  ],
                ),
                if (dateStr.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Placed on $dateStr',
                    style: TextStyle(fontSize: 12, color: AppColors.textLightGray),
                  ),
                ],
                const SizedBox(height: 16),
                _buildProgressTracker(status),
                const SizedBox(height: 16),
                _buildDeliveryEstimate(status, order, lang: lang),
                if (items.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    '${items.length} item${items.length == 1 ? '' : 's'}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textColor(context)),
                  ),
                  const SizedBox(height: 10),
                  _buildItemsRow(items),
                ],
                const SizedBox(height: 12),
                Divider(color: AppColors.borderGray, height: 1),
                const SizedBox(height: 12),
                _buildInfoRow(deliveryFee, paymentMethod, totalAmount, lang: lang),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping_outlined, color: AppColors.primary, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "We'll notify you when your order is out for delivery",
              style: TextStyle(fontSize: 13, color: AppColors.textLightGray, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final label = _statusLabel(status);
    final bgColor = AppColors.lightGreen;
    final dotColor = AppColors.primary;
    final textColor = AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTracker(String status) {
    final steps = ['Order Placed', 'Preparing', 'Out for Delivery', 'Delivered'];
    final currentIndex = _statusIndex(status);

    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final stepBefore = i ~/ 2;
          final isCompleted = stepBefore < currentIndex;
          return Expanded(
            child: Container(
              height: 2,
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
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.cardColor(context),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.borderGray,
                    width: 2,
                  ),
                ),
                child: isActive
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (isCurrent)
                Text(
                  'in progress',
                  style: TextStyle(fontSize: 8, color: AppColors.textLightGray),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDeliveryEstimate(String status, Map<String, dynamic> order, {required LanguageProvider lang}) {
    final estimatedStr = order['estimatedDelivery']?.toString();
    String timeText = '30 min';

    if (estimatedStr != null && estimatedStr.isNotEmpty) {
      try {
        final estimated = DateTime.parse(estimatedStr);
        final now = DateTime.now().toUtc();
        final diff = estimated.difference(now);
        final minutes = diff.inMinutes;
        if (minutes <= 0 || minutes <= 5) {
          timeText = 'Arriving now';
        } else {
          timeText = '$minutes min';
        }
      } catch (_) {
        timeText = '30 min';
      }
    }

    final isDelivered = status == 'delivered';
    final isCancelled = status == 'cancelled';

    if (isDelivered) {
      timeText = 'Delivered';
    } else if (isCancelled) {
      timeText = 'Cancelled';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCancelled ? Colors.red.withValues(alpha: 0.05) : AppColors.lightGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isCancelled
                ? Icons.cancel_outlined
                : isDelivered
                    ? Icons.check_circle_outline
                    : Icons.access_time,
            color: isCancelled ? Colors.red : AppColors.primary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCancelled
                      ? 'Order Cancelled'
                      : isDelivered
                          ? 'Order Delivered'
                          : 'Arriving in',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textColor(context)),
                ),
                const SizedBox(height: 2),
                Text(
                  timeText,
                  style: TextStyle(fontSize: 12, color: AppColors.textLightGray),
                ),
              ],
            ),
          ),
          if (!isCancelled && !isDelivered)
            GestureDetector(
              onTap: () {
                final orderId = order['_id']?.toString() ?? order['id']?.toString() ?? '';
                if (orderId.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderTrackingScreen(orderId: orderId)),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.cardColor(context),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderGray, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_outlined, size: 16, color: AppColors.textColor(context)),
                    const SizedBox(width: 4),
                    Text(
                      lang.t('orders_track'),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textColor(context)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItemsRow(List<dynamic> items) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = items[index];
          final imageUrl = item['imageUrl']?.toString() ?? '';
          final name = item['name']?.toString() ?? '';

          return Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.fieldFillColor(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl.startsWith('http')
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _buildPlaceholder(name),
                        )
                      : imageUrl.startsWith('assets/')
                          ? Image.asset(
                              imageUrl,
                          fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => _buildPlaceholder(name),
                            )
                          : _buildPlaceholder(name),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getWeight(item),
                    style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder(String name) {
    return Container(
      color: AppColors.fieldFillColor(context),
      child: Center(
        child: Icon(
          name.toLowerCase().contains('milk') || name.toLowerCase().contains('juice')
              ? Icons.local_drink_outlined
              : Icons.eco,
          color: AppColors.textLightGray,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildInfoRow(double deliveryFee, String paymentMethod, double totalAmount, {required LanguageProvider lang}) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoItem(Icons.local_shipping_outlined, lang.t('delivery_title'), '(Home)'),
        ),
        Container(width: 1, height: 40, color: AppColors.borderGray),
        Expanded(
          child: _buildInfoItem(Icons.payment_outlined, lang.t('orders_payment'), paymentMethod.replaceAll('_', ' ').toUpperCase()),
        ),
        Container(width: 1, height: 40, color: AppColors.borderGray),
        Expanded(
          child: Column(
            children: [
              Icon(Icons.currency_rupee, size: 18, color: AppColors.textColor(context)),
              const SizedBox(height: 2),
              Text(
                '₹${totalAmount.toInt()}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColors.textColor(context)),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppColors.textLightGray),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textColor(context)),
        ),
      ],
    );
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

  String _statusLabel(String status) {
    switch (status) {
      case 'placed':
        return 'Placed';
      case 'preparing':
        return 'Preparing';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status[0].toUpperCase() + status.substring(1);
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

  String _getWeight(dynamic item) {
    final weight = item['weight']?.toString();
    if (weight != null && weight.isNotEmpty) return weight;
    final qty = item['quantity'];
    return '${qty ?? 1}x';
  }
}
