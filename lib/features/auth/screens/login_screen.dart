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

    try {
      await authProvider.login(email, password);
      // Jika kode sampai di sini, berarti login berhasil dan navigasi
      // akan ditangani oleh Consumer di main.dart. Tidak perlu aksi di sini.
      print('LoginScreen: Login call successful. Awaiting navigation...');
    } catch (e) {
      // Jika AuthProvider melempar exception, tangkap di sini.
      if (context.mounted) {
        print('LoginScreen: Login failed. Showing SnackBar with error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
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
