import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

/// Ürünleri uygulamanın içindeki JSON dosyasından okur (API simülasyonu).
class ProductRepository {
  const ProductRepository({this.bundle});

  static const assetPath = 'assets/data/products.json';

  /// Boş bırakılırsa uygulamanın kendi asset'leri (rootBundle) kullanılır.
  final AssetBundle? bundle;

  Future<List<Product>> loadProducts() async {
    final raw = await (bundle ?? rootBundle).loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final items = json['data'] as List<dynamic>;
    return items.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
  }
}
