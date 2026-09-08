class Address {
  final String id;
  final String label;
  final String fullName;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String country;
  final double latitude;
  final double longitude;
  final bool isDefault;

  Address({
    this.id = '',
    this.label = 'Home',
    this.fullName = '',
    this.phone = '',
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.city = '',
    this.state = '',
    this.pincode = '',
    this.country = 'India',
    this.latitude = 0,
    this.longitude = 0,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? 'Home',
      fullName: json['fullName']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      addressLine1: json['addressLine1']?.toString() ?? '',
      addressLine2: json['addressLine2']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      country: json['country']?.toString() ?? 'India',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      isDefault: json['isDefault'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'fullName': fullName,
      'phone': phone,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
    };
  }

  String get fullAddress {
    final parts = <String>[];
    final lower = addressLine1.toLowerCase();

    if (addressLine2.isNotEmpty) parts.add(addressLine2);
    if (addressLine1.isNotEmpty) parts.add(addressLine1);
    if (city.isNotEmpty && !lower.contains(city.toLowerCase())) parts.add(city);
    if (state.isNotEmpty && !lower.contains(state.toLowerCase())) parts.add(state);
    if (pincode.isNotEmpty && !lower.contains(pincode)) parts.add(pincode);

    return parts.join(', ');
  }

  // Blinkit/Amazon style: "123, Arisipalayam, Salem" (door + area + district)
  String get addressTitle {
    final parts = <String>[];
    if (addressLine2.isNotEmpty) parts.add(addressLine2);

    final areaName = _extractAreaFromLine1();
    if (areaName.isNotEmpty) parts.add(areaName);

    if (city.isNotEmpty && areaName.toLowerCase() != city.toLowerCase() && !areaName.toLowerCase().contains(city.toLowerCase())) {
      parts.add(city);
    }

    if (parts.isEmpty && addressLine1.isNotEmpty) {
      parts.add(addressLine1);
    }

    return parts.join(', ');
  }

  // Blinkit/Amazon style: "636005, Tamil Nadu, India" (pincode + state + country)
  String get addressSubtitle {
    final parts = <String>[];
    if (pincode.isNotEmpty) parts.add(pincode);
    if (state.isNotEmpty) parts.add(state);
    if (country.isNotEmpty && country != state) parts.add(country);
    return parts.join(', ');
  }

  // Extract area name from addressLine1 by removing state, pincode, country
  String _extractAreaFromLine1() {
    if (addressLine1.isEmpty) return '';

    var cleaned = addressLine1;

    // Remove state, pincode, country from the address to get area name
    if (state.isNotEmpty) cleaned = cleaned.replaceAll(RegExp(RegExp.escape(state), caseSensitive: false), '');
    if (pincode.isNotEmpty) cleaned = cleaned.replaceAll(pincode, '');
    if (country.isNotEmpty) cleaned = cleaned.replaceAll(RegExp(RegExp.escape(country), caseSensitive: false), '');
    cleaned = cleaned.replaceAll(RegExp(r'\b(India|IN)\b', caseSensitive: false), '');

    // Clean up commas and spaces
    cleaned = cleaned.replaceAll(RegExp(r',\s*,'), ',');
    cleaned = cleaned.replaceAll(RegExp(r'^\s*,\s*'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\s*,\s*$'), '');
    cleaned = cleaned.trim();

    return cleaned;
  }

  String get shortAddress {
    final parts = <String>[];
    final title = addressTitle;
    final subtitle = addressSubtitle;
    if (title.isNotEmpty) parts.add(title);
    if (subtitle.isNotEmpty) parts.add(subtitle);
    return parts.join(', ');
  }
}
