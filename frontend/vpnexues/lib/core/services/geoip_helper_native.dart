import 'dart:io';
import 'dart:convert';

Future<String?> getCountryCodeImpl() async {
  try {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 5);

    final request = await client.getUrl(Uri.parse('https://ipapi.co/json/'));
    final response = await request.close().timeout(const Duration(seconds: 5));

    final body = await response.transform(utf8.decoder).join();
    client.close();

    final json = jsonDecode(body) as Map<String, dynamic>;
    return json['country_code'] as String?;
  } catch (_) {
    return null;
  }
}
