// lib/data/services/auth_service.dart

import 'package:dio/dio.dart';
import 'storage_service.dart'; // Import Storage Service
import '../../config/app_config.dart';

class AuthService {
  final Dio _dio = Dio();
  final StorageService _storage = StorageService(); // Gunakan Storage Service

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post('${AppConfig.baseUrl}/auth/login', 
      data: {'email': email, 'password': password});

    if (response.statusCode == 200 && response.data['success'] == true) {
      final String accessToken = response.data['data']['access_token'];
      // ASPEK KRUSIAL: Menyimpan token dengan aman
      await _storage.saveToken(accessToken); 
      
      // Kembalikan data user ke AuthProvider
      return response.data['data']; 
    } else {
      final errorMessage = response.data['message'] ?? 'Gagal login ke API Golang';
      throw Exception(errorMessage);
    }
  }

  // Tambahkan fungsi untuk Logout
  Future<void> logout() async {
    await _storage.clearTokens();
    // Jika perlu, panggil endpoint logout di Golang untuk membatalkan sesi/token (opsional)
  }
}