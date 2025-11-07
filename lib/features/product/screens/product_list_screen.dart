// lib/features/product/screens/product_list_screen.dart

import 'package:provider/provider.dart';
// ... import ProductProvider dan ProductCard (Organism)

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Panggil fungsi load saat inisialisasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });

    final provider = context.watch<ProductProvider>();

    if (provider.status == ProductStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.status == ProductStatus.error) {
      return Center(child: Text('Error: ${provider.errorMessage}'));
    }

    // Tampilkan data produk
    return ListView.builder(
      itemCount: provider.products.length,
      itemBuilder: (context, index) {
        final product = provider.products[index];
        // ProductCard adalah Organism dari Atomic Design Anda
        return ProductCard(product: product); 
      },
    );
  }
}