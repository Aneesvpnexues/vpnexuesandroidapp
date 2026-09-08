import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app_strings.dart';

class LanguageProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String _currentLanguage = 'en';

  static const Map<String, String> _languageNames = {
    'en': 'English',
    'hi': 'हिन्दी',
    'ta': 'தமிழ்',
    'si': 'සිංහල',
    'ar': 'العربية',
    'zh': '简体中文',
    'ur': 'اردو',
    'ml': 'മലയാളം',
  };

  String get currentLanguage => _currentLanguage;

  String get languageName => _languageNames[_currentLanguage] ?? 'English';

  String t(String key) {
    return AppStrings.t(key, lang: _currentLanguage);
  }

  Future<void> init() async {
    final saved = await _storage.read(key: 'app_language');
    if (saved != null && _languageNames.containsKey(saved)) {
      _currentLanguage = saved;
      notifyListeners();
    }
  }

  Future<void> setLanguage(String langCode) async {
    if (!_languageNames.containsKey(langCode)) return;
    _currentLanguage = langCode;
    await _storage.write(key: 'app_language', value: langCode);
    notifyListeners();
  }

  void cycleLanguage() {
    final languages = ['en', 'si', 'ta'];
    final currentIndex = languages.indexOf(_currentLanguage);
    _currentLanguage = languages[(currentIndex + 1) % languages.length];
    _storage.write(key: 'app_language', value: _currentLanguage);
    notifyListeners();
  }
}
