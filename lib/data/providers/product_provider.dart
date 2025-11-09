// lib/data/providers/product_provider.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  ProductStatus _status = ProductStatus.initial;
  List<Product> _products = [];
  String _errorMessage = '';

  ProductStatus get status => _status;
  List<Product> get products => _products;
  String get errorMessage => _errorMessage;

  Future<void> loadProducts() async {
    print('ProductProvider: Loading products...');
    _status = ProductStatus.loading;
    notifyListeners();

    try {
      _products = await _productService.fetchProducts();
      _status = ProductStatus.loaded; // Use 'loaded' for success
      print(
        'ProductProvider: Products loaded successfully. Count: ${_products.length}',
      );
    } catch (e) {
      _errorMessage = e.toString();
      _status = ProductStatus.error;
      print('ProductProvider: Error loading products: $e');
    }
    notifyListeners();
  }

  // Fungsi untuk memperbarui produk di API dan daftar lokal
  Future<void> updateProduct(int productId, Map<String, dynamic> data) async {
    // Tidak perlu mengubah status ke loading agar UI tidak berkedip
    // UI di handle oleh _isLoading di ProductFormScreen
    print('ProductProvider: Attempting to update product $productId');

    try {
      // 1. Panggil Service untuk memperbarui di API Golang
      final updatedProduct = await _productService.updateProduct(
        productId,
        data,
      );

      // 2. Jika berhasil, temukan index produk lama di daftar _products
      final index = _products.indexWhere((p) => p.id == productId);

      if (index != -1) {
        // 3. Ganti objek lama dengan objek yang baru (termasuk updated_at dari Golang)
        _products[index] = updatedProduct;
        print('ProductProvider: Product $productId updated locally.');
      }

      notifyListeners(); // Perbarui UI (misalnya ProductListScreen)
    } catch (e) {
      print('ProductProvider: Error updating product: $e');
      _errorMessage = e.toString();
      rethrow; // Lemparkan kembali error agar bisa ditangkap di UI
    }
  }

  // Fungsi untuk menambahkan produk ke API dan daftar lokal
  Future<void> addProduct(Map<String, dynamic> data) async {
    // Tidak perlu mengubah status ke loading agar UI tidak berkedip
    // UI di handle oleh _isLoading di ProductFormScreen
    print('ProductProvider: Attempting to add new product.');
    try {
      // 1. Panggil Service untuk membuat di API Golang
      final newProduct = await _productService.createProduct(data);

      // 2. Jika berhasil, tambahkan produk baru ke bagian awal daftar lokal
      _products.insert(0, newProduct);
      print('ProductProvider: Product ${newProduct.id} added locally.');

      notifyListeners(); // Perbarui UI
    } catch (e) {
      print('ProductProvider: Error adding product: $e');
      _errorMessage = e.toString();
      rethrow; // Lemparkan kembali error agar bisa ditangkap di UI
    }
  }

  // Fungsi untuk menghapus produk dari API dan daftar lokal
  Future<void> deleteProduct(int productId) async {
    try {
      print('ProductProvider: Attempting to delete product $productId');
      // 1. Panggil Service untuk menghapus di API Golang
      await _productService.deleteProduct(productId);

      // 2. Jika berhasil, hapus produk dari daftar lokal
      _products.removeWhere((p) => p.id == productId);
      print('ProductProvider: Product $productId deleted locally.');

      notifyListeners(); // Perbarui UI
    } catch (e) {
      print('ProductProvider: Error deleting product: $e');
      // Simpan pesan error untuk ditampilkan di UI jika perlu.
      // Hapus 'Exception: ' dari awal pesan.
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
  }
}
