import 'package:flutter/material.dart';

import '../models/product.dart';
import '../routes.dart';
import '../state/cart_controller.dart';
import '../state/cart_scope.dart';

/// Ürünü sepete ekler ve sonucu kısa bir mesajla bildirir.
void addToCartWithFeedback(BuildContext context, Product product) {
  final added = CartScope.read(context).add(product);
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        added
            ? '${product.name} sepete eklendi.'
            : 'Bir üründen en fazla ${CartController.maxQuantity} adet eklenebilir.',
      ),
      duration: const Duration(seconds: 2),
      // Aksiyonu olan mesajlar varsayılan olarak ekranda kalır; 2 saniye sonra kapansın.
      persist: false,
      action: added
          ? SnackBarAction(label: 'Sepete git', onPressed: () => Navigator.pushNamed(context, AppRoutes.cart))
          : null,
    ),
  );
}
