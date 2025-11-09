// lib/features/user/screens/user_form_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/user.dart';
import '../../../data/providers/user_provider.dart';

class UserFormScreen extends StatefulWidget {
  final User? userToEdit;

  const UserFormScreen({this.userToEdit, Key? key}) : super(key: key);

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'user'; // Default role

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.userToEdit != null) {
      final u = widget.userToEdit!;
      _nameController.text = u.name;
      _emailController.text = u.email;
      _selectedRole = u.role;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final provider = Provider.of<UserProvider>(context, listen: false);
    final data = {
      'name': _nameController.text,
      'email': _emailController.text,
      'role': _selectedRole,
    };

    // Hanya tambahkan password jika sedang dalam mode CREATE dan password diisi
    if (widget.userToEdit == null && _passwordController.text.isNotEmpty) {
      data['password'] = _passwordController.text;
    }

    try {
      if (widget.userToEdit == null) {
        await provider.addUser(data);
        _showSuccessSnackbar('Pengguna berhasil dibuat!');
      } else {
        await provider.updateUser(widget.userToEdit!.id, data);
        _showSuccessSnackbar('Pengguna berhasil diperbarui!');
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _showErrorSnackbar(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${message.replaceFirst("Exception: ", "")}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.userToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Pengguna' : 'Buat Pengguna Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) => v!.isEmpty ? 'Nama wajib diisi.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty ? 'Email wajib diisi.' : null,
              ),
              const SizedBox(height: 16),
              // Hanya tampilkan field password saat membuat user baru
              if (!isEditing)
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (v) {
                    if (!isEditing && (v == null || v.isEmpty)) {
                      return 'Password wajib diisi saat membuat pengguna baru.';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(labelText: 'Role'),
                items: ['admin', 'user']
                    .map(
                      (role) =>
                          DropdownMenuItem(value: role, child: Text(role)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedRole = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveUser,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEditing ? 'Simpan Perubahan' : 'Buat Pengguna'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
