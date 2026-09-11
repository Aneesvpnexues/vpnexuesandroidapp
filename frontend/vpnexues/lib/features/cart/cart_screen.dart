import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/features/cart/providers/cart_provider.dart';
import 'package:vpnexues_pvt/shared/localization/language_provider.dart';
import 'package:vpnexues_pvt/features/address/providers/address_provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import '../address/address_picker_screen.dart';
import '../address/addresses_screen.dart';
import '../settings/settings_screen.dart';
import '../payment/payment_screen.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback? onNavigateToOrders;
  final VoidCallback? onNavigateToHome;
  final VoidCallback? onNavigateBack;

  const CartScreen({super.key, this.onNavigateToOrders, this.onNavigateToHome, this.onNavigateBack});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? _appliedCouponCode;
  double _couponDiscount = 0;

  void _checkout(CartProvider cart) {
    final addressProvider = context.read<AddressProvider>();
    if (addressProvider.defaultAddress == null) {
      _showAddressRequiredDialog();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          onNavigateToOrders: widget.onNavigateToOrders,
          onNavigateToHome: widget.onNavigateToHome,
          couponCode: _appliedCouponCode,
          couponDiscount: _couponDiscount,
        ),
      ),
    );
  }

  void _showAddressRequiredDialog() {
    final lang = context.watch<LanguageProvider>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          lang.t('cart_address_required'),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        content: Text(
          lang.t('cart_address_required_sub'),
          style: TextStyle(fontSize: 14, color: AppColors.textLightGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.t('common_cancel'), style: TextStyle(color: AppColors.textLightGray)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddressPickerScreen()),
              );
              if (result == true && mounted) {
                context.read<AddressProvider>().loadAddresses();
              }
            },
            child: Text(
              lang.t('cart_add_address'),
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items.values.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: items.isEmpty
                  ? _buildEmptyState()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          _buildDeliveryCard(),
                          const SizedBox(height: 20),
                          _buildCartHeading(items.length),
                          const SizedBox(height: 12),
                          ...items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _CartItemCard(item: item),
                              )),
                          const SizedBox(height: 8),
                          _buildCouponCard(),
                          const SizedBox(height: 12),
                          _buildOrderSummary(cart, items.length),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
            ),
            if (items.isNotEmpty) _buildCheckoutBar(cart),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final lang = context.watch<LanguageProvider>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.borderGray),
          const SizedBox(height: 16),
          Text(
            lang.t('cart_empty'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textLightGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            lang.t('cart_empty_sub'),
            style: TextStyle(fontSize: 14, color: AppColors.textLightGray),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (widget.onNavigateBack != null) {
                widget.onNavigateBack!();
              } else {
                Navigator.of(context).maybePop();
              }
            },
            child: Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textColor(context)),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Cart',
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
            child: Icon(Icons.settings_outlined, size: 22, color: AppColors.textColor(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard() {
    final addressProvider = context.watch<AddressProvider>();
    final address = addressProvider.defaultAddress;

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddressesScreen()),
        );
        if (result == true) {
          addressProvider.loadAddresses();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF2E7D32),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deliver to',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address != null
                        ? '${address.addressTitle}\n${address.addressSubtitle}'
                        : 'No addresses saved',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7F0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Change',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartHeading(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.shopping_cart, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Text(
            'Cart Items ($count)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard() {
    final lang = context.watch<LanguageProvider>();
    if (_appliedCouponCode != null) {
      return GestureDetector(
        onTap: () => _showCouponSheet(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FAF0),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_offer, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coupon "$_appliedCouponCode" applied!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${_couponDiscount.toInt()} OFF',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textLightGray,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _appliedCouponCode = null;
                    _couponDiscount = 0;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.red, size: 18),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _showCouponSheet(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.local_offer_outlined, color: Color(0xFF2E7D32), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.t('cart_apply_coupon'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lang.t('cart_coupon_offers'),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textLightGray,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textLightGray, size: 24),
          ],
        ),
      ),
    );
  }

  void _showCouponSheet() {
    final lang = context.watch<LanguageProvider>();
    final cart = context.read<CartProvider>();
    final List<Map<String, String>> availableCoupons = [
      {'code': 'WELCOME10', 'title': '10% OFF', 'desc': 'On first order above ₹500', 'min': 'Min. order ₹500'},
      {'code': 'FRESH20', 'title': '20% OFF', 'desc': 'On fresh vegetables', 'min': 'Min. order ₹300'},
      {'code': 'FREEDEL', 'title': 'Free Delivery', 'desc': 'Free delivery on all orders', 'min': 'No minimum order'},
      {'code': 'SAVE50', 'title': '₹50 OFF', 'desc': 'Flat ₹50 off on groceries', 'min': 'Min. order ₹400'},
    ];

    final couponController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          height: MediaQuery.of(ctx).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                lang.t('cart_apply_coupon'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(Icons.confirmation_number_outlined, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: couponController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            hintText: lang.t('cart_enter_coupon'),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (couponController.text.isNotEmpty) {
                            final code = couponController.text.toUpperCase();
                            double discount = 0;
                            if (code == 'SAVE50') {
                              discount = 50;
                            } else if (code == 'WELCOME10') {
                              discount = cart.totalPrice * 0.10;
                            } else if (code == 'FRESH20') {
                              discount = cart.totalPrice * 0.20;
                            } else if (code == 'FREEDEL') {
                              discount = 40;
                            }
                            Navigator.pop(ctx);
                            setState(() {
                              _appliedCouponCode = code;
                              _couponDiscount = discount;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(discount > 0
                                    ? 'Coupon "$code" applied! ₹${discount.toInt()} off'
                                    : 'Coupon "$code" applied!'),
                                backgroundColor: AppColors.primary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            lang.t('home_apply'),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    lang.t('cart_available_coupons'),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: availableCoupons.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final coupon = availableCoupons[index];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5FAF5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.local_offer, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  coupon['title']!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textColor(context),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  coupon['desc']!,
                                  style: TextStyle(fontSize: 12, color: AppColors.textSecondaryColor(context)),
                                ),
                                Text(
                                  coupon['min']!,
                                  style: TextStyle(fontSize: 11, color: AppColors.textLightGray),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              double discount = 0;
                              final code = coupon['code']!;
                              if (code == 'SAVE50') {
                                discount = 50;
                              } else if (code == 'WELCOME10') {
                                discount = cart.totalPrice * 0.10;
                              } else if (code == 'FRESH20') {
                                discount = cart.totalPrice * 0.20;
                              } else if (code == 'FREEDEL') {
                                discount = 40;
                              }
                              Navigator.pop(ctx);
                              setState(() {
                                _appliedCouponCode = code;
                                _couponDiscount = discount;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Coupon "$code" applied! ₹${discount.toInt()} off'),
                                  backgroundColor: AppColors.primary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.primary),
                              ),
                              child: Text(
                                lang.t('home_apply'),
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cart, int itemCount) {
    final deliveryFee = 40.0;
    final deliveryDiscount = 40.0;
    final itemTotal = cart.totalPrice;
    final totalAmount = itemTotal + deliveryFee - deliveryDiscount - _couponDiscount;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow('Item Total ($itemCount items)', '₹${itemTotal.toStringAsFixed(2)}', isNormal: true),
          const SizedBox(height: 12),
          _buildSummaryRow('Delivery Fee', '₹${deliveryFee.toStringAsFixed(2)}', isNormal: true),
          const SizedBox(height: 12),
          _buildSummaryRow('Delivery Discount', '-₹${deliveryDiscount.toStringAsFixed(2)}', isDiscount: true),
          if (_couponDiscount > 0) ...[
            const SizedBox(height: 12),
            _buildSummaryRow('Coupon ($_appliedCouponCode)', '-₹${_couponDiscount.toInt()}.00', isDiscount: true),
          ],
          const SizedBox(height: 14),
          Container(
            height: 1,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                '₹${totalAmount.toInt()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isDiscount = false, bool isTotal = false, bool isNormal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDiscount
                ? const Color(0xFF2E7D32)
                : const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutBar(CartProvider cart) {
    final total = cart.totalPrice + 40 - 40 - _couponDiscount;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textLightGray,
                ),
              ),
              Text(
                '₹${total.toInt()}',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SlideToOrder(
              onComplete: () => _checkout(cart),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideToOrder extends StatefulWidget {
  final VoidCallback onComplete;

  const _SlideToOrder({required this.onComplete});

  @override
  State<_SlideToOrder> createState() => _SlideToOrderState();
}

class _SlideToOrderState extends State<_SlideToOrder>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  double _dragExtent = 0;
  bool _confirmed = false;
  double _trackWidth = 250;

  double get _buttonSize => 44;
  double get _maxDrag => (_trackWidth - _buttonSize - 8).clamp(0.0, double.infinity);
  double get _fillPercent => _maxDrag > 0 ? (_dragExtent / _maxDrag).clamp(0.0, 1.0) : 0.0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_confirmed) return;
    setState(() {
      _dragExtent = (_dragExtent + details.delta.dx).clamp(0.0, _maxDrag);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_confirmed) return;

    if (_dragExtent >= _maxDrag * 0.85) {
      setState(() => _confirmed = true);
      widget.onComplete();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _confirmed = false;
            _dragExtent = 0;
          });
        }
      });
    } else {
      _animController.forward(from: 0);
      _animateBack();
    }
  }

  void _animateBack() {
    final start = _dragExtent;
    final anim = Tween(begin: start, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    anim.addListener(() {
      setState(() => _dragExtent = anim.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _trackWidth = constraints.maxWidth;

        return GestureDetector(
          onHorizontalDragUpdate: _onDragUpdate,
          onHorizontalDragEnd: _onDragEnd,
          child: Container(
            height: 50,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 30),
                    width: _dragExtent + _buttonSize + 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.8 + _fillPercent * 0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Opacity(
                      opacity: _fillPercent > 0.3 ? 1.0 : 0.0,
                      child: Text(
                        '>>>  Proceed to Checkout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Opacity(
                      opacity: _fillPercent <= 0.3 ? 1.0 : 0.0,
                      child: Text(
                        '>>>  Proceed to Checkout',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 4 + _dragExtent,
                  top: 3,
                  child: Container(
                    width: _buttonSize,
                    height: _buttonSize,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/company_logo.png',
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.eco,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final product = item.product;
    final quantity = item.quantity;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 80,
                height: 80,
                color: const Color(0xFFF0F7F0),
                child: Icon(Icons.image, color: AppColors.textLightGray),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.weight,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '₹${product.currentPrice.toInt()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => cart.decrementItem(product.id),
                      child: Container(
                        width: 32,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: Icon(Icons.remove, size: 16, color: Colors.grey[600]),
                      ),
                    ),
                    Container(
                      width: 28,
                      alignment: Alignment.center,
                      child: Text(
                        '$quantity',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor(context),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => cart.addItem(product),
                      child: Container(
                        width: 32,
                        height: double.infinity,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E7D32),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: const Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
