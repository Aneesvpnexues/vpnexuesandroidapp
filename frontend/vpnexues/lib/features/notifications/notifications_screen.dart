import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/features/notifications/providers/notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Consumer<NotificationProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }

                  if (provider.notifications.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildNotificationList(provider);
                },
              ),
            ),
          ],
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
              'Notifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor(context),
              ),
            ),
          ),
          if (context.read<NotificationProvider>().unreadCount > 0)
            TextButton(
              onPressed: () => context.read<NotificationProvider>().markAllAsRead(),
              child: const Text(
                'Read All',
                style: TextStyle(color: AppColors.primary, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your order updates and offers will appear here',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(NotificationProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.loadNotifications(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: provider.notifications.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final notification = provider.notifications[index];
          final isRead = notification['read'] == true;
          return _buildNotificationTile(context, provider, notification, isRead);
        },
      ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context,
    NotificationProvider provider,
    Map<String, dynamic> notification,
    bool isRead,
  ) {
    final type = notification['type'] ?? 'general';
    IconData icon;
    Color iconColor;

    switch (type) {
      case 'order':
        icon = Icons.shopping_bag_outlined;
        iconColor = Colors.blue;
        break;
      case 'delivery':
        icon = Icons.local_shipping_outlined;
        iconColor = Colors.orange;
        break;
      case 'offer':
        icon = Icons.local_offer_outlined;
        iconColor = Colors.green;
        break;
      default:
        icon = Icons.notifications_outlined;
        iconColor = AppColors.primary;
    }

    return Dismissible(
      key: Key(notification['id'] ?? ''),
      onDismissed: (_) => provider.deleteNotification(notification['id']),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () {
          if (!isRead) {
            provider.markAsRead(notification['id']);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isRead ? Colors.white : AppColors.lightGreen.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isRead ? AppColors.borderColor(context) : AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                              color: AppColors.textColor(context),
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondaryColor(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatTime(notification['createdAt']),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String? isoString) {
    if (isoString == null) return '';
    try {
      final date = DateTime.parse(isoString);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }
}
