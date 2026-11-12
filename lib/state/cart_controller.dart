import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CartItem {
  CartItem({required this.product, this.quantity = 1});

  final Product product;
  int quantity;

  double get total => product.price * quantity;
}

/// Sepet simülasyonu. Değişiklik olduğunda dinleyen widget'lar yeniden çizilir.
class CartController extends ChangeNotifier {
  static const maxQuantity = 10;

  final Map<int, CartItem> _items = {};

  List<CartItem> get items => List.unmodifiable(_items.values);

  bool get isEmpty => _items.isEmpty;

  int get totalQuantity => _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.values.fold(0, (sum, item) => sum + item.total);

  int quantityOf(Product product) => _items[product.id]?.quantity ?? 0;

  bool canAdd(Product product) => quantityOf(product) < maxQuantity;

  /// Ürünü sepete ekler; ürün zaten varsa adedini bir artırır.
  /// Bir üründen en fazla [maxQuantity] adet eklenebilir.
  bool add(Product product) {
    if (!canAdd(product)) return false;
    final item = _items[product.id];
    if (item == null) {
      _items[product.id] = CartItem(product: product);
    } else {
      item.quantity++;
    }
    notifyListeners();
    return true;
  }

  /// Adedi bir azaltır; adet sıfıra inerse ürün sepetten çıkar.
  void decrease(Product product) {
    final item = _items[product.id];
    if (item == null) return;
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(product.id);
    }
    notifyListeners();
  }

  void remove(Product product) {
    if (_items.remove(product.id) != null) notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
