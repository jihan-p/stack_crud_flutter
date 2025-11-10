// lib/data/services/auth_service.dart

import 'package:dio/dio.dart';
import 'storage_service.dart'; // Import Storage Service
import '../http_client.dart'; // Import the shared HttpClient
import '../../config/app_config.dart';

class AuthService {
  final Dio _dio = HttpClient.dioInstance; // Use the shared Dio instance
  final StorageService _storage = StorageService(); // Gunakan Storage Service

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '${AppConfig.baseUrl}/auth/login',
        data: {'email': email, 'password': password},
      );

      // DEBUGGING DI SINI
      print('Auth Service: Raw API response data: ${response.data}');

      if (response.statusCode == 200) {
        // On a 200 OK, simply return the data map. Do not throw.
        return response.data;
      } else {
        // This handles non-200 status codes that were not caught by DioException.
        throw Exception(
          'Server returned an unexpected status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      // This block catches network errors and non-2xx status codes (e.g., 401, 500).
      // If e.response is null, it's likely a connection error (timeout, DNS, etc.)
      if (e.response == null) {
        throw Exception(
          'Connection to server failed. Please check the network and server address.',
        );
      }
      // If there is a response, use the server's error message.
      final errorMessage =
          e.response?.data['message'] ?? 'An unknown error occurred';
      throw Exception(errorMessage);
    }
  }

  // Tambahkan fungsi untuk Logout
  Future<void> logout() async {
    await _storage
        .deleteToken(); // Menggunakan metode yang sudah ada untuk menghapus token
    // Jika perlu, panggil endpoint logout di Golang untuk membatalkan sesi/token (opsional)
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        '${AppConfig.baseUrl}/auth/forgot-password',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
          'Server returned an unexpected status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response == null) {
        throw Exception(
          'Connection to server failed. Please check your network.',
        );
      }
      final errorMessage = e.response?.data['message'] ?? 'An unknown error occurred';
      throw Exception(errorMessage);
    }
  }
}
