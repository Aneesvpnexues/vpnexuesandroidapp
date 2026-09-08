import 'package:flutter/foundation.dart';
import 'package:vpnexues_pvt/core/services/api_service.dart';

class PaymentMethodProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Map<String, dynamic>> _paymentMethods = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get paymentMethods => _paymentMethods;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? get defaultPaymentMethod {
    try {
      return _paymentMethods.firstWhere((m) => m['default'] == true);
    } catch (_) {
      return _paymentMethods.isNotEmpty ? _paymentMethods.first : null;
    }
  }

  Future<void> loadPaymentMethods() async {
    _isLoading = true;
    notifyListeners();

    _paymentMethods = await _api.getPaymentMethods();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addPaymentMethod(Map<String, dynamic> data) async {
    final result = await _api.addPaymentMethod(data);
    if (result != null && result['paymentMethod'] != null) {
      _paymentMethods.add(result['paymentMethod']);
      if (data['isDefault'] == true) {
        for (var method in _paymentMethods) {
          method['default'] = method['id'] == result['paymentMethod']['id'];
        }
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updatePaymentMethod(String id, Map<String, dynamic> data) async {
    final result = await _api.updatePaymentMethod(id, data);
    if (result != null && result['paymentMethod'] != null) {
      final index = _paymentMethods.indexWhere((m) => m['id'] == id);
      if (index != -1) {
        _paymentMethods[index] = result['paymentMethod'];
      }
      if (data['isDefault'] == true) {
        for (var method in _paymentMethods) {
          method['default'] = method['id'] == id;
        }
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> deletePaymentMethod(String id) async {
    final success = await _api.deletePaymentMethod(id);
    if (success) {
      _paymentMethods.removeWhere((m) => m['id'] == id);
      if (_paymentMethods.isNotEmpty && !_paymentMethods.any((m) => m['default'] == true)) {
        _paymentMethods.first['default'] = true;
      }
      notifyListeners();
    }
    return success;
  }

  Future<bool> setDefault(String id) async {
    final result = await _api.setDefaultPaymentMethod(id);
    if (result != null) {
      for (var method in _paymentMethods) {
        method['default'] = method['id'] == id;
      }
      notifyListeners();
      return true;
    }
    return false;
  }
}
