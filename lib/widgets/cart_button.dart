import 'package:flutter/material.dart';

import '../routes.dart';
import '../state/cart_scope.dart';

/// Sepetteki ürün sayısını rozet olarak gösteren buton.
class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final count = CartScope.of(context).totalQuantity;
    return IconButton(
      tooltip: 'Sepetim',
      onPressed: () {
        // Açık kalmış "sepete eklendi" mesajı sepet sayfasının alt kısmını örtmesin.
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        Navigator.pushNamed(context, AppRoutes.cart);
      },
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.shopping_bag_outlined, size: 26),
      ),
    );
  }
}
