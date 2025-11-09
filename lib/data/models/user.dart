// lib/data/models/user.dart
class User {
  final int id;
  final String name;
  final String email;
  final String role;
  // ... tambahkan properti lain yang dibutuhkan
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'] ?? 0,
      name: json['Name'] ?? '',
      email: json['Email'] ?? '',
      role: json['Role'] ?? '',
    );
  }
  // Tambahkan toJson() untuk operasi CREATE/UPDATE
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'role': role};
  }
}
