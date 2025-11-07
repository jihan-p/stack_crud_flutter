// lib/data/providers/auth_provider.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

// Status untuk mengelola tampilan UI (Loading, Error, Success)
enum AuthStatus { initial, loading, success, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String _errorMessage = '';

  AuthStatus get status => _status;
  User? get user => _user;
  String get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    notifyListeners(); // Beritahu UI untuk menampilkan Loading Indicator

    try {
      // Panggil Service yang berkomunikasi dengan Golang API
      final Map<String, dynamic> result = await _authService.login(email, password);
      
      // Jika berhasil
      _user = User.fromJson(result['user']);
      // Token sudah disimpan di AuthStorage di dalam AuthService
      _status = AuthStatus.success;
      _errorMessage = '';

    } catch (e) {
      // Jika Gagal (misalnya HTTP 401 dari Golang)
      _errorMessage = e.toString();
      _status = AuthStatus.error;
    }
    notifyListeners(); // Beritahu UI untuk mengupdate tampilan (tampilkan User/Error)
  }
  
  // Tambahkan fungsi logout, register, dll. di sini
}