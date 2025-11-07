import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // Untuk format input angka
import '../../../data/models/product.dart';
import '../../../data/providers/product_provider.dart';

// Screen ini bisa menerima objek Product, jika ada berarti mode EDIT
class ProductFormScreen extends StatefulWidget {
  final Product? productToEdit; // Jika null = Create, Jika ada = Edit

  const ProductFormScreen({this.productToEdit, Key? key}) : super(key: key);

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  // Key untuk validasi formulir
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk mengambil input pengguna
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Jika ada produk yang akan di-edit, isi controller dengan data lama
    if (widget.productToEdit != null) {
      final p = widget.productToEdit!;
      _nameController.text = p.name;
      _descriptionController.text = p.description ?? ''; // Deskripsi bisa null
      _priceController.text = p.price.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Fungsi yang dipanggil saat tombol Simpan ditekan
  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return; // Gagal validasi, hentikan proses
    }

    setState(() {
      _isLoading = true;
    });

    final provider = Provider.of<ProductProvider>(context, listen: false);
    final data = {
      'name': _nameController.text,
      'description': _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      // Konversi harga menjadi integer karena skema DB Golang Anda adalah INT
      'price': int.tryParse(_priceController.text) ?? 0,
    };

    try {
      if (widget.productToEdit == null) {
        // MODE CREATE: Panggil addProduct (POST ke Golang)
        await provider.addProduct(data);
        _showSuccessSnackbar('Produk berhasil dibuat!');
      } else {
        // MODE EDIT: Panggil updateProduct (PUT/PATCH ke Golang) - Perlu implementasi
        await provider.updateProduct(widget.productToEdit!.id, data);
        _showSuccessSnackbar('Produk berhasil diperbarui!');
      }

      // Kembali ke halaman daftar produk setelah berhasil
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _showErrorSnackbar(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $message'), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.productToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Produk' : 'Buat Produk Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Bidang Nama Produk
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama produk wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Bidang Harga Produk
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Hanya izinkan angka
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga wajib diisi.';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus berupa angka.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Bidang Deskripsi (Text area)
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi (Opsional)',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProduct,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEditing ? 'Simpan Perubahan' : 'Buat Produk'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
