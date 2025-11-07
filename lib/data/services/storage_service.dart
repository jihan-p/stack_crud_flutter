// lib/data/services/storage_service.dart
// Menggunakan flutter_secure_storage (asumsi package sudah di-install)

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();
  static const _keyToken = 'jwt_token';

  // Menyimpan JWT
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  // Membaca JWT
  Future<String?> readToken() async {
    return await _storage.read(key: _keyToken);
  }

  // Menghapus JWT (Logout)
  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }
}
