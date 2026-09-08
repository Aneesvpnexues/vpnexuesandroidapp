import 'dart:io';

String getLocaleImpl() {
  try {
    return Platform.localeName;
  } catch (_) {
    return 'en-SG';
  }
}
