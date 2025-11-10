// lib/components/molecules/input_form_field.dart

import 'package:flutter/material.dart';
import '../../../components/atoms/custom_text_field.dart';

class InputFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;

  const InputFormField({
    required this.label,
    required this.controller,
    this.isPassword = false, // Tambahkan parameter ini
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomTextField(
        label: label,
        controller: controller,
        isPassword: isPassword, // Teruskan ke CustomTextField
      ),
    );
  }
}