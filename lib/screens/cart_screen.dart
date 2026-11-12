import 'package:flutter/material.dart';

import '../routes.dart';
import '../state/cart_controller.dart';
import '../state/cart_scope.dart';
import '../utils/price_format.dart';
import '../widgets/empty_state.dart';

/// Sepet sayfası (simülasyon): adet değiştirme, ürün çıkarma ve toplam tutar.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _checkout(BuildContext context, CartController cart) async {
    final total = formatPrice(cart.totalPrice);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 48),
        title: const Text('Siparişin alındı'),
        content: Text('Toplam $total tutarındaki siparişin oluşturuldu.\n(Bu bir simülasyondur, ödeme alınmaz.)'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam'))],
      ),
    );
    cart.clear();
    if (context.mounted) Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetim'),
        actions: [
          if (!cart.isEmpty)
            TextButton(onPressed: CartScope.read(context).clear, child: const Text('Temizle')),
        ],
      ),
      body: cart.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.shopping_cart_outlined,
                title: 'Sepetin boş',
                message: 'Ürün eklemek için kataloğa göz at.',
                action: FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size(200, 48)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Alışverişe başla'),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: items.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CartItemTile(item: items[index]),
              ),
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Toplam (${cart.totalQuantity} ürün)',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        formatPrice(cart.totalPrice),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => _checkout(context, CartScope.read(context)),
                    child: const Text('Siparişi tamamla'),
                  ),
                ],
              ),
            ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final cart = CartScope.read(context);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(product.image, width: 64, height: 64, fit: BoxFit.cover, cacheWidth: 200),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text('${formatPrice(product.price)} / adet', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  Text(
                    formatPrice(item.total),
                    style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: item.quantity == 1 ? 'Sepetten çıkar' : 'Azalt',
              onPressed: () => cart.decrease(product),
              icon: Icon(item.quantity == 1 ? Icons.delete_outline : Icons.remove),
            ),
            Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w700)),
            IconButton(
              tooltip: 'Artır',
              onPressed: cart.canAdd(product) ? () => cart.add(product) : null,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
