// lib/features/user/screens/user_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/user_provider.dart'; // Pastikan sudah diimpor
import 'user_form_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk memuat data pengguna saat layar dimuat
    Future.microtask(
      () => Provider.of<UserProvider>(context, listen: false).loadUsers(),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  void _showDeleteConfirmationDialog(int userId, String userName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus pengguna "$userName"?',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Provider.of<UserProvider>(
                context,
                listen: false,
              ).deleteUser(userId);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengguna'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Tunggu hasil dari form, lalu muat ulang data
              Navigator.of(context)
                  .push<bool>(
                    MaterialPageRoute(
                      builder: (context) => const UserFormScreen(),
                    ),
                  )
                  .then(
                    (_) => Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).loadUsers(),
                  );
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.status == UserStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userProvider.status == UserStatus.error) {
            return Center(child: Text('Error: ${userProvider.errorMessage}'));
          }

          if (userProvider.users.isEmpty) {
            return const Center(child: Text('Tidak ada data pengguna.'));
          }

          // Tampilkan daftar pengguna
          return ListView.builder(
            itemCount: userProvider.users.length,
            itemBuilder: (context, index) {
              final user = userProvider.users[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(user.role, style: const TextStyle(color: Colors.grey)),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Tunggu hasil dari form, lalu muat ulang data
                        Navigator.of(context)
                            .push<bool>(
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserFormScreen(userToEdit: user),
                              ),
                            )
                            .then(
                              (_) => Provider.of<UserProvider>(
                                context,
                                listen: false,
                              ).loadUsers(),
                            );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteConfirmationDialog(user.id, user.name);
                      },
                    ),
                  ],
                ),
                // onTap tidak diperlukan lagi karena ada tombol aksi
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
