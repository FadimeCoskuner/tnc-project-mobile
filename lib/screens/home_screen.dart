import 'package:flutter/material.dart';

import '../data/product_repository.dart';
import '../models/product.dart';
import '../widgets/cart_button.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';

/// Ana sayfa: banner, arama, kategori filtresi ve ürün listesi (GridView).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _allCategories = 'Tümü';

  final _searchController = TextEditingController();
  late Future<List<Product>> _productsFuture;
  String _query = '';
  String _category = _allCategories;

  @override
  void initState() {
    super.initState();
    _productsFuture = const ProductRepository().loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _retry() {
    setState(() => _productsFuture = const ProductRepository().loadProducts());
  }

  List<Product> _filter(List<Product> products) {
    final query = _query.trim().toLowerCase();
    return products.where((product) {
      final inCategory = _category == _allCategories || product.category == _category;
      final matches = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.tagline.toLowerCase().contains(query);
      return inCategory && matches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: EmptyState(
                  icon: Icons.error_outline,
                  title: 'Ürünler yüklenemedi',
                  message: 'Ürün verisi okunurken bir sorun oluştu.',
                  action: OutlinedButton(onPressed: _retry, child: const Text('Tekrar dene')),
                ),
              );
            }
            return _buildCatalog(snapshot.data!);
          },
        ),
      ),
    );
  }

  Widget _buildCatalog(List<Product> products) {
    final theme = Theme.of(context);
    final categories = [_allCategories, ...{for (final p in products) p.category}];
    final visible = _filter(products);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Keşfet', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                  Text('Aradığın cihazı bul.', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
            const CartButton(),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Ürün ara',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _query.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Aramayı temizle',
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  ),
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset('assets/images/banner.png', fit: BoxFit.cover),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: category == _category,
                  onSelected: (_) => setState(() => _category = category),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Text('${visible.length} ürün', style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        if (visible.isEmpty)
          EmptyState(
            icon: Icons.search_off,
            title: 'Sonuç bulunamadı',
            message: 'Farklı bir arama yapmayı ya da kategoriyi değiştirmeyi dene.',
            action: OutlinedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _query = '';
                  _category = _allCategories;
                });
              },
              child: const Text('Filtreleri temizle'),
            ),
          )
        else
          GridView.builder(
            // Sayfanın tamamı tek bir ListView içinde kaydığı için GridView kendi başına kaymaz.
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visible.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, index) => ProductCard(product: visible[index]),
          ),
      ],
    );
  }
}
