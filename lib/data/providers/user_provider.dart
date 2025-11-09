// lib/data/providers/user_provider.dart

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

enum UserStatus { initial, loading, loaded, error }

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();

  UserStatus _status = UserStatus.initial;
  List<User> _users = [];
  String _errorMessage = '';

  UserStatus get status => _status;
  List<User> get users => _users;
  String get errorMessage => _errorMessage;

  Future<void> loadUsers() async {
    print('UserProvider: Loading users...');
    _status = UserStatus.loading;
    notifyListeners();
    try {
      _users = await _userService.fetchUsers();
      _status = UserStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = UserStatus.error;
      print('UserProvider: Error loading users: $e');
    }
    notifyListeners();
  }

  Future<void> addUser(Map<String, dynamic> data) async {
    print('UserProvider: Attempting to add new user.');
    try {
      final newUser = await _userService.createUser(data);
      _users.insert(0, newUser);
      print('UserProvider: User ${newUser.id} added locally.');
      notifyListeners();
    } catch (e) {
      print('UserProvider: Error adding user: $e');
      _errorMessage = e.toString();
      rethrow;
    }
  }

  Future<void> updateUser(int userId, Map<String, dynamic> data) async {
    print('UserProvider: Attempting to update user $userId');
    try {
      final updatedUser = await _userService.updateUser(userId, data);
      final index = _users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        _users[index] = updatedUser;
        print('UserProvider: User $userId updated locally.');
        notifyListeners();
      }
    } catch (e) {
      print('UserProvider: Error updating user: $e');
      _errorMessage = e.toString();
      notifyListeners(); // Notify listeners about the error state
      rethrow;
    }
  }

  Future<void> deleteUser(int userId) async {
    print('UserProvider: Attempting to delete user $userId');
    try {
      await _userService.deleteUser(userId);
      _users.removeWhere((user) => user.id == userId);
      print('UserProvider: User $userId deleted locally.');
      notifyListeners();
    } catch (e) {
      print('UserProvider: Error deleting user: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      // Tampilkan pesan error hanya jika benar-benar gagal (misalnya 400)
      notifyListeners();
    }
  }
}
