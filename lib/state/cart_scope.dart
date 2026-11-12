import 'package:flutter/widgets.dart';

import 'cart_controller.dart';

/// Sepeti widget ağacına taşır. `CartScope.of(context)` kullanan widget'lar
/// sepet değiştiğinde otomatik olarak yeniden çizilir.
class CartScope extends InheritedNotifier<CartController> {
  const CartScope({super.key, required CartController controller, required super.child})
      : super(notifier: controller);

  /// build içinde kullanılır; sepet değişince widget yeniden çizilir.
  static CartController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'CartScope bulunamadı.');
    return scope!.notifier!;
  }

  /// Buton tıklaması gibi geri çağırmalarda kullanılır; yeniden çizim tetiklemez.
  static CartController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'CartScope bulunamadı.');
    return scope!.notifier!;
  }
}
