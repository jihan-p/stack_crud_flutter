// lib/data/services/product_service.dart

import 'package:dio/dio.dart';
import 'package:stack_crud_flutter/data/models/product.dart';
import '../http_client.dart'; // Menggunakan Dio Client dengan JWT Interceptor

class ProductService {
  final Dio _dio = HttpClient.dioInstance;

  Future<List<Product>> fetchProducts() async {
    try {
      // Dio Client secara OTOMATIS akan menyertakan JWT dari Secure Storage.
      final response = await _dio.get('/products');

      if (response.statusCode == 200) {
        // Asumsi Golang mengembalikan List<Map> di bawah key 'data'
        final List<dynamic> productData = response.data['data'];

        return productData.map((json) => Product.fromJson(json)).toList();
      }
      throw Exception('Gagal memuat produk dari Golang API');
    } on DioError catch (e) {
      // Tangani error seperti 401 Unauthorized (jika token kadaluarsa)
      throw Exception(e.response?.data['message'] ?? 'Kesalahan koneksi');
    }
  }

  // Tambahkan postProduct, updateProduct, dan deleteProduct di sini
  Future<Product> createProduct(Map<String, dynamic> productData) async {
    try {
      // Mengirim request POST ke Golang API (endpoint /products dilindungi JWT)
      final response = await _dio.post('/products', data: productData);

      if (response.statusCode == 201) {
        // 201 Created adalah response standar untuk POST
        // Asumsi Golang mengembalikan objek produk baru di 'data'
        return Product.fromJson(response.data['data']);
      }
      throw Exception('Gagal membuat produk: ${response.data['message']}');
    } on DioError catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Kesalahan koneksi saat membuat produk',
      );
    }
  }

  // Fungsi DELETE: Hapus Produk berdasarkan ID
  Future<void> deleteProduct(int productId) async {
    try {
      // Mengirim request DELETE ke Golang API (e.g., DELETE /products/1)
      final response = await _dio.delete('/products/$productId');

      if (response.statusCode != 200) {
        // Asumsi Golang mengembalikan status 200 OK jika berhasil
        final errorMessage =
            response.data['message'] ?? 'Gagal menghapus produk.';
        throw Exception(errorMessage);
      }
      // Jika berhasil (status 200), tidak perlu mengembalikan data
    } on DioError catch (e) {
      // Tangani error seperti 401 Unauthorized atau 404 Not Found
      throw Exception(e.response?.data['message'] ?? 'Kesalahan koneksi');
    }
  }

  // Fungsi UPDATE: Memperbarui Produk berdasarkan ID (PUT/PATCH)
  // Kami menggunakan PUT untuk mengirimkan seluruh objek data yang diperlukan
  Future<Product> updateProduct(
    int productId,
    Map<String, dynamic> productData,
  ) async {
    try {
      // Mengirim request PUT ke Golang API (e.g., PUT /products/12)
      final response = await _dio.put(
        '/products/$productId',
        data: productData,
      );

      // Asumsi Golang mengembalikan status 200 OK jika berhasil
      if (response.statusCode == 200) {
        // Asumsi Golang mengembalikan objek produk yang telah diperbarui di 'data'
        return Product.fromJson(response.data['data']);
      }
      throw Exception('Gagal memperbarui produk: ${response.data['message']}');
    } on DioError catch (e) {
      // Tangani error seperti 401 Unauthorized atau 400 Bad Request
      throw Exception(
        e.response?.data['message'] ??
            'Kesalahan koneksi saat memperbarui produk',
      );
    }
  }
}
