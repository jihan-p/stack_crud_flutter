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

    try {
      // Panggil Service yang berkomunikasi dengan Golang API
      final Map<String, dynamic> result = await _authService.login(
        email,
        password,
      );

      // Jika berhasil
      _user = User.fromJson(result['user']);
      // Token sudah disimpan di StorageService di dalam AuthService
      _status = AuthStatus.success;
      print('AuthProvider: Status changed to SUCCESS. Notifying listeners...');
      _errorMessage = '';
    } catch (e) {
      // Jika Gagal (misalnya HTTP 401 dari Golang)
      _errorMessage = e.toString();
      _status = AuthStatus.error;
      print('AuthProvider: Status changed to ERROR. Error: $_errorMessage');
      // Pastikan untuk menghapus data user jika login gagal
      _user = null;
    }
    notifyListeners(); // Beritahu UI untuk mengupdate tampilan (tampilkan User/Error)
  }

  // Tambahkan fungsi logout, register, dll. di sini
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _status = AuthStatus.initial;
    notifyListeners();
  }
}
