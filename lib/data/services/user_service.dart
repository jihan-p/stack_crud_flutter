// lib/data/services/user_service.dart

import 'package:dio/dio.dart';
import '../http_client.dart';
import '../models/user.dart'; // Pastikan model User diimpor

class UserService {
  final Dio _dio = HttpClient.dioInstance;

  Future<List<User>> fetchUsers() async {
    try {
      // KOREKSI: Ubah '/users' menjadi '/admin/users'
      final response = await _dio.get('/admin/users');
      print('UserService: Raw response from /admin/users: ${response.data}');

      if (response.statusCode == 200) {
        // Asumsi Golang mengembalikan List<Map> di bawah key 'data'
        final dynamic userData = response.data['data'];

        if (userData is List) {
          return userData.map((json) => User.fromJson(json)).toList();
        }
      }
      return []; // Kembalikan list kosong jika data tidak valid
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Gagal memuat daftar pengguna.',
      );
    }
  }

  // Tambahkan fungsi createUser(), updateUser(), dan deleteUser() di sini
  // CREATE: Membuat pengguna baru
  Future<User> createUser(Map<String, dynamic> userData) async {
    try {
      print('UserService: Creating user with data: $userData');
      // Endpoint: POST /admin/users
      final response = await _dio.post('/admin/users', data: userData);
      print(
        'UserService: Raw response from POST /admin/users: ${response.data}',
      );
      if (response.statusCode == 201) {
        return User.fromJson(response.data['data']);
      }
      throw Exception('Gagal membuat pengguna.');
    } on DioException catch (e) {
      print('UserService: Error creating user: $e');
      throw Exception(
        e.response?.data?['message'] ?? 'Kesalahan saat membuat pengguna.',
      );
    }
  }

  // UPDATE: Memperbarui pengguna berdasarkan ID
  Future<User> updateUser(int userId, Map<String, dynamic> userData) async {
    try {
      print('UserService: Updating user $userId with data: $userData');
      // Endpoint: PUT /admin/users/:id
      final response = await _dio.put('/admin/users/$userId', data: userData);
      print(
        'UserService: Raw response from PUT /admin/users/$userId: ${response.data}',
      );
      if (response.statusCode == 200) {
        // GOLANG HANYA MENGEMBALIKAN MESSAGE, BUKAN DATA PENGGUNA BARU.
        // Solusi: Ambil data pengguna yang dikirim (userData) dan tambahkan ID.
        // Ini mengasumsikan operasi PUT Golang berhasil memperbarui data yang dikirim.

        // Karena Golang hanya kirim {message: ...}, kita buat objek User dari data input:
        final Map<String, dynamic> updatedData = Map.from(userData);
        updatedData['ID'] = userId; // Tambahkan ID yang sudah diketahui

        return User.fromJson(updatedData); // Gunakan data input
      }
      throw Exception(
        response.data?['message'] ?? 'Gagal memperbarui pengguna.',
      );
    } on DioException catch (e) {
      print('UserService: Error updating user: $e');
      throw Exception(
        e.response?.data?['message'] ?? 'Kesalahan saat memperbarui pengguna.',
      );
    }
  }

  // DELETE: Menghapus pengguna berdasarkan ID
  Future<void> deleteUser(int userId) async {
    try {
      print('UserService: Deleting user with ID: $userId');
      // Endpoint: DELETE /admin/users/:id
      final response = await _dio.delete('/admin/users/$userId');
      print(
        'UserService: Response from DELETE /admin/users/$userId: ${response.statusCode}',
      );
      // Jika 200 OK atau 204 No Content, kita asumsikan berhasil.
      if (response.statusCode == 200 || response.statusCode == 204) {
        return; // Berhasil, keluar dari fungsi tanpa throw.
      }
      // Jika status lain, throw error
      throw Exception(response.data?['message'] ?? 'Gagal menghapus pengguna.');
    } on DioException catch (e) {
      print('UserService: Error deleting user: $e');
      throw Exception(
        e.response?.data?['message'] ?? 'Kesalahan koneksi saat delete',
      );
    }
  }
}
