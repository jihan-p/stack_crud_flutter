// lib/components/molecules/input_form_field.dart

import 'package:flutter/material.dart';
import '../atoms/custom_text_field.dart';

class InputFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  // ... Tambahkan validasi dan helper text di sini

  const InputFormField({
    required this.label,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Molecule ini menggunakan Atom CustomTextField
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: CustomTextField(
        label: label,
        controller: controller,
        // ...
      ),
    );
  }
}