// lib/data/providers/auth_provider.dart

import 'package:stack_crud_flutter/data/services/storage_service.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

// Status untuk mengelola tampilan UI (Loading, Error, Success)
enum AuthStatus { initial, loading, success, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String _errorMessage = '';

  AuthStatus get status => _status;
  User? get user => _user;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _status == AuthStatus.success;

  AuthProvider() {
    tryAutoLogin();
  }

  Future<void> tryAutoLogin() async {
    final token = await _storageService.readToken();
    if (token != null) {
      _status = AuthStatus.success;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    notifyListeners(); // Notify UI to show loading indicator

    try {
      // Panggil Service yang berkomunikasi dengan Golang API
      final Map<String, dynamic> result = await _authService.login(
        email,
        password,
      );

      // TAMBAHKAN INI: Lihat apa isi result
      print('Auth Provider: API result received: $result');

      // PERBAIKAN: Buat Map yang hanya berisi data User dari root JSON
      _user = User.fromJson({
        'id': result['user_id'],
        'email':
            email, // Email diambil dari input, karena tidak ada di response
        'role': result['role'],
        // 'name' tidak ada di model User, jadi kita abaikan untuk saat ini.
        // Jika ingin menambahkannya, update model User terlebih dahulu.
      });

      // Simpan token yang sekarang ada di root response
      final String token = result['token'];
      await _storageService.saveToken(token);

      _status = AuthStatus.success;
      print('AuthProvider: Status changed to SUCCESS. Notifying listeners...');
      _errorMessage = '';
      // KUNCI: Panggil notifyListeners() di akhir blok sukses untuk memicu navigasi.
      notifyListeners();
    } catch (e) {
      // Jika Gagal (misalnya HTTP 401 dari Golang)
      _errorMessage = e.toString();
      _status = AuthStatus.error;
      print('AuthProvider: Status changed to ERROR. Error: $_errorMessage');
      _user = null;
      notifyListeners(); // Notify UI about the error state
      // Re-throw the exception so the UI layer (LoginScreen) can catch it
      // and show a SnackBar.
      throw e;
    }
  }

  // Tambahkan fungsi logout, register, dll. di sini
  Future<void> logout() async {
    // 1. Panggil service untuk menghapus token dari storage
    await _authService.logout();
    // 2. Reset state di provider
    _user = null;
    _status = AuthStatus.initial;
    // 3. Beri tahu UI untuk kembali ke LoginScreen
    notifyListeners();
  }

  Future<void> forgotPassword(String email) async {
    // Gunakan status loading yang sama untuk konsistensi
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      await _authService.forgotPassword(email);
      // Setelah berhasil, kembalikan status ke initial karena pengguna tidak login
      _status = AuthStatus.initial;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      throw e; // Lemparkan kembali error agar UI dapat menampilkannya
    }
  }
}
