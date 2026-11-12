import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/cart_scope.dart';
import '../utils/price_format.dart';
import '../utils/spec_labels.dart';
import '../widgets/cart_button.dart';
import '../widgets/cart_feedback.dart';
import '../widgets/empty_state.dart';

/// Ürün detayı. Gösterilecek ürün Route Arguments ile gelir.
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments;
    if (product is! Product) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: EmptyState(
            icon: Icons.inventory_2_outlined,
            title: 'Ürün bulunamadı',
            message: 'Bu sayfa bir ürün seçilerek açılmalıdır.',
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    final inCart = CartScope.of(context).quantityOf(product);

    return Scaffold(
      appBar: AppBar(title: Text(product.category), actions: const [CartButton(), SizedBox(width: 8)]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 1,
              child: Hero(
                tag: 'product-${product.id}',
                child: Image.asset(product.image, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(product.name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(product.tagline, style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          Text(
            formatPrice(product.price),
            style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 24),
          Text('Açıklama', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(product.description, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
          if (product.specs.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('Özellikler', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final entry in product.specs.entries) _SpecTile(label: specLabel(entry.key), value: entry.value),
              ],
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: FilledButton.icon(
          onPressed: () => addToCartWithFeedback(context, product),
          icon: const Icon(Icons.add_shopping_cart_rounded),
          label: Text(inCart == 0 ? 'Sepete ekle' : 'Sepete ekle (sepette $inCart adet)'),
        ),
      ),
    );
  }
}

class _SpecTile extends StatelessWidget {
  const _SpecTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 100),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toUpperCase(), style: TextStyle(fontSize: 11, color: Colors.grey.shade600, letterSpacing: 0.5)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
