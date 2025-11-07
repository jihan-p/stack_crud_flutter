// lib/features/product/widgets/product_card.dart

import 'package:flutter/material.dart';
import '../../../data/models/product.dart';
import '../screens/product_form_screen.dart';
import '../../../components/atoms/app_typography.dart'; // Atom
import '../../../components/molecules/price_tag.dart'; // Molecule

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Gambar Produk (Placeholder)
            const Icon(Icons.shopping_bag, size: 40, color: Colors.blueGrey),

            const SizedBox(width: 16),

            // Kolom Informasi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Produk (Menggunakan Atom styling)
                  Text(
                    product.name, // Data dari Model/Golang API
                    style: productTitleStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Harga Produk (Menggunakan Molecule)
                  PriceTag(price: product.price), // Data dari Model/Golang API
                ],
              ),
            ),

            // CRUD Aksi (Langkah Selanjutnya)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: () {
                // Navigasi ke ProductFormScreen, membawa produk yang akan di-edit
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductFormScreen(productToEdit: product),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // TODO: Panggil ProductProvider.deleteProduct(product.id)
              },
            ),
          ],
        ),
      ),
    );
  }
}
