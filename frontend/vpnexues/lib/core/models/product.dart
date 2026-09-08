class Product {
  final String id;
  final String name;
  final String subtitle;
  final String category;
  final String imageUrl;
  final double currentPrice;
  final double originalPrice;
  final String discount;
  final String weight;
  final bool isOrganic;
  final bool isSale;

  const Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.imageUrl,
    required this.currentPrice,
    required this.originalPrice,
    required this.discount,
    required this.weight,
    this.isOrganic = false,
    this.isSale = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subtitle: json['subtitle'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      currentPrice: (json['current_price'] ?? json['currentPrice'] ?? 0).toDouble(),
      originalPrice: (json['original_price'] ?? json['originalPrice'] ?? 0).toDouble(),
      discount: json['discount'] ?? '',
      weight: json['weight'] ?? '',
      isOrganic: json['is_organic'] ?? json['isOrganic'] ?? false,
      isSale: json['is_sale'] ?? json['isSale'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'category': category,
      'imageUrl': imageUrl,
      'currentPrice': currentPrice,
      'originalPrice': originalPrice,
      'discount': discount,
      'weight': weight,
      'isOrganic': isOrganic,
      'isSale': isSale,
    };
  }
}
