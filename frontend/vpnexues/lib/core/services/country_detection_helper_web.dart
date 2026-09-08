import 'dart:js_interop';

@JS('window.navigator.language')
external JSString? get _navigatorLanguage;

String getLocaleImpl() {
  try {
    final language = _navigatorLanguage?.toDart;
    if (language != null && language.isNotEmpty) {
      return language;
    }
  } catch (_) {}
  return 'en-SG';
}
