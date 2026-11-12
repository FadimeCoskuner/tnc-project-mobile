import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/state/cart_controller.dart';
import 'package:mini_katalog/utils/price_format.dart';

Product sampleProduct({int id = 1, String price = '\$2,499'}) => Product.fromJson({
      'id': id,
      'name': 'MacBook Pro 16"',
      'tagline': 'Mind-blowing.',
      'description': 'Açıklama',
      'price': price,
      'currency': 'USD',
      'image': 'assets/images/macbook.jpg',
      'category': 'Mac',
      'specs': {'chip': 'M3 Max'},
    });

void main() {
  group('Product', () {
    test('fromJson fiyat metnini sayıya çevirir', () {
      final product = sampleProduct();
      expect(product.price, 2499);
      expect(product.specs['chip'], 'M3 Max');
    });

    test('toJson ile fromJson birbirinin tersidir', () {
      final product = sampleProduct();
      final copy = Product.fromJson(product.toJson());
      expect(copy.toJson(), product.toJson());
      expect(product.toJson()['price'], '\$2,499');
    });
  });

  test('formatPrice binlik ayırıcı ve kuruş ekler', () {
    expect(formatPrice(99), '\$99');
    expect(formatPrice(1299), '\$1,299');
    expect(formatPrice(1234567.5), '\$1,234,567.50');
    expect(formatPrice(0.999), '\$1');
  });

  group('CartController', () {
    test('aynı ürün tekrar eklenince adet artar, toplam doğru hesaplanır', () {
      final cart = CartController();
      final mac = sampleProduct();
      final other = sampleProduct(id: 2, price: '\$99');

      cart.add(mac);
      cart.add(mac);
      cart.add(other);

      expect(cart.items.length, 2);
      expect(cart.quantityOf(mac), 2);
      expect(cart.totalQuantity, 3);
      expect(cart.totalPrice, 2 * 2499 + 99);
    });

    test('adet sıfıra inince ürün sepetten çıkar', () {
      final cart = CartController();
      final mac = sampleProduct();
      cart.add(mac);
      cart.decrease(mac);
      expect(cart.isEmpty, isTrue);
    });

    test('bir üründen en fazla 10 adet eklenebilir', () {
      final cart = CartController();
      final mac = sampleProduct();
      for (var i = 0; i < CartController.maxQuantity; i++) {
        expect(cart.add(mac), isTrue);
      }
      expect(cart.add(mac), isFalse);
      expect(cart.quantityOf(mac), CartController.maxQuantity);
    });

    test('değişiklikler dinleyicilere bildirilir', () {
      final cart = CartController();
      var notified = 0;
      cart.addListener(() => notified++);
      cart.add(sampleProduct());
      cart.clear();
      cart.clear(); // boş sepeti temizlemek bildirim üretmez
      expect(notified, 2);
    });
  });
}
