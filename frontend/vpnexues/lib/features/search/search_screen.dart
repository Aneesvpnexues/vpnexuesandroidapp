import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:vpnexues_pvt/core/models/product.dart';
import 'package:vpnexues_pvt/features/cart/providers/cart_provider.dart';
import 'package:vpnexues_pvt/core/services/api_service.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/shared/widgets/product_image.dart';
import '../product/product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;
  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  final SpeechToText _speechToText = SpeechToText();
  Timer? _debounce;
  List<Product> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  bool _isListening = false;
  String _sortBy = 'name';
  String? _filterCategory;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
      _search(widget.initialQuery!);
    }
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() => _isListening = false);
      return;
    }
    bool available = await _speechToText.initialize(
      onError: (_) => setState(() => _isListening = false),
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) setState(() => _isListening = false);
        }
      },
    );
    if (available) {
      setState(() => _isListening = true);
      await _speechToText.listen(
        onResult: (result) {
          if (result.recognizedWords.isNotEmpty) {
            _searchController.text = result.recognizedWords;
            _searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: _searchController.text.length),
            );
            _onSearchChanged(result.recognizedWords);
          }
          if (result.finalResult) {
            setState(() => _isListening = false);
          }
        },
        listenOptions: SpeechListenOptions(
          listenFor: const Duration(seconds: 10),
          localeId: 'en_IN',
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission denied')),
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _speechToText.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _search(query);
    });
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      final results = await _apiService.searchProducts(query.trim());
      if (mounted) {
        setState(() {
          _results = results;
          _isLoading = false;
          _hasSearched = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _results = [];
          _isLoading = false;
          _hasSearched = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            if (_hasSearched && _results.isNotEmpty) _buildSortFilterBar(),
            const SizedBox(height: 12),
            Expanded(child: _buildResults()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
                'Search',
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search, color: AppColors.textLightGray, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearchChanged,
                style: TextStyle(
                  color: AppColors.textColor(context),
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(
                    color: AppColors.textLightGray,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() {
                    _results = [];
                    _hasSearched = false;
                  });
                },
                child: const Icon(Icons.close,
                    color: AppColors.textLightGray, size: 20),
              ),
            GestureDetector(
              onTap: _toggleListening,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _isListening ? AppColors.primary.withValues(alpha: 0.15) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? AppColors.primary : AppColors.textLightGray,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (!_hasSearched) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 60, color: AppColors.textLightGray),
            SizedBox(height: 12),
            Text(
              'Search for fresh products',
              style: TextStyle(fontSize: 16, color: AppColors.textLightGray),
            ),
          ],
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: AppColors.textLightGray),
            SizedBox(height: 12),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor(context),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Try a different search term',
              style: TextStyle(fontSize: 13, color: AppColors.textLightGray),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
      itemCount: _sortedResults.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _SearchResultCard(product: _sortedResults[index]),
        );
      },
    );
  }

  List<Product> get _sortedResults {
    final filtered = _filterCategory != null
        ? _results.where((p) => p.category == _filterCategory).toList()
        : List<Product>.from(_results);

    switch (_sortBy) {
      case 'price_low':
        filtered.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
        break;
      case 'name':
      default:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
    }
    return filtered;
  }

  Widget _buildSortFilterBar() {
    final categories = _results.map((p) => p.category).toSet().toList();
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildSortChip('A-Z', 'name'),
          const SizedBox(width: 8),
          _buildSortChip('Price ↑', 'price_low'),
          const SizedBox(width: 8),
          _buildSortChip('Price ↓', 'price_high'),
          if (categories.length > 1) ...[
            const SizedBox(width: 12),
            Container(width: 1, color: AppColors.borderColor(context)),
            const SizedBox(width: 12),
            _buildFilterChip('All', null),
            for (final cat in categories) ...[
              const SizedBox(width: 8),
              _buildFilterChip(cat, cat),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isActive = _sortBy == value;
    return GestureDetector(
      onTap: () => setState(() => _sortBy = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.borderColor(context),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sort,
              size: 14,
              color: isActive ? Colors.white : AppColors.textSecondaryColor(context),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value) {
    final isActive = _filterCategory == value;
    return GestureDetector(
      onTap: () => setState(() => _filterCategory = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.borderColor(context),
          ),
        ),
        child: Text(
          label[0].toUpperCase() + label.substring(1),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.textColor(context),
          ),
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final quantity = cart.getQuantity(product.id);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Container(
        height: 110,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor(context), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 90,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: ProductImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: const Center(
                    child: Icon(Icons.image, color: AppColors.textLightGray, size: 30),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$quantity',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    quantity == 0
                        ? GestureDetector(
                            onTap: () => cart.addItem(product),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'ADD',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => cart.decrementItem(product.id),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.remove, color: Colors.white, size: 14),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '$quantity',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textColor(context),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => cart.addItem(product),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.add, color: Colors.white, size: 14),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
