// lib/features/auth/widgets/forgot_password_form.dart

import 'package:flutter/material.dart';
import '../../../components/atoms/primary_button.dart';
import '../../../components/molecules/input_form_field.dart';

class ForgotPasswordForm extends StatefulWidget {
  final Function(String email) onSubmit;

  const ForgotPasswordForm({required this.onSubmit, Key? key}) : super(key: key);

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Masukkan email Anda untuk menerima link reset password.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
        InputFormField(label: 'Email', controller: _emailController),
        const SizedBox(height: 24),
        PrimaryButton(
            text: 'Kirim Link Reset',
            onPressed: () => widget.onSubmit(_emailController.text)),
      ],
    );
  }
}