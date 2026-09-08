import 'package:flutter_test/flutter_test.dart';
import 'package:vpnexues_pvt/core/models/product.dart';

void main() {
  group('Product', () {
    test('constructor creates correct product', () {
      const product = Product(
        id: 'p1',
        name: 'Tomato',
        subtitle: 'Fresh',
        category: 'vegetables',
        imageUrl: 'https://example.com/tomato.jpg',
        currentPrice: 40,
        originalPrice: 50,
        discount: '20%',
        weight: '1 kg',
        isOrganic: true,
        isSale: true,
      );

      expect(product.id, 'p1');
      expect(product.name, 'Tomato');
      expect(product.subtitle, 'Fresh');
      expect(product.category, 'vegetables');
      expect(product.imageUrl, 'https://example.com/tomato.jpg');
      expect(product.currentPrice, 40);
      expect(product.originalPrice, 50);
      expect(product.discount, '20%');
      expect(product.weight, '1 kg');
      expect(product.isOrganic, true);
      expect(product.isSale, true);
    });

    test('constructor sets defaults for optional fields', () {
      const product = Product(
        id: 'p1',
        name: 'Milk',
        subtitle: '',
        category: 'beverages',
        imageUrl: '',
        currentPrice: 32,
        originalPrice: 32,
        discount: '',
        weight: '500 ml',
      );

      expect(product.isOrganic, false);
      expect(product.isSale, false);
    });

    group('fromJson', () {
      test('parses all fields correctly', () {
        final json = {
          'id': 'p1',
          'name': 'Apple',
          'subtitle': 'Red',
          'category': 'fruits',
          'imageUrl': 'https://example.com/apple.jpg',
          'currentPrice': 120,
          'originalPrice': 150,
          'discount': '20%',
          'weight': '1 kg',
          'isOrganic': true,
          'isSale': true,
        };

        final product = Product.fromJson(json);

        expect(product.id, 'p1');
        expect(product.name, 'Apple');
        expect(product.currentPrice, 120);
        expect(product.originalPrice, 150);
        expect(product.isOrganic, true);
        expect(product.isSale, true);
      });

      test('handles missing fields with defaults', () {
        final json = <String, dynamic>{
          'id': 'p2',
          'name': 'Banana',
        };

        final product = Product.fromJson(json);

        expect(product.id, 'p2');
        expect(product.name, 'Banana');
        expect(product.subtitle, '');
        expect(product.category, '');
        expect(product.imageUrl, '');
        expect(product.currentPrice, 0);
        expect(product.originalPrice, 0);
        expect(product.discount, '');
        expect(product.weight, '');
        expect(product.isOrganic, false);
        expect(product.isSale, false);
      });

      test('handles snake_case JSON keys', () {
        final json = {
          'id': 'p3',
          'name': 'Carrot',
          'image_url': 'https://example.com/carrot.jpg',
          'current_price': 35,
          'original_price': 45,
          'is_organic': true,
          'is_sale': false,
        };

        final product = Product.fromJson(json);

        expect(product.imageUrl, 'https://example.com/carrot.jpg');
        expect(product.currentPrice, 35);
        expect(product.originalPrice, 45);
        expect(product.isOrganic, true);
        expect(product.isSale, false);
      });

      test('handles numeric values as num', () {
        final json = {
          'id': 'p4',
          'name': 'Rice',
          'currentPrice': 80,
          'originalPrice': 100,
        };

        final product = Product.fromJson(json);

        expect(product.currentPrice, 80);
        expect(product.originalPrice, 100);
      });
    });

    group('toJson', () {
      test('serializes correctly', () {
        const product = Product(
          id: 'p1',
          name: 'Tea',
          subtitle: 'Green',
          category: 'beverages',
          imageUrl: 'https://example.com/tea.jpg',
          currentPrice: 60,
          originalPrice: 75,
          discount: '20%',
          weight: '250 g',
          isOrganic: true,
          isSale: false,
        );

        final json = product.toJson();

        expect(json['id'], 'p1');
        expect(json['name'], 'Tea');
        expect(json['subtitle'], 'Green');
        expect(json['category'], 'beverages');
        expect(json['imageUrl'], 'https://example.com/tea.jpg');
        expect(json['currentPrice'], 60);
        expect(json['originalPrice'], 75);
        expect(json['discount'], '20%');
        expect(json['weight'], '250 g');
        expect(json['isOrganic'], true);
        expect(json['isSale'], false);
      });
    });

    test('fromJson and toJson are reversible', () {
      final originalJson = {
        'id': 'p5',
        'name': 'Onion',
        'subtitle': 'Red',
        'category': 'vegetables',
        'imageUrl': 'https://example.com/onion.jpg',
        'currentPrice': 25,
        'originalPrice': 30,
        'discount': '17%',
        'weight': '500 g',
        'isOrganic': false,
        'isSale': true,
      };

      final product = Product.fromJson(originalJson);
      final serialized = product.toJson();

      expect(serialized['id'], originalJson['id']);
      expect(serialized['name'], originalJson['name']);
      expect(serialized['currentPrice'], originalJson['currentPrice']);
    });
  });
}
