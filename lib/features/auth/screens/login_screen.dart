import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/auth_provider.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  void _handleLogin(BuildContext context, String email, String password) async {
    // Dapatkan provider tanpa mendengarkan perubahan state di sini,
    // karena kita hanya memicu aksi.
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    print('LoginScreen: _handleLogin triggered. Calling authProvider.login...');

    await authProvider.login(email, password);
    print('LoginScreen: authProvider.login finished. Status is: ${authProvider.status}');
    // Setelah login selesai, periksa statusnya.
    // Gunakan 'context.mounted' untuk memastikan widget masih ada di tree.
    if (context.mounted && authProvider.status == AuthStatus.error) {
      print('LoginScreen: Login failed. Showing SnackBar.');
      // Jika gagal, tampilkan pesan error dari provider.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          // Gunakan Consumer untuk menampilkan loading atau form
          child: Consumer<AuthProvider>(
            builder: (context, auth, _) {
              if (auth.status == AuthStatus.loading) {
                return const CircularProgressIndicator();
              }
              // Bungkus _handleLogin dalam closure untuk menyertakan context.
              return LoginForm(
                onSubmit: (email, password) =>
                    _handleLogin(context, email, password),
              );
            },
          ),
        ),
      ),
    );
  }
}
