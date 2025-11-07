// lib/features/product/screens/product_list_screen.dart

import 'package:stack_crud_flutter/data/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Panggil fungsi load saat inisialisasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProductFormScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Panggil fungsi logout dari AuthProvider
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.status == ProductStatus.loading &&
              provider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.status == ProductStatus.error &&
              provider.products.isEmpty) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }
          return ListView.builder(
            itemCount: provider.products.length,
            itemBuilder: (ctx, i) => ProductCard(product: provider.products[i]),
          );
        },
      ),
    );
  }
}
