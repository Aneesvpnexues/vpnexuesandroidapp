import 'geoip_helper_native.dart'
    if (dart.library.js_interop) 'geoip_helper_web.dart';

class GeoIPHelper {
  static Future<String?> getCountryCode() => getCountryCodeImpl();
}
