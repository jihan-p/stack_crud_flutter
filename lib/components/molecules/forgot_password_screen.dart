// lib/features/auth/screens/forgot_password_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/auth_provider.dart';
import 'forgot_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  Future<void> _handleForgotPassword(BuildContext context, String email) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.forgotPassword(email);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jika email terdaftar, link reset akan dikirim.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
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
      appBar: AppBar(
        title: const Text('Lupa Password'),
      ),
      body: Center(
        child: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (auth.status == AuthStatus.loading) {
              return const CircularProgressIndicator();
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ForgotPasswordForm(
                  onSubmit: (email) => _handleForgotPassword(context, email)),
            );
          },
        ),
      ),
    );
  }
}