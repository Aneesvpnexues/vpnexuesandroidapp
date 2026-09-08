import 'package:flutter/foundation.dart';
import 'package:vpnexues_pvt/core/models/address.dart';
import 'package:vpnexues_pvt/core/services/api_service.dart';

class AddressProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<Address> _addresses = [];
  Address? _defaultAddress;
  bool _isLoading = false;

  List<Address> get addresses => _addresses;
  Address? get defaultAddress => _defaultAddress;
  bool get isLoading => _isLoading;

  String get deliveryAddressText {
    if (_defaultAddress != null) {
      return _defaultAddress!.fullAddress;
    }
    return 'No address set';
  }

  String get deliveryLabel {
    if (_defaultAddress != null) {
      return _defaultAddress!.label;
    }
    return '';
  }

  Future<void> loadAddresses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _api.getAddresses();
      _addresses = data.map((json) => Address.fromJson(json)).toList();
      
      final defaultData = await _api.getDefaultAddress();
      if (defaultData != null) {
        _defaultAddress = Address.fromJson(defaultData);
      } else if (_addresses.isNotEmpty) {
        _defaultAddress = _addresses.firstWhere(
          (a) => a.isDefault,
          orElse: () => _addresses.first,
        );
      } else {
        _defaultAddress = null;
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addAddress(Address address) async {
    try {
      final result = await _api.addAddress(address.toJson());
      if (result != null) {
        final newAddress = Address.fromJson(result);
        _addresses.insert(0, newAddress);
        if (newAddress.isDefault || _defaultAddress == null) {
          _defaultAddress = newAddress;
        }
        notifyListeners();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateAddress(String id, Address address) async {
    try {
      final result = await _api.updateAddress(id, address.toJson());
      if (result != null) {
        final updated = Address.fromJson(result);
        final index = _addresses.indexWhere((a) => a.id == id);
        if (index != -1) {
          _addresses[index] = updated;
        }
        if (updated.isDefault) {
          _defaultAddress = updated;
        }
        notifyListeners();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteAddress(String id) async {
    try {
      final success = await _api.deleteAddress(id);
      if (success) {
        _addresses.removeWhere((a) => a.id == id);
        if (_defaultAddress?.id == id) {
          _defaultAddress = _addresses.isNotEmpty ? _addresses.first : null;
        }
        notifyListeners();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setDefault(String id) async {
    try {
      final result = await _api.setDefaultAddress(id);
      if (result != null) {
        for (var addr in _addresses) {
          addr = Address(
            id: addr.id,
            label: addr.label,
            fullName: addr.fullName,
            phone: addr.phone,
            addressLine1: addr.addressLine1,
            addressLine2: addr.addressLine2,
            city: addr.city,
            state: addr.state,
            pincode: addr.pincode,
            country: addr.country,
            latitude: addr.latitude,
            longitude: addr.longitude,
            isDefault: addr.id == id,
          );
        }
        _addresses = _addresses.map((a) => Address(
          id: a.id,
          label: a.label,
          fullName: a.fullName,
          phone: a.phone,
          addressLine1: a.addressLine1,
          addressLine2: a.addressLine2,
          city: a.city,
          state: a.state,
          pincode: a.pincode,
          country: a.country,
          latitude: a.latitude,
          longitude: a.longitude,
          isDefault: a.id == id,
        )).toList();
        _defaultAddress = _addresses.firstWhere((a) => a.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
