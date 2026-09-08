import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/features/cart/providers/payment_method_provider.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _selectedType = 'cash_on_delivery';
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _upiController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentMethodProvider>().loadPaymentMethods();
    });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _upiController.dispose();
    _bankController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<PaymentMethodProvider>(
                      builder: (context, provider, child) {
                        if (provider.paymentMethods.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Saved Payment Methods',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColor(context),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...provider.paymentMethods.map((method) =>
                                _buildSavedMethodTile(context, provider, method)),
                              const SizedBox(height: 24),
                              Text(
                                'Add New Payment Method',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColor(context),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    Text(
                      'Select Payment Method',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPaymentOption(
                      context,
                      id: 'cash_on_delivery',
                      icon: Icons.money_outlined,
                      title: 'Cash on Delivery',
                      subtitle: 'Pay when your order arrives',
                    ),
                    const SizedBox(height: 12),
                    _buildPaymentOption(
                      context,
                      id: 'card',
                      icon: Icons.credit_card_outlined,
                      title: 'Credit / Debit Card',
                      subtitle: 'Visa, Mastercard, RuPay',
                    ),
                    if (_selectedType == 'card') ...[
                      const SizedBox(height: 12),
                      _buildCardForm(),
                    ],
                    const SizedBox(height: 12),
                    _buildPaymentOption(
                      context,
                      id: 'upi',
                      icon: Icons.phone_android_outlined,
                      title: 'UPI Payment',
                      subtitle: 'Google Pay, PhonePe, Paytm',
                    ),
                    if (_selectedType == 'upi') ...[
                      const SizedBox(height: 12),
                      _buildUpiForm(),
                    ],
                    const SizedBox(height: 12),
                    _buildPaymentOption(
                      context,
                      id: 'netbanking',
                      icon: Icons.account_balance_outlined,
                      title: 'Net Banking',
                      subtitle: 'All major banks supported',
                    ),
                    if (_selectedType == 'netbanking') ...[
                      const SizedBox(height: 12),
                      _buildNetBankingForm(),
                    ],
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lock_outline, color: AppColors.primary, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'All transactions are 100% secure and encrypted',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textColor(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedMethodTile(BuildContext context, PaymentMethodProvider provider, Map<String, dynamic> method) {
    final isDefault = method['default'] == true;
    final type = method['type'] ?? 'card';
    IconData icon;
    String title;
    String subtitle;

    switch (type) {
      case 'card':
        icon = Icons.credit_card_outlined;
        title = 'Card ending in ${method['last4Digits'] ?? '****'}';
        subtitle = method['cardHolderName'] ?? '';
        break;
      case 'upi':
        icon = Icons.phone_android_outlined;
        title = 'UPI';
        subtitle = method['upiId'] ?? '';
        break;
      case 'netbanking':
        icon = Icons.account_balance_outlined;
        title = 'Net Banking';
        subtitle = method['bankName'] ?? '';
        break;
      default:
        icon = Icons.money_outlined;
        title = 'Cash on Delivery';
        subtitle = 'Pay on delivery';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDefault ? AppColors.lightGreen.withValues(alpha: 0.3) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDefault ? AppColors.primary : AppColors.borderColor(context),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
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
          if (isDefault)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Default',
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'default') {
                await provider.setDefault(method['id']);
              } else if (value == 'delete') {
                await provider.deletePaymentMethod(method['id']);
              }
            },
            itemBuilder: (context) => [
              if (!isDefault)
                const PopupMenuItem(value: 'default', child: Text('Set as Default')),
              const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Column(
        children: [
          _buildTextField(_cardNumberController, 'Card Number', Icons.credit_card, keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          _buildTextField(_cardHolderController, 'Card Holder Name', Icons.person_outline),
          const SizedBox(height: 12),
          _buildTextField(_expiryController, 'Expiry (MM/YY)', Icons.calendar_today, keyboardType: TextInputType.datetime),
        ],
      ),
    );
  }

  Widget _buildUpiForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: _buildTextField(_upiController, 'UPI ID (e.g., name@upi)', Icons.phone_android),
    );
  }

  Widget _buildNetBankingForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: _buildTextField(_bankController, 'Bank Name', Icons.account_balance),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildHeader() {
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
              'Payment Methods',
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

  Widget _buildPaymentOption(
    BuildContext context, {
    required String id,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedType == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderColor(context),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.lightGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
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
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Consumer<PaymentMethodProvider>(
      builder: (context, provider, child) {
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
          child: GestureDetector(
            onTap: () async {
              Map<String, dynamic> data = {
                'type': _selectedType,
                'isDefault': provider.paymentMethods.isEmpty,
              };

              if (_selectedType == 'card') {
                data['cardNumber'] = _cardNumberController.text;
                data['cardHolderName'] = _cardHolderController.text;
                final expiry = _expiryController.text.split('/');
                if (expiry.length == 2) {
                  data['expiryMonth'] = expiry[0];
                  data['expiryYear'] = expiry[1];
                }
              } else if (_selectedType == 'upi') {
                data['upiId'] = _upiController.text;
              } else if (_selectedType == 'netbanking') {
                data['bankName'] = _bankController.text;
              }

              final success = await provider.addPaymentMethod(data);
              if (success && mounted) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment method saved!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0E5A35), Color(0xFF1B7A4A)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  'Save Payment Method',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
