// lib/components/organisms/login_form.dart

import 'package:flutter/material.dart';
import '../molecules/input_form_field.dart';
import '../atoms/primary_button.dart';

class LoginForm extends StatelessWidget {
  // Terima callback untuk logika submit
  final VoidCallback onSubmit;

  const LoginForm({required this.onSubmit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // State management controller (dari BLoC/Provider) diimplementasikan di sini

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Menggunakan InputFormField (Molecule)
        InputFormField(label: 'Email', controller: TextEditingController()),
        
        // Menggunakan InputFormField (Molecule) untuk Password
        InputFormField(label: 'Password', controller: TextEditingController()),

        const SizedBox(height: 24),

        // Menggunakan PrimaryButton (Atom)
        PrimaryButton(
          text: 'Login ke Golang API',
          onPressed: onSubmit, // Memanggil logika login API
        ),
      ],
    );
  }
}