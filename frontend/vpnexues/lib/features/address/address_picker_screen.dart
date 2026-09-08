import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vpnexues_pvt/core/models/address.dart';
import 'package:vpnexues_pvt/features/address/providers/address_provider.dart';
import 'package:vpnexues_pvt/core/constants/app_colors.dart';
import 'package:vpnexues_pvt/shared/providers/auth_provider.dart';
import 'package:vpnexues_pvt/core/services/country_detection_service.dart';

// ── Main Screen ─────────────────────────────────────────────────────

class AddressPickerScreen extends StatefulWidget {
  final Address? existingAddress;

  const AddressPickerScreen({super.key, this.existingAddress});

  @override
  State<AddressPickerScreen> createState() => _AddressPickerScreenState();
}

class _AddressPickerScreenState extends State<AddressPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _flatController = TextEditingController();

  LatLng _selectedLocation = LatLng(CountryDetectionService.defaultLatitude, CountryDetectionService.defaultLongitude);
  String _selectedAddress = '';
  String _selectedCity = '';
  String _selectedState = '';
  String _selectedPincode = '';
  String _selectedLabel = 'Home';
  bool _isLoadingLocation = true;
  bool _isSaving = false;
  bool _isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];
  Timer? _reverseGeocodeDebounce;
  Timer? _searchDebounce;
  bool _locationResolved = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingAddress != null) {
      final addr = widget.existingAddress!;
      _selectedLabel = addr.label;
      _nameController.text = addr.fullName;
      _phoneController.text = addr.phone;
      _flatController.text = addr.addressLine2;
      _selectedAddress = addr.addressLine1;
      _selectedCity = addr.city;
      _selectedState = addr.state;
      _selectedPincode = addr.pincode;
      if (addr.latitude != 0 && addr.longitude != 0) {
        _selectedLocation = LatLng(addr.latitude, addr.longitude);
        _locationResolved = true;
      }
    } else {
      // Pre-fill name and phone from user profile
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final auth = context.read<AuthProvider>();
        if (auth.userName != null && auth.userName!.isNotEmpty) {
          _nameController.text = auth.userName!;
        }
        if (auth.userPhone != null && auth.userPhone!.isNotEmpty) {
          _phoneController.text = auth.userPhone!;
        }
      });
    }
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _reverseGeocodeDebounce?.cancel();
    _searchDebounce?.cancel();
    _searchController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _flatController.dispose();
    super.dispose();
  }

  // ── PROBLEM 5: Current Location ──────────────────────────────────

  Future<void> _getCurrentLocation() async {
    if (_locationResolved) {
      setState(() => _isLoadingLocation = false);
      return;
    }

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission denied. Enable in Settings or select on map.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 4),
            ),
          );
        }
        await _useGeoIP();
        return;
      }

      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission required. You can also select on the map.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
        await _useGeoIP();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      _selectedLocation = LatLng(position.latitude, position.longitude);
      _locationResolved = true;
      await _reverseGeocode(_selectedLocation);
    } on TimeoutException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location timed out. Please try again or select on map.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
      await _useGeoIP();
      return;
    } catch (_) {
      await _useGeoIP();
      return;
    }

    if (mounted) {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _useGeoIP() async {
    if (_locationResolved) {
      if (mounted) setState(() => _isLoadingLocation = false);
      return;
    }
    try {
      final response = await http.get(
        Uri.parse('https://get.geojs.io/v1/ip/geo.json'),
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final lat = double.tryParse(data['latitude']?.toString() ?? '') ?? CountryDetectionService.defaultLatitude;
        final lng = double.tryParse(data['longitude']?.toString() ?? '') ?? CountryDetectionService.defaultLongitude;
        _selectedLocation = LatLng(lat, lng);
        _locationResolved = true;
        await _reverseGeocode(_selectedLocation);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to detect location. Select manually on map.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
    if (mounted) {
      setState(() => _isLoadingLocation = false);
    }
  }

  // ── PROBLEM 3: Debounced Reverse Geocoding ───────────────────────

  void _onMapLocationChanged(LatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
      _selectedAddress = '';
    });
    _reverseGeocodeDebounce?.cancel();
    _reverseGeocodeDebounce = Timer(const Duration(milliseconds: 600), () {
      _reverseGeocode(latLng);
    });
  }

  Future<void> _reverseGeocode(LatLng latLng) async {
    // Try Photon first
    try {
      final url = 'https://photon.komoot.io/reverse?lat=${latLng.latitude}&lon=${latLng.longitude}&lang=en&limit=1';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List?;
        if (features != null && features.isNotEmpty) {
          final props = features[0]['properties'];
          final areaName = _extractSpecificArea(props);
          final parts = <String>[];
          // Priority: area → district → street → city/town/village → state → postcode → country
          if (areaName.isNotEmpty) parts.add(areaName);
          if (props['district'] != null && props['district'].toString() != areaName) parts.add(props['district'].toString());
          if (props['street'] != null && !parts.contains(props['street'].toString())) parts.add(props['street'].toString());
          if (props['city'] != null) parts.add(props['city'].toString());
          if (props['town'] != null && props['city'] == null) parts.add(props['town'].toString());
          if (props['village'] != null && props['city'] == null && props['town'] == null) parts.add(props['village'].toString());
          if (props['state'] != null) parts.add(props['state'].toString());
          if (props['postcode'] != null) parts.add(props['postcode'].toString());
          if (props['country'] != null) parts.add(props['country'].toString());

          if (parts.isNotEmpty && mounted) {
            setState(() {
              _selectedAddress = parts.join(', ');
              _selectedCity = props['city']?.toString() ?? props['town']?.toString() ?? props['village']?.toString() ?? '';
              _selectedState = props['state']?.toString() ?? '';
              _selectedPincode = props['postcode']?.toString() ?? '';
            });
            return;
          }
        }
      }
    } catch (_) {}
    // Fallback: Nominatim
    try {
      final url = 'https://nominatim.openstreetmap.org/reverse?lat=${latLng.latitude}&lon=${latLng.longitude}&format=json&zoom=18&addressdetails=1';
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final addr = data['address'] ?? {};
        final areaName = _extractSpecificAreaNominatim(addr);
        final parts = <String>[];
        // Priority: area → district → city/town/village → state → postcode → country
        if (areaName.isNotEmpty) parts.add(areaName);
        if (addr['city'] != null && addr['city'] != areaName) parts.add(addr['city'].toString());
        if (addr['town'] != null && addr['city'] == null && addr['town'] != areaName) parts.add(addr['town'].toString());
        if (addr['village'] != null && addr['city'] == null && addr['town'] == null && addr['village'] != areaName) parts.add(addr['village'].toString());
        if (addr['state'] != null) parts.add(addr['state'].toString());
        if (addr['postcode'] != null) parts.add(addr['postcode'].toString());
        if (addr['country'] != null) parts.add(addr['country'].toString());

        if (parts.isNotEmpty && mounted) {
          setState(() {
            _selectedAddress = parts.join(', ');
            _selectedCity = addr['city']?.toString() ?? addr['town']?.toString() ?? addr['village']?.toString() ?? '';
            _selectedState = addr['state']?.toString() ?? '';
            _selectedPincode = addr['postcode']?.toString() ?? '';
          });
        }
      }
    } catch (_) {}
  }

  // Extract the most specific area name from Photon API response
  String _extractSpecificArea(Map<String, dynamic> props) {
    // Priority order: neighbourhood → suburb → locality → district → county
    final candidates = [
      props['neighbourhood']?.toString(),
      props['suburb']?.toString(),
      props['locality']?.toString(),
      props['district']?.toString(),
      props['county']?.toString(),
    ];
    for (final c in candidates) {
      if (c != null && c.isNotEmpty) return c;
    }
    return '';
  }

  // Extract the most specific area name from Nominatim API response
  String _extractSpecificAreaNominatim(Map<String, dynamic> addr) {
    // Priority order: neighbourhood → suburb → locality → city_district → district
    final candidates = [
      addr['neighbourhood']?.toString(),
      addr['suburb']?.toString(),
      addr['locality']?.toString(),
      addr['city_district']?.toString(),
      addr['district']?.toString(),
      addr['state_district']?.toString(),
    ];
    for (final c in candidates) {
      if (c != null && c.isNotEmpty) return c;
    }
    return '';
  }

  // ── PROBLEM 3: Debounced Search ──────────────────────────────────

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    if (query.length < 3) {
      setState(() => _searchResults = []);
      return;
    }
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _searchAddress(query);
    });
  }

  Future<void> _searchAddress(String query) async {
    setState(() => _isSearching = true);
    try {
      final url = 'https://photon.komoot.io/api/?q=$query&limit=5&lang=en&lat=${_selectedLocation.latitude}&lon=${_selectedLocation.longitude}';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200 && mounted) {
        final data = json.decode(response.body);
        final features = data['features'] as List? ?? [];
        setState(() {
          _searchResults = features.map<Map<String, dynamic>>((f) {
            final props = f['properties'];
            final coords = f['geometry']?['coordinates'] as List?;
            return {
              'name': props['name'] ?? '',
              'detail': [props['city'], props['state'], props['country']].where((s) => s != null).join(', '),
              'lat': coords != null ? coords[1] as double : null,
              'lng': coords != null ? coords[0] as double : null,
            };
          }).toList();
          _isSearching = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _onSearchResultSelected(Map<String, dynamic> result) {
    final lat = result['lat'] as double?;
    final lng = result['lng'] as double?;
    if (lat != null && lng != null) {
      setState(() {
        _selectedLocation = LatLng(lat, lng);
        _selectedAddress = '${result['name']}, ${result['detail']}';
        _searchResults = [];
        _searchController.clear();
      });
      _reverseGeocode(LatLng(lat, lng));
    }
  }

  // ── PROBLEM 4: Save Address ──────────────────────────────────────

  Future<void> _saveAddress() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name'), backgroundColor: Colors.red),
      );
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number'), backgroundColor: Colors.red),
      );
      return;
    }
    if (_selectedAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location on the map'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSaving = true);

    final address = Address(
      id: widget.existingAddress?.id ?? '',
      label: _selectedLabel,
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      addressLine1: _selectedAddress,
      addressLine2: _flatController.text.trim(),
      city: _selectedCity,
      state: _selectedState,
      pincode: _selectedPincode,
      country: CountryDetectionService.defaultCountryName,
      latitude: _selectedLocation.latitude,
      longitude: _selectedLocation.longitude,
      isDefault: widget.existingAddress == null,
    );

    final provider = context.read<AddressProvider>();
    bool success;
    if (widget.existingAddress != null && widget.existingAddress!.id.isNotEmpty) {
      success = await provider.updateAddress(widget.existingAddress!.id, address);
    } else {
      success = await provider.addAddress(address);
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save address. Please check connection and try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // ── UI ───────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            // PROBLEM 1 FIX: Map is standalone, not inside scroll view
            _MapSection(
              initialCenter: _selectedLocation,
              isLoading: _isLoadingLocation,
              onLocationChanged: _onMapLocationChanged,
              onMyLocationTap: _getCurrentLocation,
            ),
            _buildSearchBar(),
            _buildSearchResults(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: _buildForm(),
              ),
            ),
            _buildSaveButton(),
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
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textColor(context)),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Select Delivery Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textColor(context)),
              ),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderGray),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search area, landmark...',
            hintStyle: TextStyle(color: AppColors.textLightGray, fontSize: 14),
            prefixIcon: _isSearching
                ? Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                    ),
                  )
                : Icon(Icons.search, color: AppColors.textLightGray, size: 22),
            suffixIcon: _searchController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _searchResults = []);
                    },
                    child: Icon(Icons.close, color: AppColors.textLightGray, size: 18),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGray),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _searchResults.map((result) {
          return GestureDetector(
            onTap: () => _onSearchResultSelected(result),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result['name'] ?? '',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textColor(context)),
                        ),
                        if (result['detail'] != null && (result['detail'] as String).isNotEmpty)
                          Text(
                            result['detail'],
                            style: TextStyle(fontSize: 12, color: AppColors.textLightGray),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Label', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textColor(context))),
        const SizedBox(height: 8),
        Row(
          children: ['Home', 'Work', 'Other'].map((label) {
            final isSelected = _selectedLabel == label;
            return GestureDetector(
              onTap: () => setState(() => _selectedLabel = label),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.primary)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        _buildTextField(_nameController, 'Full Name *', Icons.person_outline),
        const SizedBox(height: 12),
        _buildTextField(_phoneController, 'Phone Number *', Icons.phone_outlined),
        const SizedBox(height: 12),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: _selectedAddress.isEmpty ? const Color(0xFFF5F5F5) : const Color(0xFFF0F7F2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _selectedAddress.isEmpty ? AppColors.borderGray : AppColors.primary),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Icon(Icons.location_on_outlined, color: AppColors.textLightGray, size: 20),
              ),
              Expanded(
                child: Text(
                  _selectedAddress.isEmpty ? 'Tap on map to select location' : _selectedAddress,
                  style: TextStyle(fontSize: 13, color: _selectedAddress.isEmpty ? AppColors.textLightGray : AppColors.textColor(context)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildTextField(_flatController, 'Flat / House No. (optional)', Icons.home_outlined),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 14, color: AppColors.textColor(context)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.textLightGray, fontSize: 13),
          prefixIcon: Icon(icon, color: AppColors.textLightGray, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, -3))],
      ),
      child: GestureDetector(
        onTap: _isSaving ? null : _saveAddress,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF0E5A35), Color(0xFF1B7A4A)]),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: _isSaving
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : const Text('Save Address', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}

// ── PROBLEM 1 & 3 FIX: Standalone Map Widget ────────────────────────
// This widget has its own State, so only the marker updates,
// not the entire screen. Tiles stay cached.

class _MapSection extends StatefulWidget {
  final LatLng initialCenter;
  final bool isLoading;
  final ValueChanged<LatLng> onLocationChanged;
  final VoidCallback onMyLocationTap;

  const _MapSection({
    required this.initialCenter,
    required this.isLoading,
    required this.onLocationChanged,
    required this.onMyLocationTap,
  });

  @override
  State<_MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<_MapSection> {
  late MapController _mapController;
  late LatLng _currentCenter;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _currentCenter = widget.initialCenter;
  }

  @override
  void didUpdateWidget(covariant _MapSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCenter != widget.initialCenter) {
      _currentCenter = widget.initialCenter;
      _mapController.move(_currentCenter, _mapController.camera.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentCenter,
                initialZoom: 15,
                interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                onTap: (tapPos, latLng) {
                  setState(() => _currentCenter = latLng);
                  widget.onLocationChanged(latLng);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.vpnexues',
                  tileProvider: CancellableNetworkTileProvider(),
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentCenter,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_pin, color: AppColors.primary, size: 40),
                    ),
                  ],
                ),
              ],
            ),
          // PROBLEM 1 FIX: Small inline loading indicator, NOT full overlay
          if (widget.isLoading)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 6),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
                    SizedBox(width: 8),
                    Text('Finding location...', style: TextStyle(fontSize: 12, color: AppColors.textColor(context))),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 12,
            right: 12,
            child: FloatingActionButton.small(
              backgroundColor: AppColors.primary,
              heroTag: 'location_fab',
              onPressed: widget.onMyLocationTap,
              child: const Icon(Icons.my_location, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
