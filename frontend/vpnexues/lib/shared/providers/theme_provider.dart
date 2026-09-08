import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final saved = await _storage.read(key: 'theme_mode');
    if (saved == 'dark') {
      _themeMode = ThemeMode.dark;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    await _storage.write(key: 'theme_mode', value: isDark ? 'dark' : 'light');
    notifyListeners();
  }
}
