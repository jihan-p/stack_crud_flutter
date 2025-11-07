// lib/data/providers/product_provider.dart

import 'package:flutter/material.dart';
import 'package:nama_aplikasi_anda/data/models/product.dart';
import 'package:nama_aplikasi_anda/data/services/product_service.dart';

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
    _status = ProductStatus.loading;
    notifyListeners();

    try {
      _products = await _productService.fetchProducts();
      _status = ProductStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = ProductStatus.error;
    }
    notifyListeners();
  }

  // Fungsi untuk memperbarui produk di API dan daftar lokal
  Future<void> updateProduct(int productId, Map<String, dynamic> data) async {
    // Tidak perlu mengubah status ke loading agar UI tidak berkedip
    // UI di handle oleh _isLoading di ProductFormScreen
    
    try {
      // 1. Panggil Service untuk memperbarui di API Golang
      final updatedProduct = await _productService.updateProduct(productId, data);
      
      // 2. Jika berhasil, temukan index produk lama di daftar _products
      final index = _products.indexWhere((p) => p.id == productId);
      
      if (index != -1) {
        // 3. Ganti objek lama dengan objek yang baru (termasuk updated_at dari Golang)
        _products[index] = updatedProduct;
      }
      
      notifyListeners(); // Perbarui UI (misalnya ProductListScreen)
    } catch (e) {
      _errorMessage = e.toString();
      rethrow; // Lemparkan kembali error agar bisa ditangkap di UI
    }
  }
}