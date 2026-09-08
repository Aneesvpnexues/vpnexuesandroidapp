import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/features/navigation/main_navigation_screen.dart';
import 'package:vpnexues_pvt/shared/localization/language_provider.dart';

class OrderConfirmedScreen extends StatefulWidget {
  final String orderId;
  final double totalAmount;
  final String paymentMethod;

  const OrderConfirmedScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.paymentMethod,
  });

  @override
  State<OrderConfirmedScreen> createState() => _OrderConfirmedScreenState();
}

class _OrderConfirmedScreenState extends State<OrderConfirmedScreen> {
  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final shortId = widget.orderId.length > 8
        ? widget.orderId.substring(widget.orderId.length - 8)
        : widget.orderId;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.lightGreen,
              AppColors.scaffoldColor(context),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const MainNavigationScreen(initialTab: 0),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildScooterIcon(),
                      const SizedBox(height: 24),
                      Text(
                        lang.t('order_confirmed'),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Your fresh basket has been confirmed and our pickers are getting ready. We\'ll keep you posted every step of this way.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textLightGray,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildOrderDetailsCard(shortId, lang: lang),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              _buildButtons(lang: lang),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScooterIcon() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 4),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/scooty.jpg',
          width: 140,
          height: 140,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildOrderDetailsCard(String shortId, {required LanguageProvider lang}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor(context), width: 1),
      ),
      child: Column(
        children: [
          _buildDetailRow(lang.t('orders_order_id'), '#ORD$shortId'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: DottedDivider(),
          ),
          _buildDetailRow(lang.t('order_amount_paid'), '₹${widget.totalAmount.toInt()}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: DottedDivider(),
          ),
          _buildDetailRow(
            lang.t('order_payment_method'),
            widget.paymentMethod.replaceAll('_', ' ').split(' ').map(
              (w) => w[0].toUpperCase() + w.substring(1),
            ).join(' '),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textLightGray,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor(context),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons({required LanguageProvider lang}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const MainNavigationScreen(initialTab: 3),
                  ),
                  (route) => false,
                );
              },
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lang.t('orders_track'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const MainNavigationScreen(initialTab: 0),
                  ),
                  (route) => false,
                );
              },
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.cardColor(context),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lang.t('order_back_home'),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: AppColors.primary, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DottedDivider extends StatelessWidget {
  const DottedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashWidth = 6.0;
        final dashSpace = 4.0;
        final dashCount = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: 1,
              color: AppColors.borderGray,
            );
          }),
        );
      },
    );
  }
}
