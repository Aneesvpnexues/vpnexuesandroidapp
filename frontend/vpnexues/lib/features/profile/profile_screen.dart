import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/core/services/api_service.dart';
import 'package:vpnexues_pvt/shared/providers/auth_provider.dart';
import 'package:vpnexues_pvt/shared/localization/language_provider.dart';
import 'package:vpnexues_pvt/features/settings/settings_screen.dart';
import '../address/addresses_screen.dart';
import '../support/support_screen.dart';
import 'payment_methods_screen.dart';
import 'notification_settings_screen.dart';
import 'refer_earn_screen.dart';
import 'language_screen.dart';
import 'about_vpnexues_screen.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onNavigateToOrders;
  final VoidCallback? onNavigateToHome;

  const ProfileScreen({super.key, this.onNavigateToOrders, this.onNavigateToHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildProfileCard(context),
                    const SizedBox(height: 24),
                    _buildMyOrdersSection(context),
                    const SizedBox(height: 24),
                    _buildAccountSection(context),
                    const SizedBox(height: 24),
                    _buildPreferencesSection(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title — Coming Soon'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final lang = context.watch<LanguageProvider>();
    final nameController = TextEditingController(text: auth.userName ?? '');
    final phoneController = TextEditingController(text: auth.userPhone ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          lang.t('profile_edit'),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: lang.t('profile_name'),
                hintText: lang.t('profile_name_hint'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: lang.t('profile_phone'),
                hintText: lang.t('profile_phone_hint'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.t('common_cancel'), style: TextStyle(color: AppColors.textLightGray, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(lang.t('profile_name_empty'))),
                );
                return;
              }
              Navigator.pop(ctx);
              final success = await auth.updateProfile(
                name: name.isNotEmpty ? name : null,
                phone: phone.isNotEmpty ? phone : null,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? lang.t('profile_updated') : lang.t('profile_update_failed')),
                    backgroundColor: success ? AppColors.primary : Colors.red,
                  ),
                );
              }
            },
            child: Text(lang.t('common_save'), style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  void _showCancelOrderDialog(BuildContext context) async {
    final lang = context.watch<LanguageProvider>();
    final apiService = ApiService();
    final orders = await apiService.getOrders();
    final activeOrders = orders
        .where((o) => o['status'] == 'placed' || o['status'] == 'preparing')
        .toList();

    if (!context.mounted) return;

    if (activeOrders.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(lang.t('profile_no_active_orders')),
          content: Text(lang.t('profile_no_active_orders_sub')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(lang.t('profile_ok'), style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          lang.t('orders_cancel_order'),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: activeOrders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final order = activeOrders[index];
              final orderId = order['_id']?.toString() ?? order['id']?.toString() ?? '';
              final totalAmount = (order['totalAmount'] as num?)?.toDouble() ?? 0;
              final items = order['items'] as List<dynamic>? ?? [];
              final createdAt = order['createdAt']?.toString() ?? '';

              final itemNames = items.map((i) => i['name']?.toString() ?? '').where((n) => n.isNotEmpty).toList();
              final displayNames = itemNames.length > 2
                  ? '${itemNames[0]}, ${itemNames[1]} +${itemNames.length - 2} more'
                  : itemNames.join(', ');

              String dateStr = '';
              if (createdAt.isNotEmpty) {
                try {
                  final date = DateTime.parse(createdAt);
                  final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                  dateStr = '${date.day} ${months[date.month - 1]} ${date.year}';
                } catch (_) {}
              }

              return GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  _showCancelConfirmDialog(context, orderId, displayNames);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderGray, width: 1),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: items.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  items[0]['imageUrl']?.toString() ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    color: AppColors.lightGreen,
                                    child: const Icon(Icons.shopping_bag, color: AppColors.primary, size: 20),
                                  ),
                                ),
                              )
                            : Container(
                                color: AppColors.lightGreen,
                                child: const Icon(Icons.shopping_bag, color: AppColors.primary, size: 20),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayNames.isNotEmpty ? displayNames : 'Order',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textColor(context)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${items.length} item${items.length == 1 ? '' : 's'}',
                                  style: TextStyle(fontSize: 11, color: AppColors.textLightGray),
                                ),
                                if (dateStr.isNotEmpty) ...[
                                  Text('  •  ', style: TextStyle(fontSize: 11, color: AppColors.textLightGray)),
                                  Text(dateStr, style: TextStyle(fontSize: 11, color: AppColors.textLightGray)),
                                ],
                                Text('  •  ', style: TextStyle(fontSize: 11, color: AppColors.textLightGray)),
                                Text(
                                  '₹${totalAmount.toInt()}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, size: 20, color: AppColors.textLightGray),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.t('profile_close'), style: TextStyle(color: AppColors.textLightGray)),
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmDialog(BuildContext context, String orderId, String orderLabel) {
    final lang = context.watch<LanguageProvider>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFF9E6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          lang.t('orders_cancel_order'),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black),
        ),
        content: Text(
          '${lang.t("profile_cancel_question")}\n$orderLabel',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.t('common_cancel'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final apiService = ApiService();
              final result = await apiService.cancelOrder(orderId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      result != null
                          ? lang.t('profile_cancel_success')
                          : lang.t('profile_cancel_failed'),
                    ),
                    backgroundColor: result != null ? AppColors.primary : Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
            child: Text(lang.t('common_confirm'), style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (onNavigateToHome != null) {
                onNavigateToHome!();
              } else {
                Navigator.of(context).maybePop();
              }
            },
            child: Icon(Icons.arrow_back_ios_new,
                size: 20, color: AppColors.textColor(context)),
          ),
          Expanded(
            child: Center(
              child: Text(
                lang.t('profile_title'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor(context),
                ),
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
            child: Icon(Icons.settings_outlined,
                size: 22, color: AppColors.textColor(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final name = auth.userName ?? 'User';
    final email = auth.userEmail ?? '';
    final phone = auth.userPhone ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E3B1F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Leaf decoration right side
          Positioned(
            right: -10,
            top: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.15,
              child: Icon(Icons.eco, size: 120, color: Colors.white.withValues(alpha: 0.5)),
            ),
          ),
          Row(
            children: [
              _buildAvatar(context, initial),
              const SizedBox(width: 14),
              Expanded(child: _buildUserInfo(context, name, email, phone)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String initial) {
    return GestureDetector(
      onTap: () => _showEditProfileDialog(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFD9A441),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0E3B1F), width: 2),
              ),
              child: const Icon(Icons.check, size: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, String name, String email, String phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.mail_outline, size: 11, color: Colors.white70),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ),
          ],
        ),
        if (phone.isNotEmpty) ...[
          const SizedBox(height: 3),
          Row(
            children: [
              const Icon(Icons.phone_outlined, size: 11, color: Colors.white70),
              const SizedBox(width: 4),
              Text(phone, style: const TextStyle(fontSize: 11, color: Colors.white70)),
            ],
          ),
        ],
      ],
    );
  }

  // _buildVegetableImage removed - new banner uses dark green with leaf decoration

  Widget _buildMyOrdersSection(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lang.t('profile_my_orders'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor(context),
              ),
            ),
            GestureDetector(
              onTap: () => onNavigateToOrders?.call(),
              child: Row(
                children: [
                  Text(
                    lang.t('home_view_all'),
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textLightGray,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.chevron_right, size: 18, color: AppColors.textLightGray),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.cardColor(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderGray, width: 1),
            boxShadow: const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _OrderStatusItem(
                icon: Icons.account_balance_wallet_outlined,
                label: lang.t('profile_to_pay'),
                onTap: () => onNavigateToOrders?.call(),
              ),
              _OrderStatusItem(
                icon: Icons.access_time_outlined,
                label: lang.t('profile_processing'),
                onTap: () => onNavigateToOrders?.call(),
              ),
              _OrderStatusItem(
                icon: Icons.local_shipping_outlined,
                label: lang.t('profile_delivered'),
                onTap: () => onNavigateToOrders?.call(),
              ),
              _OrderStatusItem(
                icon: Icons.cancel_outlined,
                label: lang.t('profile_cancelled'),
                onTap: () => _showCancelOrderDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final items = [
      _ProfileMenuItem(
          icon: Icons.person_outline, title: lang.t('profile_personal_info'),
          onTap: () => _showEditProfileDialog(context)),
      _ProfileMenuItem(icon: Icons.location_on_outlined, title: lang.t('profile_addresses'), onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddressesScreen()));
      }),
      _ProfileMenuItem(icon: Icons.payment_outlined, title: lang.t('profile_payment'), onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()));
      }),
      _ProfileMenuItem(
          icon: Icons.card_giftcard_outlined, title: lang.t('profile_refer'), onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ReferEarnScreen()));
      }),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.t('profile_account'),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor(context),
          ),
        ),
        const SizedBox(height: 12),
        _buildMenuCard(context, items),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final items = [
      _ProfileMenuItem(
          icon: Icons.notifications_outlined,
          title: langProvider.t('profile_notifications'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
            );
          }),
      _ProfileMenuItem(
          icon: Icons.language_outlined,
          title: langProvider.t('profile_language'),
          trailing: langProvider.languageName,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LanguageScreen()),
            );
          }),
      _ProfileMenuItem(
        icon: Icons.headset_mic_outlined,
        title: langProvider.t('profile_help'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SupportScreen()),
          );
        },
      ),
      _ProfileMenuItem(
          icon: Icons.info_outline, title: langProvider.t('profile_about'),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutVpnexuesScreen()))),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          langProvider.t('profile_preferences'),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor(context),
          ),
        ),
        const SizedBox(height: 12),
        _buildMenuCard(context, items),
      ],
    );
  }

  Widget _buildMenuCard(BuildContext context, List<_ProfileMenuItem> items) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _buildMenuRow(context, items[i]),
            if (i < items.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.borderGray,
                indent: 60,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuRow(BuildContext context, _ProfileMenuItem item) {
    return GestureDetector(
      onTap: item.onTap ?? () => _showSnackBar(context, item.title),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor(context),
                ),
              ),
            ),
            if (item.trailing != null) ...[
              Text(
                item.trailing!,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textLightGray,
                ),
              ),
              const SizedBox(width: 4),
            ],
            Icon(Icons.chevron_right, size: 18, color: AppColors.textLightGray),
          ],
        ),
      ),
    );
  }
}

class _OrderStatusItem extends StatelessWidget {
  const _OrderStatusItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback? onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });
}
