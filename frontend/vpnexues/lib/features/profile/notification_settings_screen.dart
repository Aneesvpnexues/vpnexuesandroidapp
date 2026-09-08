import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/features/notifications/providers/notification_provider.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _orderUpdates = true;
  bool _deliveryUpdates = true;
  bool _coupons = true;
  bool _promotions = false;
  bool _newArrivals = true;
  bool _priceAlerts = false;
  bool _weeklyDeals = true;
  bool _emailNotifications = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final provider = context.read<NotificationProvider>();
    await provider.loadSettings();
    final settings = provider.settings;
    if (settings.isNotEmpty) {
      setState(() {
        _orderUpdates = settings['orderUpdates'] ?? true;
        _deliveryUpdates = settings['deliveryUpdates'] ?? true;
        _coupons = settings['couponsDeals'] ?? true;
        _promotions = settings['promotions'] ?? false;
        _newArrivals = settings['newArrivals'] ?? true;
        _priceAlerts = settings['priceDropAlerts'] ?? false;
        _weeklyDeals = settings['weeklyDeals'] ?? true;
        _emailNotifications = settings['emailNotifications'] ?? false;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSettings() async {
    final provider = context.read<NotificationProvider>();
    await provider.updateSettings({
      'orderUpdates': _orderUpdates,
      'deliveryUpdates': _deliveryUpdates,
      'couponsDeals': _coupons,
      'promotions': _promotions,
      'newArrivals': _newArrivals,
      'priceDropAlerts': _priceAlerts,
      'weeklyDeals': _weeklyDeals,
      'emailNotifications': _emailNotifications,
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved!'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              if (_isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Order Notifications'),
                        const SizedBox(height: 12),
                        _buildToggleTile(
                          icon: Icons.shopping_bag_outlined,
                          title: 'Order Updates',
                          subtitle: 'Get notified about order status',
                          value: _orderUpdates,
                          onChanged: (v) {
                            setState(() => _orderUpdates = v);
                            _saveSettings();
                          },
                        ),
                        _buildToggleTile(
                          icon: Icons.local_shipping_outlined,
                          title: 'Delivery Updates',
                          subtitle: 'Real-time delivery tracking alerts',
                          value: _deliveryUpdates,
                          onChanged: (v) {
                            setState(() => _deliveryUpdates = v);
                            _saveSettings();
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Offers & Promotions'),
                        const SizedBox(height: 12),
                        _buildToggleTile(
                          icon: Icons.local_offer_outlined,
                          title: 'Coupons & Deals',
                          subtitle: 'Exclusive coupon codes and discounts',
                          value: _coupons,
                          onChanged: (v) {
                            setState(() => _coupons = v);
                            _saveSettings();
                          },
                        ),
                        _buildToggleTile(
                          icon: Icons.campaign_outlined,
                          title: 'Promotions',
                          subtitle: 'Sales, events and special offers',
                          value: _promotions,
                          onChanged: (v) {
                            setState(() => _promotions = v);
                            _saveSettings();
                          },
                        ),
                        _buildToggleTile(
                          icon: Icons.new_releases_outlined,
                          title: 'New Arrivals',
                          subtitle: 'Be first to try new products',
                          value: _newArrivals,
                          onChanged: (v) {
                            setState(() => _newArrivals = v);
                            _saveSettings();
                          },
                        ),
                        _buildToggleTile(
                          icon: Icons.price_change_outlined,
                          title: 'Price Drop Alerts',
                          subtitle: 'Get notified when prices fall',
                          value: _priceAlerts,
                          onChanged: (v) {
                            setState(() => _priceAlerts = v);
                            _saveSettings();
                          },
                        ),
                        _buildToggleTile(
                          icon: Icons.calendar_today_outlined,
                          title: 'Weekly Deals',
                          subtitle: 'Weekly curated deals and offers',
                          value: _weeklyDeals,
                          onChanged: (v) {
                            setState(() => _weeklyDeals = v);
                            _saveSettings();
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Channel'),
                        const SizedBox(height: 12),
                        _buildToggleTile(
                          icon: Icons.email_outlined,
                          title: 'Email Notifications',
                          subtitle: 'Receive updates via email',
                          value: _emailNotifications,
                          onChanged: (v) {
                            setState(() => _emailNotifications = v);
                            _saveSettings();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
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
              'Notification Settings',
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textColor(context),
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: value ? AppColors.lightGreen : Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: value ? AppColors.primary : Colors.grey,
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
                const SizedBox(height: 2),
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
