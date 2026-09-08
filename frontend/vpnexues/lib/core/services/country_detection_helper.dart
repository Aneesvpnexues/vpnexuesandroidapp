import 'country_detection_helper_native.dart'
    if (dart.library.js_interop) 'country_detection_helper_web.dart';

class CountryDetectionHelper {
  static String getLocale() => getLocaleImpl();
}
