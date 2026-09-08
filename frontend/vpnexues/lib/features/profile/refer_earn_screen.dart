import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';

class ReferEarnScreen extends StatelessWidget {
  const ReferEarnScreen({super.key});

  static const String _referralCode = 'VPN2026';
  static const String _referralLink = 'https://vpnexues.com/refer/VPN2026';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  children: [
                    _buildRewardCard(context),
                    const SizedBox(height: 24),
                    _buildHowItWorks(context),
                    const SizedBox(height: 24),
                    _buildReferralCode(context),
                    const SizedBox(height: 16),
                    _buildShareButtons(context),
                    const SizedBox(height: 24),
                    _buildTerms(context),
                  ],
                ),
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
              'Refer & Earn',
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

  Widget _buildRewardCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0E5A35), Color(0xFF1B7A4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.card_giftcard, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          const Text(
            'Earn Rs. 200',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'for every friend you refer!',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Your friend gets Rs. 100 off on first order',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorks(BuildContext context) {
    final steps = [
      {'icon': Icons.share_outlined, 'title': 'Share Code', 'desc': 'Share your referral code with friends'},
      {'icon': Icons.person_add_outlined, 'title': 'Friend Signs Up', 'desc': 'Your friend creates an account'},
      {'icon': Icons.shopping_cart_outlined, 'title': 'First Order', 'desc': 'Friend places their first order'},
      {'icon': Icons.monetization_on_outlined, 'title': 'Earn Rewards', 'desc': 'Both of you get Rs. 200 credit'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How It Works',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor(context),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardColor(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderColor(context)),
          ),
          child: Column(
            children: [
              for (int i = 0; i < steps.length; i++) ...[
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(steps[i]['icon'] as IconData,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            steps[i]['title'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor(context),
                            ),
                          ),
                          Text(
                            steps[i]['desc'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondaryColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
                if (i < steps.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        Container(
                          width: 1,
                          height: 16,
                          color: AppColors.borderColor(context),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReferralCode(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Referral Code',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor(context),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            Clipboard.setData(const ClipboardData(text: _referralCode));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Referral code copied!'),
                backgroundColor: AppColors.primary,
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.cardColor(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _referralCode,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.copy, color: AppColors.primary, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShareButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildShareButton(
            context,
            icon: Icons.share,
            label: 'Share',
            color: AppColors.primary,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share feature coming soon!'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildShareButton(
            context,
            icon: Icons.copy,
            label: 'Copy Link',
            color: const Color(0xFF25D366),
            onTap: () {
              Clipboard.setData(const ClipboardData(text: _referralLink));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Referral link copied!'),
                  backgroundColor: Color(0xFF25D366),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShareButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTerms(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Referral rewards are credited after your friend completes their first order (minimum Rs. 500). Maximum 10 referrals per month.',
        style: TextStyle(
          fontSize: 12,
          height: 1.5,
          color: AppColors.textSecondaryColor(context),
        ),
      ),
    );
  }
}
