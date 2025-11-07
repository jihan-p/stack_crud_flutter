// lib/features/product/widgets/product_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/product_provider.dart';
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
              onPressed: () async {
                // Tampilkan dialog konfirmasi sebelum menghapus
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: Text(
                      'Anda yakin ingin menghapus "${product.name}"?',
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Batal'),
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                      TextButton(
                        child: const Text(
                          'Hapus',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () => Navigator.of(ctx).pop(true),
                      ),
                    ],
                  ),
                );

                // Jika pengguna menekan "Hapus"
                if (confirm == true) {
                  try {
                    // Panggil provider untuk menghapus produk
                    await Provider.of<ProductProvider>(
                      context,
                      listen: false,
                    ).deleteProduct(product.id);
                    // Tampilkan notifikasi sukses
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('"${product.name}" berhasil dihapus.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    // Tampilkan notifikasi error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal menghapus: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
