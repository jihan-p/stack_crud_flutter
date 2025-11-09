// lib/data/services/product_service.dart

import 'package:dio/dio.dart';
import 'package:stack_crud_flutter/data/models/product.dart';
import '../http_client.dart'; // Menggunakan Dio Client dengan JWT Interceptor

class ProductService {
  final Dio _dio = HttpClient.dioInstance;

  Future<List<Product>> fetchProducts() async {
    try {
      // Dio Client secara OTOMATIS akan menyertakan JWT dari Secure Storage.
      print('ProductService: Fetching products...');
      final response = await _dio.get('/products');
      print('ProductService: Raw response from /products: ${response.data}');

      if (response.statusCode == 200) {
        // Periksa apakah respons memiliki data dan data tersebut adalah Map
        if (response.data != null && response.data is Map<String, dynamic>) {
          // Asumsi Golang mengembalikan List<Map> di bawah key 'data'
          final dynamic productData = response.data['data'];

          // Tangani data null atau bukan list dengan aman
          if (productData is List) {
            return productData.map((json) => Product.fromJson(json)).toList();
          }
        }
        // Jika data null, bukan Map, atau key 'data' tidak ada/bukan list, kembalikan list kosong.
        return [];
      }
      throw Exception('Gagal memuat produk dari Golang API');
    } on DioException catch (e) {
      // Tangani error seperti 401 Unauthorized (jika token kadaluarsa)
      print('ProductService: Error fetching products: $e');
      throw Exception(e.response?.data['message'] ?? 'Kesalahan koneksi');
    }
  }

  // Tambahkan postProduct, updateProduct, dan deleteProduct di sini
  Future<Product> createProduct(Map<String, dynamic> productData) async {
    try {
      print('ProductService: Creating product with data: $productData');
      // Mengirim request POST ke Golang API (endpoint /products dilindungi JWT)
      final response = await _dio.post('/products', data: productData);
      print(
        'ProductService: Raw response from POST /products: ${response.data}',
      );

      if (response.statusCode == 201) {
        // 201 Created adalah response standar untuk POST
        // Asumsi Golang mengembalikan objek produk baru di 'data'
        return Product.fromJson(response.data['data']);
      }
      throw Exception('Gagal membuat produk: ${response.data['message']}');
    } on DioException catch (e) {
      print('ProductService: Error creating product: $e');
      throw Exception(
        e.response?.data['message'] ?? 'Kesalahan koneksi saat membuat produk',
      );
    }
  }

  // Fungsi DELETE: Hapus Produk berdasarkan ID
  Future<void> deleteProduct(int productId) async {
    try {
      print('ProductService: Deleting product with ID: $productId');
      // Mengirim request DELETE ke Golang API (e.g., DELETE /products/1)
      final response = await _dio.delete('/products/$productId');
      print(
        'ProductService: Response from DELETE /products/$productId: ${response.statusCode}',
      );

      // KOREKSI UTAMA: Golang umumnya mengembalikan 204 No Content untuk DELETE yang sukses.
      if (response.statusCode != 204) {
        // Jika server mengembalikan status lain, coba baca pesan error dari body.
        final errorMessage =
            response.data?['message'] ?? 'Gagal menghapus produk.';
        throw Exception(errorMessage);
      }
      // Jika 204, tidak ada throw, fungsi keluar dengan sukses.
    } on DioException catch (e) {
      // Tangani error seperti 401 Unauthorized atau 404 Not Found
      print('ProductService: Error deleting product: $e');
      throw Exception(
        e.response?.data?['message'] ?? 'Kesalahan koneksi saat menghapus',
      );
    }
  }

  // Fungsi UPDATE: Memperbarui Produk berdasarkan ID (PUT/PATCH)
  // Kami menggunakan PUT untuk mengirimkan seluruh objek data yang diperlukan
  Future<Product> updateProduct(
    int productId,
    Map<String, dynamic> productData,
  ) async {
    try {
      print(
        'ProductService: Updating product $productId with data: $productData',
      );
      // Mengirim request PUT ke Golang API (e.g., PUT /products/12)
      final response = await _dio.put(
        '/products/$productId',
        data: productData,
      );
      print(
        'ProductService: Raw response from PUT /products/$productId: ${response.data}',
      );

      // Asumsi Golang mengembalikan status 200 OK jika berhasil
      if (response.statusCode == 200) {
        // Asumsi Golang mengembalikan objek produk yang telah diperbarui di 'data'
        return Product.fromJson(response.data['data']);
      }
      throw Exception('Gagal memperbarui produk: ${response.data['message']}');
    } on DioException catch (e) {
      // Tangani error seperti 401 Unauthorized atau 400 Bad Request
      print('ProductService: Error updating product: $e');
      throw Exception(
        e.response?.data['message'] ??
            'Kesalahan koneksi saat memperbarui produk',
      );
    }
  }
}
