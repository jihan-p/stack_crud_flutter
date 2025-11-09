// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Providers Anda
import 'data/providers/auth_provider.dart';
import 'data/providers/product_provider.dart';

// Import Screens (Halaman Awal)
import 'features/auth/screens/login_screen.dart';
import 'features/product/screens/product_list_screen.dart'; // Akan digunakan setelah login

void main() {
  // 1. Pastikan Flutter Binding sudah diinisialisasi (penting untuk Secure Storage)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Wrap aplikasi dengan MultiProvider untuk menyediakan semua state
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: const MyApp(), // Panggil root widget Anda
    ),
  );
}

// 3. Definisi Root Widget Anda
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Di sini kita akan menggunakan Conditional Routing (Navigasi Bersyarat)
    // untuk menentukan halaman mana yang pertama kali ditampilkan:
    // LoginScreen (jika belum login) atau ProductListScreen (jika sudah login).

    return MaterialApp(
      title: 'CRUD Golang Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      // Gunakan Consumer untuk mendengarkan perubahan pada AuthProvider
      home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          print(
            'Main Consumer: Rebuilding UI. IsLoggedIn = ${auth.isLoggedIn}',
          );

          // Navigasi Bersyarat
          if (auth.isLoggedIn) {
            return const ProductListScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
