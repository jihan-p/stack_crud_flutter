// lib/data/models/user.dart
class User {
  final int id;
  final String email;
  final String role;
  // ... tambahkan properti lain yang dibutuhkan
  User({required this.id, required this.email, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      role: json['role'],
    );
  }
}