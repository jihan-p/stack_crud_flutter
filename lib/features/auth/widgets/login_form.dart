// lib/components/organisms/login_form.dart

import 'package:flutter/material.dart';
import '../../../components/molecules/forgot_password_screen.dart';
import '../../../components/molecules/input_form_field.dart';
import '../../../components/atoms/primary_button.dart';

class LoginForm extends StatefulWidget {
  // Terima callback untuk logika submit
  final Function(String email, String password) onSubmit;

  const LoginForm({required this.onSubmit, Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Menggunakan InputFormField (Molecule)
        InputFormField(label: 'Email', controller: _emailController),

        // Menggunakan InputFormField (Molecule) untuk Password
        InputFormField(
          label: 'Password',
          controller: _passwordController,
          isPassword: true, // Tambahkan properti ini
        ),

        const SizedBox(height: 24),

        // Menggunakan PrimaryButton (Atom)
        PrimaryButton(
          text: 'Login ke Golang API',
          onPressed: () {
            // Memanggil logika login API dengan data dari controller
            widget.onSubmit(_emailController.text, _passwordController.text);
          },
        ),

        const SizedBox(height: 16),

        // Tautan untuk Lupa Password
        TextButton(
          onPressed: () {
            // Navigasi ke halaman Lupa Password
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ForgotPasswordScreen(),
            ));
          },
          child: const Text('Lupa Password?'),
        ),
      ],
    );
  }
}
