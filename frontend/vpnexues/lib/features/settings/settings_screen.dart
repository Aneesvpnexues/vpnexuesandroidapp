import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/shared/providers/auth_provider.dart';
import 'package:vpnexues_pvt/shared/providers/theme_provider.dart';
import 'package:vpnexues_pvt/shared/localization/language_provider.dart';
import '../address/addresses_screen.dart';
import '../support/support_screen.dart';
import '../profile/language_screen.dart';
import '../profile/about_vpnexues_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final lang = context.watch<LanguageProvider>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildSection(context, lang.t('settings_account'), [
                      _SettingsItem(
                        icon: Icons.person_outline,
                        title: lang.t('profile_personal_info'),
                        onTap: () => _showEditProfileDialog(context),
                      ),
                      _SettingsItem(
                        icon: Icons.location_on_outlined,
                        title: lang.t('profile_addresses'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddressesScreen(),
                            ),
                          );
                        },
                      ),
                      _SettingsItem(
                        icon: Icons.payment_outlined,
                        title: lang.t('profile_payment'),
                        onTap: () => _showComingSoon(context, 'Payment Methods'),
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection(context, lang.t('settings_preferences'), [
                      _SettingsSwitch(
                        icon: Icons.notifications_outlined,
                        title: lang.t('settings_notifications'),
                        value: _notificationsEnabled,
                        onChanged: (val) {
                          setState(() => _notificationsEnabled = val);
                        },
                      ),
                      _SettingsItem(
                        icon: Icons.language_outlined,
                        title: lang.t('settings_language'),
                        trailing: lang.languageName,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LanguageScreen()),
                          );
                        },
                      ),
                      _SettingsSwitch(
                        icon: Icons.dark_mode_outlined,
                        title: lang.t('settings_dark_mode'),
                        value: themeProvider.isDark,
                        onChanged: (_) {
                          themeProvider.toggleTheme();
                        },
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection(context, lang.t('settings_support'), [
                      _SettingsItem(
                        icon: Icons.headset_mic_outlined,
                        title: lang.t('profile_help'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SupportScreen()),
                          );
                        },
                      ),
                      _SettingsItem(
                        icon: Icons.info_outline,
                        title: lang.t('profile_about'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AboutVpnexuesScreen()),
                          );
                        },
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSection(context, lang.t('settings_account'), [
                      _SettingsItem(
                        icon: Icons.logout,
                        title: lang.t('settings_logout'),
                        iconColor: Colors.red,
                        titleColor: Colors.red,
                        onTap: () => _showLogoutDialog(context),
                      ),
                    ]),
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

  Widget _buildHeader() {
    final lang = context.watch<LanguageProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Icon(Icons.arrow_back_ios_new,
                size: 20, color: AppColors.textColor(context)),
          ),
          Expanded(
            child: Center(
              child: Text(
                lang.t('settings_title'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor(context),
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor(context),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardColor(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderColor(context), width: 1),
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
                items[i],
                if (i < items.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.borderColor(context),
                    indent: 60,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title — Coming Soon', style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final nameController = TextEditingController(text: auth.userName ?? '');
    final phoneController = TextEditingController(text: auth.userPhone ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textColor(context)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone',
                hintText: 'Enter your phone number',
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
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondaryColor(context))),
          ),
          TextButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Name cannot be empty')),
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
                    content: Text(success ? 'Profile updated!' : 'Failed to update profile'),
                    backgroundColor: success ? AppColors.primary : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Save', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textColor(context)),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondaryColor(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondaryColor(context))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final auth = context.read<AuthProvider>();
              await auth.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor != null ? iconColor!.withValues(alpha: 0.1) : AppColors.lightGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor ?? AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: titleColor ?? AppColors.textColor(context),
                ),
              ),
            ),
            if (trailing != null) ...[
              Text(
                trailing!,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondaryColor(context),
                ),
              ),
              const SizedBox(width: 4),
            ],
            Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondaryColor(context)),
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.lightGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor(context),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
