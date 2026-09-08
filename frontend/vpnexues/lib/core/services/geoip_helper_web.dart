import 'dart:js_interop';

@JS()
@anonymous
extension type _Response._(JSObject _) implements JSObject {
  external JSPromise<JSAny?> json();
}

@JS('fetch')
external JSPromise<_Response> _fetch(JSString url);

Future<String?> getCountryCodeImpl() async {
  try {
    final response = await _fetch('https://ipapi.co/json/'.toJS).toDart;
    final jsonData = await response.json().toDart;

    if (jsonData != null) {
      final jsonString = _jsStringify(jsonData).toDart;
      final match = RegExp(r'"country_code"\s*:\s*"([^"]+)"').firstMatch(jsonString);
      if (match != null) {
        return match.group(1);
      }
    }
  } catch (_) {}
  return null;
}

@JS('JSON.stringify')
external JSString _jsStringify(JSAny? value);
