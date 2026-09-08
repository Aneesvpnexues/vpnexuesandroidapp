import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/models/address.dart';
import 'package:vpnexues_pvt/features/address/providers/address_provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import '../address/address_picker_screen.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().loadAddresses();
    });
  }

  void _addAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddressPickerScreen()),
    );
    if (result == true && mounted) {
      context.read<AddressProvider>().loadAddresses();
    }
  }

  void _editAddress(Address address) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddressPickerScreen(existingAddress: address)),
    );
    if (result == true && mounted) {
      context.read<AddressProvider>().loadAddresses();
    }
  }

  void _deleteAddress(Address address) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Address',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textColor(context)),
        ),
        content: Text(
          'Are you sure you want to delete this address?',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondaryColor(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondaryColor(context))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      context.read<AddressProvider>().deleteAddress(address.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Consumer<AddressProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }
                  if (provider.addresses.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _buildAddressList(provider);
                },
              ),
            ),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cardColor(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor(context)),
              ),
              child: Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textColor(context)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'My Addresses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textColor(context)),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.cardColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor(context)),
            ),
            child: Icon(Icons.add_location_alt_outlined, size: 20, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.location_off_outlined, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'No addresses saved',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textColor(context)),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a delivery address to get started',
              style: TextStyle(fontSize: 15, color: AppColors.textSecondaryColor(context), height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressList(AddressProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      itemCount: provider.addresses.length,
      itemBuilder: (context, index) {
        final address = provider.addresses[index];
        return _buildAddressCard(address, address.isDefault);
      },
    );
  }

  Widget _buildAddressCard(Address address, bool isDefault) {
    final icon = address.label == 'Home'
        ? Icons.home_rounded
        : address.label == 'Work'
            ? Icons.work_rounded
            : Icons.location_on_rounded;

    return GestureDetector(
      onTap: isDefault
          ? null
          : () async {
              final provider = context.read<AddressProvider>();
              final success = await provider.setDefault(address.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${address.label} set as default'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
                Navigator.pop(context, true);
              }
            },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDefault ? AppColors.primary : AppColors.borderColor(context),
            width: isDefault ? 2 : 1,
          ),
          boxShadow: isDefault
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isDefault ? AppColors.primary : AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 22, color: isDefault ? Colors.white : AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address.label,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor(context),
                            ),
                          ),
                          if (isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'DEFAULT',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        address.fullName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondaryColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _editAddress(address),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.fieldFillColor(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.edit_outlined, size: 17, color: AppColors.textSecondaryColor(context)),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _deleteAddress(address),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.delete_outline, size: 17, color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.fieldFillColor(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.place_outlined, size: 16, color: AppColors.textLightGray),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      address.fullAddress,
                      style: TextStyle(fontSize: 14, color: AppColors.textColor(context), height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            if (address.phone.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.phone_outlined, size: 14, color: AppColors.textLightGray),
                  const SizedBox(width: 6),
                  Text(
                    address.phone,
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondaryColor(context)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: _addAddress,
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0E5A35), Color(0xFF1B7A4A)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white, size: 22),
              SizedBox(width: 8),
              Text(
                'Add New Address',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
