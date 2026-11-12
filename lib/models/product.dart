import '../utils/price_format.dart';

/// Katalogdaki bir ürün. Veriler assets/data/products.json dosyasından gelir.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    required this.category,
    required this.specs,
  });

  final int id;
  final String name;
  final String tagline;
  final String description;
  final double price;
  final String currency;

  /// Uygulama içindeki görselin yolu (Image.asset ile açılır).
  final String image;
  final String category;
  final Map<String, String> specs;

  factory Product.fromJson(Map<String, dynamic> json) {
    final specs = json['specs'] as Map<String, dynamic>? ?? const {};
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: json['tagline'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: parsePrice(json['price']),
      currency: json['currency'] as String? ?? 'USD',
      image: json['image'] as String,
      category: json['category'] as String? ?? 'Diğer',
      specs: specs.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tagline': tagline,
        'description': description,
        'price': formatPrice(price),
        'currency': currency,
        'image': image,
        'category': category,
        'specs': specs,
      };

  /// JSON'daki fiyat "$2,499" gibi metin olarak gelir; hesap yapabilmek için sayıya çevrilir.
  static double parsePrice(Object? value) {
    if (value is num) return value.toDouble();
    final digits = (value as String? ?? '').replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(digits) ?? 0;
  }
}
