import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/auth_provider.dart';
import '../../product/screens/product_list_screen.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await authProvider.login(email, password);

    // Setelah await selesai, periksa status dari provider
    if (mounted) {
      if (authProvider.status != AuthStatus.success) {
        // Jika gagal, tampilkan pesan error dari provider
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage),
            backgroundColor: Colors.red,
          ),
        );
        // Set _isLoading kembali ke false hanya jika terjadi error
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // Tambahkan padding
          child: _isLoading
              ? const CircularProgressIndicator()
              : LoginForm(onSubmit: _handleLogin),
        ),
      ),
    );
  }
}
